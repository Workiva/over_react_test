// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:html';
import 'dart:svg';

import 'package:over_react/over_react.dart';
import 'package:matcher/matcher.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

import './prop_type_util.dart';

/// Match a list of class names on a component
class ClassNameMatcher extends Matcher {
  ClassNameMatcher.expected(_expectedClasses, {this.allowExtraneous = true}) :
    expectedClasses = getClassIterable(_expectedClasses).toSet(),
    unexpectedClasses = {};


  ClassNameMatcher.unexpected(_unexpectedClasses) :
    unexpectedClasses = getClassIterable(_unexpectedClasses).toSet(),
    allowExtraneous = true,
    expectedClasses = {};

  // Class names that are expected
  final Set expectedClasses;
  // Class names that we do not want
  final Set unexpectedClasses;
  /// Whether or not to allow extraneous classes (classes not specified in expectedClasses).
  final bool allowExtraneous;

  static Iterable getClassIterable(dynamic classNames) {
    Iterable classes;
    if (classNames is Iterable<String>) {
      classes = classNames.where((className) => className != null).expand(splitSpaceDelimitedString);
    } else if (classNames is String) {
      classes = splitSpaceDelimitedString(classNames);
    } else {
      throw ArgumentError.value(classNames, 'Must be a list of classNames or a className string', 'classNames');
    }

    return classes;
  }

  @override
  bool matches(className, Map matchState) {
    // There's a bug in DDC where, though the docs say `className` should
    // return `String`, it will return `AnimatedString` for `SvgElement`s. See
    // https://github.com/dart-lang/sdk/issues/36200.
    String castClassName;
    if (className is String) {
      castClassName = className;
    } else if (className is AnimatedString) {
      castClassName = className.baseVal;
    } else {
      throw ArgumentError.value(className, 'Must be a string type');
    }

    Iterable actualClasses = getClassIterable(castClassName);
    Set missingClasses = expectedClasses.difference(actualClasses.toSet());
    Set unwantedClasses = unexpectedClasses.intersection(actualClasses.toSet());

    // Calculate extraneous classes with Lists instead of Sets, to catch duplicates in actualClasses.
    List expectedClassList = expectedClasses.toList();
    List extraneousClasses = actualClasses
                             .where((className) => !expectedClassList.remove(className))
                             .toList();

    matchState.addAll({
      'missingClasses': missingClasses,
      'unwantedClasses': unwantedClasses,
      'extraneousClasses': extraneousClasses
    });

    if (allowExtraneous) {
      return missingClasses.isEmpty && unwantedClasses.isEmpty;
    } else {
      return missingClasses.isEmpty && extraneousClasses.isEmpty;
    }
  }

  @override
  Description describe(Description description) {
    List<String> descriptionParts = [];
    if (allowExtraneous) {
      if (expectedClasses.isNotEmpty) {
        descriptionParts.add('has the classes: $expectedClasses');
      }
      if (unexpectedClasses.isNotEmpty) {
        descriptionParts.add('does not have the classes: $unexpectedClasses');
      }
    } else {
      descriptionParts.add('has ONLY the classes: $expectedClasses');
    }
    description.add(descriptionParts.join(' and '));

    return description;
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    Set missingClasses = matchState['missingClasses'];
    Set unwantedClasses = matchState['unwantedClasses'];
    List extraneousClasses = matchState['extraneousClasses'];

    List<String> descriptionParts = [];
    if (allowExtraneous) {
      if (unwantedClasses.isNotEmpty) {
        descriptionParts.add('has unwanted classes: $unwantedClasses');
      }
    } else {
      if (extraneousClasses.isNotEmpty) {
        descriptionParts.add('has extraneous classes: $extraneousClasses');
      }
    }

    if (missingClasses.isNotEmpty) {
      descriptionParts.add('is missing classes: $missingClasses');
    }

    mismatchDescription.add(descriptionParts.join('; '));

    return mismatchDescription;
  }
}

class IsNode extends CustomMatcher {
  IsNode(matcher) : super("Element with nodeName that is", "nodeName", matcher);
  @override
  featureValueOf(covariant Element actual) => actual.nodeName;
}

class _ElementClassNameMatcher extends CustomMatcher {
  _ElementClassNameMatcher(matcher) : super('Element that', 'className', matcher);
  @override
  featureValueOf(covariant Element actual) => actual.className;
}
class _ElementAttributeMatcher extends CustomMatcher {
  _ElementAttributeMatcher(String attributeName, matcher) :
        _attributeName = attributeName,
        super('Element with "$attributeName" attribute that equals', 'attributes', matcher);

  String _attributeName;

  @override
  featureValueOf(covariant Element element) => element.getAttribute(_attributeName);
}

class _HasToStringValue extends CustomMatcher {
  _HasToStringValue(matcher) : super('Object with toString() value', 'toString()', matcher);

  @override
  featureValueOf(Object item) => item.toString();
}

class _HasPropMatcher extends CustomMatcher {
  _HasPropMatcher(propKey, propValue)
      : _propKey = propKey,
        super('React instance with props that', 'props/attributes map', containsPair(propKey, propValue));

  final dynamic _propKey;

  static bool _useDomAttributes(item) => react_test_utils.isDOMComponent(item);

  static bool _isValidDomPropKey(propKey) => (
      DomPropsMixin.meta.keys.contains(propKey) ||
      SvgPropsMixin.meta.keys.contains(propKey) ||
      (propKey is String && (
          propKey.startsWith('data-') ||
          propKey.startsWith('aria-'))
      )
  );

  @override
  Map featureValueOf(item) {
    if (_useDomAttributes(item)) return findDomNode(item).attributes;
    if (item is react.Component) return item.props;

    return getProps(item);
  }

  @override
  bool matches(item, Map matchState) {
    /// Short-circuit null items to avoid errors in `containsPair`.
    if (item == null) return false;

    if (_useDomAttributes(item) && !_isValidDomPropKey(_propKey)) {
      matchState['unsupported'] =
          'Cannot verify whether the `$_propKey` prop is available on a DOM ReactComponent. '
          'Only props in `DomPropsMixin`/`SvgPropsMixin` or starting with "data-"/"aria-" are supported.';

      return false;
    }

    return super.matches(item, matchState);
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    /// Short-circuit null items to avoid errors in `containsPair`.
    if (item == null) return mismatchDescription;

    if (matchState['unsupported'] != null) {
      return mismatchDescription..add(matchState['unsupported']);
    }

    return super.describeMismatch(item, mismatchDescription, matchState, verbose);
  }
}

/// Returns a matcher that matches an element that has [classes].
Matcher hasClasses(classes) => _ElementClassNameMatcher(ClassNameMatcher.expected(classes));
/// Returns a matcher that matches an element that has [classes], with no additional or duplicated classes.
Matcher hasExactClasses(classes) => _ElementClassNameMatcher(ClassNameMatcher.expected(classes, allowExtraneous: false));
/// Returns a matcher that matches an element that does not have [classes].
Matcher excludesClasses(classes) => _ElementClassNameMatcher(ClassNameMatcher.unexpected(classes));
/// Returns a matcher that matches an element that has [attributeName] set to [value].
Matcher hasAttr(String attributeName, value) => _ElementAttributeMatcher(attributeName, wrapMatcher(value));
/// Returns a matcher that matches an element with the nodeName of [nodeName].
Matcher hasNodeName(String nodeName) => IsNode(equalsIgnoringCase(nodeName));

/// Returns a matcher that matches Dart, JS composite, and DOM `ReactElement`s and `ReactComponent`s
/// that contain the prop pair ([propKey], propValue).
///
/// Since props of DOM `ReactComponent`s cannot be read directly, the element's attributes are matched instead.
///
/// This matcher will always fail when unsupported prop keys are tested against a DOM `ReactComponent`.
///
/// TODO: add support for prop keys that aren't the same as their attribute keys
Matcher hasProp(dynamic propKey, dynamic propValue) => _HasPropMatcher(propKey, propValue);

/// Returns a matcher that matches an object whose `toString` value matches [value].
Matcher hasToStringValue(value) => _HasToStringValue(value);

class _IsFocused extends Matcher {
  const _IsFocused();

  @override
  Description describe(Description description) {
    return description
      ..add('is focused');
  }

  @override
  bool matches(item, Map matchState) {
    matchState['activeElement'] = document.activeElement;

    return item != null && item == document.activeElement;
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Element) {
      return mismatchDescription
        ..add('is not a valid Element.');
    }

    if (!document.documentElement.contains(item)) {
      return mismatchDescription
        ..add('is not attached to the document, and thus cannot be focused.')
        ..add(' If testing with React, you can use `renderAttachedToDocument`.');
    }

    mismatchDescription.add('is not focused; ');

    final activeElement = matchState['activeElement'];
    if (activeElement is! Element || activeElement == document.body) {
      mismatchDescription.add('there is no element currently focused');
    } else {
      mismatchDescription
        ..add('the currently focused element is ')
        ..addDescriptionOf(activeElement);
    }

    return mismatchDescription;
  }
}

/// A matcher that matches the currently focused element (`document.activeElement`).
const Matcher isFocused = _IsFocused();

/// A matcher to verify that a [PropError] is thrown with a provided `propName` and `message`.
///
/// __Note__: The message is matched rather than the [Error] instance due to Dart's wrapping of all `throw`
///  as a [DomException]
Matcher throwsPropError(String propName, [String message = '']) {
  return throwsA(anyOf(
      hasToStringValue('V8 Exception'), /* workaround for https://github.com/dart-lang/sdk/issues/26093 */
      hasToStringValue(contains('PropError: Prop $propName. $message'.trim()))
  ));
}

/// A matcher to verify that a [PropError].required is thrown with a provided `propName` and `message`.
///
/// __Note__: The message is matched rather than the [Error] instance due to Dart's wrapping of all `throw`
///  as a [DomException]
Matcher throwsPropError_Required(String propName, [String message = '']) {
  return throwsA(anyOf(
      hasToStringValue('V8 Exception'), /* workaround for https://github.com/dart-lang/sdk/issues/26093 */
      hasToStringValue(contains('RequiredPropError: Prop $propName is required. $message'.trim()))
  ));
}

/// A matcher to verify that a [PropError].value is thrown with a provided `invalidValue`, `propName`, and `message`.
///
/// __Note__: The message is matched rather than the [Error] instance due to Dart's wrapping of all `throw`
///  as a [DomException]
Matcher throwsPropError_Value(dynamic invalidValue, String propName, [String message = '']) {
  return throwsA(anyOf(
      hasToStringValue('V8 Exception'), /* workaround for https://github.com/dart-lang/sdk/issues/26093 */
      hasToStringValue(contains('InvalidPropValueError: Prop $propName set to $invalidValue. '
          '$message'.trim()
      ))
  ));
}

/// A matcher to verify that a [PropError] is thrown with a provided `propName`, `prop2Name`, and `message`.
///
/// __Note__: The message is matched rather than the [Error] instance due to Dart's wrapping of all `throw`
///  as a [DomException]
Matcher throwsPropError_Combination(String propName, String prop2Name, [String message = '']) {
  return throwsA(anyOf(
      hasToStringValue('V8 Exception'), /* workaround for https://github.com/dart-lang/sdk/issues/26093 */
      hasToStringValue(contains('InvalidPropCombinationError: Prop $propName and prop $prop2Name are set to '
          'incompatible values. $message'.trim()
      ))
  ));
}

/// A log matcher that captures logs and uses an expected matcher or `String` to compare
/// against the actual `List` of logs.
///
/// The primary use case of the matcher is to take in a callback as the actual,
/// and pass it to [recordConsoleLogs] to run the function and record the resulting
/// logs that are emitted during the function runtime.
class _LoggingFunctionMatcher extends CustomMatcher {
  _LoggingFunctionMatcher(dynamic matcher, {this.config, description, name})
      : super(description ?? 'emits the logs', name ?? 'logs', wrapMatcher(matcher));

  final ConsoleConfiguration config;

  @override
  featureValueOf(actual) {
    var logs = <String>[];

    if (actual is List) return actual;

    if (actual is! Function()) {
      throw ArgumentError('The actual value must be a callback or a List.');
    }

    logs = recordConsoleLogs(actual, configuration: config ?? logConfig);

    return logs;
  }
}

/// A Matcher used to compare a list of logs against a provided `String`.
///
/// Takes in a specific `String` and passes as long as the actual list of logs
/// contains the expected `String` at any index.
///
/// Related: [emitsLogs], [emitsNoLogs]
Matcher emitsLog(String expected, {ConsoleConfiguration consoleConfig}) =>
    _LoggingFunctionMatcher(anyElement(contains(expected)), config: consoleConfig);

/// A Matcher used to compare a list of logs against a provided matcher.
///
/// __Examples:__
///
/// To look for a specific `String` in any log index, the best solution is to use
/// [emitsLog], but the behavior can be mimicked by passing in the correct `Iterable`
/// matchers.
/// ```dart
///   expect(callbackFunction, emitsLogs(anyElement(contains('I expect this log'))));
/// ```
///
/// When passed a `List`, the matcher will do an equality check on the actual
/// log `List`.
///
/// Alternatively, the `String` can be wrapped in a `contains` to check the
/// if the comparable index contains that substring.
/// ```dart
///   expect(callbackFunction, emitsLogs(['I expect this log', 'And this Log']));
///   expect(callbackFunction, emitsLogs([
///     contains('I expect'),
///     contains('And this'),
///   ]));
/// ```
///
/// All usual `Iterable` matchers can also be used.
/// ```dart
///   expect(callbackFunction, emitsLogs(containsAll(['I expect this log'])));
///   expect(callbackFunction, emitsLogs(containsAllInOrder(['I expect this log'])));
///   expect(callbackFunction, emitsLogs(hasLength(1)));
/// ```
///
/// Related: [emitsLog], [emitsNoLogs]
Matcher emitsLogs(dynamic expected, {ConsoleConfiguration consoleConfig}) =>
    _LoggingFunctionMatcher(expected, config: consoleConfig);

/// A matcher to verify that a callback function does not emit any logs.
///
/// Related: [emitsLogs]
final Matcher emitsNoLogs = _LoggingFunctionMatcher(isEmpty);

/// The string used to identify a `propType` error.
const _propTypeErrorMessage = 'Failed prop type';

/// A matcher used to assert an actual `List` contains expected `propType`
/// warnings.
///
/// The actual value can be a callback function, which will result in the matcher
/// asserting that the expected `propType` warnings appear during the runtime
/// of the callback.
///
/// Related: [_LoggingFunctionMatcher]
class _PropTypeLogMatcher extends _LoggingFunctionMatcher {
  _PropTypeLogMatcher(expected)
      : super(expected,
      description: 'emits the propType warning',
      name: 'propType warning');

  final _filter = contains(_propTypeErrorMessage);

  @override
  featureValueOf(actual) {
    if (actual is! Function() && actual is! List) {
      throw ArgumentError('The actual value must be a callback or a List.');
    }

    var logs = actual is List ? actual : recordConsoleLogs(actual, configuration: errorConfig);
    return logs.where((log) => _filter.matches(log, {})).toList();
  }
}

/// Matcher used to check for a specific `propType` warning being emitted during
/// the runtime of a callback function.
///
/// Has the same underlying logic as [emitsLog], with the difference being that
/// console configuration is set to `errorConfig` and non-propType related warnings
/// are filtered out of the list.
///
/// Related: [emitsPropTypeWarnings], [emitsNoPropTypeWarnings], [emitsLog]
_PropTypeLogMatcher emitsPropTypeWarning(String expected) =>
    _PropTypeLogMatcher(anyElement(contains(expected)));

/// Matcher used to check for specific `propType` warnings being emitted during
/// the runtime of a callback function.
///
/// Has the same underlying logic as [emitsLogs], with the difference being that
/// console configuration is set to `errorConfig` and non-propType related warnings
/// are filtered out of the list.
///
/// Related: [emitsPropTypeWarning], [emitsNoPropTypeWarnings], [emitsLogs]
_PropTypeLogMatcher emitsPropTypeWarnings(dynamic expected) =>
    _PropTypeLogMatcher(expected);

/// Matcher used enforce that there are no `propType` warnings.
///
/// Related: [emitsPropTypeWarning], [emitsPropTypeWarnings]
final _PropTypeLogMatcher emitsNoPropTypeWarnings = _PropTypeLogMatcher(isEmpty);
