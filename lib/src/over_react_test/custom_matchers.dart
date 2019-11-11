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

/// A log matcher that ensures that expected log values are present.
///
/// In its core, the matcher compares two lists. The added utility is that by
/// passing in a callback, the matcher will run the function and record the logs,
/// return them in a list, and use that list as the actual value to compare
/// against the expected.
///
/// Related: [recordConsoleLogs]
class _LogMatcher extends Matcher {
  _LogMatcher(this._expected, this._expectsMatch, this._expectsSingleMatch, {this.shouldEnforceLogCount = false});

  /// The expected value.
  final /*List<Contains> || List<String> || String*/ _expected;

  /// Whether or not the matcher should expect any log matches.
  ///
  /// This can be useful to validate that a certain log does not occur.
  final _expectsMatch;

  /// Whether or not the matcher should expect only a single log match.
  final _expectsSingleMatch;

  /// Whether or not the matcher should enforce that the number of actual logs
  /// is equal to the number of expected logs.
  ///
  /// Note that when passed a callback for the `actual` value, the matcher will
  /// look for all errors. Enforcing that the actual and expected lists have the
  /// same length will enforce that no errors other than the expected will occur.
  ///
  /// Default: false
  final shouldEnforceLogCount;

  @override
  bool matches(/*Function || List*/ dynamic actual, Map matchState) {
    // Get the expected values
    final List</*Contains || String*/ dynamic> expectedList = _expected is List ? _expected : [_expected];
    final expectedMatchCount = _expectsMatch ? expectedList.length : 0;

    // Declare variables used to test against the expected values
    final shouldPrintLogsIfMatchFails = actual is Function;
    final hasTooManyLogs = shouldEnforceLogCount && actual.length != expectedMatchCount;
    var hasDuplicateExpectedWarnings = false;
    var hasDuplicateActualWarnings = false;
    var actualTotalMatchCount = 0;

    // Local function state variables
    final actualWarningCounts= <String, int>{};
    final expectedWarningCounts = <int>[];

    // Validate that actual is a list of logs and set it to one if not
    try {
      actual = actual is List<String> ? actual : recordConsoleLogs(actual);
    } catch (e, st) {
      throw ArgumentError('PropTypeLogMatcher expects either a List<String> or a'
          ' callback. \n$e \n$st');
    }

    // Function that looks for matches and updates the match state
    void matchExpectedWarnings(/*Contains || String*/ dynamic warning) {
      var expectedWarningMatches = 0;

      actual.forEach((actualWarning) {
        var matcher = warning is Matcher ? warning : contains(warning);

        if (matcher.matches(actualWarning, {})) {
          if (actualWarningCounts[actualWarning] != null) {
            actualWarningCounts[actualWarning]++;
          } else {
            actualWarningCounts.addAll({actualWarning: 1});
          }

          expectedWarningMatches++;
        }
      });

      expectedWarningCounts.add(expectedWarningMatches);
    }

    // Iterate over expected values looking for matches
    expectedList.forEach(matchExpectedWarnings);

    actualTotalMatchCount = expectedWarningCounts.fold(0, (prev, curr) => prev + curr);
    hasDuplicateExpectedWarnings = (expectedWarningCounts.where((v) => v > 1)).isNotEmpty;
    hasDuplicateActualWarnings = actualWarningCounts.values.where((v) => v > 1).isNotEmpty;

    matchState.addAll({
      'shouldPrintActualLogs': shouldPrintLogsIfMatchFails,
      'actualLogs': actual,
      'matchCount': actualTotalMatchCount,
      'hasDuplicateExpectedWarnings': hasDuplicateExpectedWarnings,
      'hasDuplicateActualWarnings': hasDuplicateActualWarnings,
      'hasTooManyActualLogs': hasTooManyLogs,
    });

    // Validate there are the correct number of matches and there are no duplicate matches
    return actualTotalMatchCount == expectedMatchCount &&
        !hasDuplicateExpectedWarnings &&
        !hasDuplicateActualWarnings &&
        !hasTooManyLogs;
  }

  @override
  Description describe(Description description) {
    if (_expectsMatch) {
      if (_expectsSingleMatch) {
        description.add('one log match');
      } else {
        description.add('${_expected.length} log matches.');
      }
    } else {
      description.add('no log matches');
    }

    return description;
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose) {
    bool shouldPrintActualLogs = matchState['shouldPrintActualLogs'];
    List<String> actualLogs = matchState['actualLogs'];
    int matchCount = matchState['matchCount'];
    bool hasDuplicateExpectedWarnings = matchState['hasDuplicateExpectedWarnings'];
    bool hasDuplicateActualWarnings = matchState['hasDuplicateActualWarnings'];
    bool hasTooManyActualLogs = matchState['hasTooManyActualLogs'] ?? false;

    var description = <String>[];

    if (hasTooManyActualLogs) {
      mismatchDescription.add('Expected an equal number of expected and actual '
          'logs, but received too many actual logs. ');
    }

    // Printing the actual logs can help because if the matcher fails when passed
    // a callback, the test prints the function rather than the return value of
    // recordConsoleLogs
    if (shouldPrintActualLogs) description.add('was ${actualLogs.toString()}');

    if (_expectsMatch) {
      if (_expectsSingleMatch) {
        description.add('Expected one log match but got $matchCount. ');
      } else {
        description.add('Expected ${_expected.length} log matches but got $matchCount. ');
      }

      if (hasDuplicateExpectedWarnings && hasDuplicateActualWarnings) {
        description.add('There were duplicate matches between the expected '
            'logs and the actual logs. Ensure each expected log '
            'is specific and unique.');
      } else if (hasDuplicateExpectedWarnings) {
        description.add('There were multiple actual logs matched to a single '
            'expected warning. Ensure each expected log is specific and'
            ' unique.');
      } else if (hasDuplicateActualWarnings){
        description.add('There were multiple expected logs that matched to a '
            'single actual warning. Ensure each expected log is specific'
            ' and unique.');
      }
    } else {
        description.add('Expected no log matches but got $matchCount. ');
    }

    mismatchDescription.add(description.join(""));

    return mismatchDescription;
  }
}

/// A matcher used to assert expected a `List` contains expected `propType`
/// warnings.
///
/// The actual value can be a callback function, which will result in the matcher
/// asserting that the expected `propType` warnings appear during th runtime
/// of the callback.
///
/// Related: [_LogMatcher]
class _PropTypeLogMatcher extends _LogMatcher {
  _PropTypeLogMatcher(_expected, _expectsMatch, _expectsSingleMatch)
      : super(_expected, _expectsMatch, _expectsSingleMatch, shouldEnforceLogCount: true);

  final _filter = contains('Failed prop type');

  @override
  bool matches(actual, Map matchState) {
    actual = actual is List<String> ? actual : recordConsoleLogs(actual);
    actual.removeWhere((log) => !_filter.matches(log, {}));

    return super.matches(actual, matchState);
  }
}

/// Matcher used to check for a single `propTypes` warning.
///
/// [expected] can be:
///   * `List<String>`
///   * `List<Contains>`
///   * `String`
///
/// Related: [logsPropTypeWarnings], [logsNoPropTypeWarnings]
_PropTypeLogMatcher logsPropTypeWarning(dynamic expected) => _PropTypeLogMatcher(expected, true, true);

/// Matcher used to check for multiple `propType` warnings.
///
/// Related: [logsPropTypeWarning], [logsNoPropTypeWarnings]
_PropTypeLogMatcher logsPropTypeWarnings(List<dynamic> expected) => _PropTypeLogMatcher(expected, true, false);

/// Matcher used enforce that there are no `propType` warnings.
///
/// Related: [logsPropTypeWarning], [logsPropTypeWarnings]
_PropTypeLogMatcher logsNoPropTypeWarnings() => _PropTypeLogMatcher(contains('Failed prop type:'), false, false);
