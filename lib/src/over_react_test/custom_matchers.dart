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

import 'dart:developer';
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
  ClassNameMatcher.expected(_expectedClasses, {this.allowExtraneous: true}) :
    this.expectedClasses = getClassIterable(_expectedClasses).toSet(),
    this.unexpectedClasses = new Set();


  ClassNameMatcher.unexpected(_unexpectedClasses) :
    this.unexpectedClasses = getClassIterable(_unexpectedClasses).toSet(),
    this.allowExtraneous = true,
    this.expectedClasses = new Set();

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
      throw new ArgumentError.value(classNames, 'Must be a list of classNames or a className string', 'classNames');
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
      throw new ArgumentError.value(className, 'Must be a string type');
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
  String _attributeName;

  _ElementAttributeMatcher(String attributeName, matcher) :
      this._attributeName = attributeName,
      super('Element with "$attributeName" attribute that equals', 'attributes', matcher);

  @override
  featureValueOf(covariant Element element) => element.getAttribute(_attributeName);
}

class _HasToStringValue extends CustomMatcher {
  _HasToStringValue(matcher) : super('Object with toString() value', 'toString()', matcher);

  @override
  featureValueOf(Object item) => item.toString();
}

class _HasPropMatcher extends CustomMatcher {
  final dynamic _propKey;

  _HasPropMatcher(propKey, propValue)
      : this._propKey = propKey,
        super('React instance with props that', 'props/attributes map', containsPair(propKey, propValue));

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
Matcher hasClasses(classes) => new _ElementClassNameMatcher(new ClassNameMatcher.expected(classes));
/// Returns a matcher that matches an element that has [classes], with no additional or duplicated classes.
Matcher hasExactClasses(classes) => new _ElementClassNameMatcher(new ClassNameMatcher.expected(classes, allowExtraneous: false));
/// Returns a matcher that matches an element that does not have [classes].
Matcher excludesClasses(classes) => new _ElementClassNameMatcher(new ClassNameMatcher.unexpected(classes));
/// Returns a matcher that matches an element that has [attributeName] set to [value].
Matcher hasAttr(String attributeName, value) => new _ElementAttributeMatcher(attributeName, wrapMatcher(value));
/// Returns a matcher that matches an element with the nodeName of [nodeName].
Matcher hasNodeName(String nodeName) => new IsNode(equalsIgnoringCase(nodeName));

/// Returns a matcher that matches Dart, JS composite, and DOM `ReactElement`s and `ReactComponent`s
/// that contain the prop pair ([propKey], propValue).
///
/// Since props of DOM `ReactComponent`s cannot be read directly, the element's attributes are matched instead.
///
/// This matcher will always fail when unsupported prop keys are tested against a DOM `ReactComponent`.
///
/// TODO: add support for prop keys that aren't the same as their attribute keys
Matcher hasProp(dynamic propKey, dynamic propValue) => new _HasPropMatcher(propKey, propValue);

/// Returns a matcher that matches an object whose `toString` value matches [value].
Matcher hasToStringValue(value) => new _HasToStringValue(value);

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
const Matcher isFocused = const _IsFocused();

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

/// PropTypes matcher
/// TODO name?
class _PropTypeLogMatcher extends Matcher {

  // can be warning or matcher
  final _expected;

  final _hasOneWarning;

  final _expectsWarning;

  _PropTypeLogMatcher.logsPropTypeWarning(/*String || Contains*/ this._expected)
      : _hasOneWarning = true, _expectsWarning = true;

  _PropTypeLogMatcher.logsPropTypeWarnings(/*String || Contains*/ this._expected)
      : _hasOneWarning = false, _expectsWarning = true;

  _PropTypeLogMatcher.logsNoPropTypeWarnings()
      : _expected = contains('Failed prop type:'), _hasOneWarning = false, _expectsWarning = false;

//  PropTypeLogMatcher.logsReactWarning(this._expected);

  @override
  bool matches(/*Function || List*/ dynamic actual, Map matchState) {
    final List</*Matcher || String*/ dynamic> expectedList = _expected is List ? _expected : [_expected];
    final expectedMatchCount = _expectsWarning ? expectedList.length : 0;
    final individualExpectedWarningCounts = <int>[];
    final individualActualWarningCounts = <String, int>{};

    var actualTotalMatchCount = 0;
    var actualWarnings = <String>[];
    var shouldPrintActualLogs = false;
    var hasDuplicateExpectedWarnings = false;
    var hasDuplicateActualWarnings = false;

    if (actual is List) {
      actualWarnings = actual;
    } else if (actual is Function){
      actualWarnings = recordConsoleLogs(actual);
      shouldPrintActualLogs = true;
    } else {
      throw ArgumentError('PropTypeLogMatcher expects either a List<String> or a callback.');
    }

    expectedList.forEach((expectedWarning) {
      var numberOfMatches = 0;

      actualWarnings.forEach((actualWarning) {
        var matcher = expectedWarning is Matcher ? expectedWarning : contains(expectedWarning);

        if (matcher.matches(actualWarning, {})) {
            if(individualActualWarningCounts[actualWarning] != null) {
              individualActualWarningCounts[actualWarning]++;
            } else {
              individualActualWarningCounts.addAll({actualWarning: 1});
            }

            numberOfMatches++;
        }
      });

      individualExpectedWarningCounts.add(numberOfMatches);
    });

    actualTotalMatchCount = individualExpectedWarningCounts.fold(0, (prev, curr) => prev + curr);
    hasDuplicateExpectedWarnings = (individualExpectedWarningCounts.where((v) => v > 1)).isNotEmpty;
    hasDuplicateActualWarnings = individualActualWarningCounts.values.where((v) => v > 1).isNotEmpty;


    matchState.addAll({
      'shouldPrintActualLogs': shouldPrintActualLogs,
      'actualLogs': actualWarnings,
      'matchCount': actualTotalMatchCount,
      'hasDuplicateExpectedWarnings': hasDuplicateExpectedWarnings,
      'hasDuplicateActualWarnings': hasDuplicateActualWarnings,
    });

    return actualTotalMatchCount == expectedMatchCount &&
        !hasDuplicateExpectedWarnings &&
        !hasDuplicateActualWarnings;
  }

  @override
  Description describe(Description description) {
    if (_expectsWarning) {
      if (_hasOneWarning) {
        description.add('one prop validation warning');
      } else {
        description.add('${_expected.length} prop validation warnings.');
      }
    } else {
      description.add('no prop validation warnings');
    }

    return description;
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    var shouldPrintActualLogs = matchState['shouldPrintActualLogs'];
    var actualLogs = matchState['actualLogs'];
    var matchCount = matchState['matchCount'];
    var hasDuplicateExpectedWarnings = matchState['hasDuplicateExpectedWarnings'];
    var hasDuplcateActualWarnings = matchState['hasDuplicateActualWarnings'];

    var description = [];

    if (shouldPrintActualLogs) description.add('was ${actualLogs.toString()}');

    if (_expectsWarning) {
      if (_hasOneWarning) {
        description.add('expected one prop validation warning but got $matchCount. ');
      } else {
        description.add('expected ${_expected.length} prop validation warnings but got $matchCount. ');
      }
    } else {
        description.add('expected no prop types warnings but got $matchCount. ');
    }

    if (hasDuplicateExpectedWarnings) {
      description.add('there were multiple warnings matched to a single expected warning. Ensure each expected warning is unique.');
    }

    if (hasDuplcateActualWarnings) {
      description.add('there were multiple expected warnings that matched to a single actual warning. Ensure each expected warning is unique.');
    }

    mismatchDescription.add(description.join(""));

    return mismatchDescription;
  }
}

Matcher logsPropTypeWarning(expected) => _PropTypeLogMatcher.logsPropTypeWarning(expected);

Matcher logsPropTypeWarnings(expected) => _PropTypeLogMatcher.logsPropTypeWarnings(expected);

Matcher logsNoPropTypeWarnings() => _PropTypeLogMatcher.logsNoPropTypeWarnings();

//Matcher logsReactWarning() => PropTypeLogMatcher.logsReactWarning();
