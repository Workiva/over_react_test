// @dart = 2.7

import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart';
import 'package:test/test.dart';

import 'package:over_react_test/src/over_react_test/custom_matchers.dart' show hasToStringValue;

Matcher toThrowErrorMatchingInlineSnapshot(
  Matcher stringSnapshotMatcher,
  Matcher stringPrettyDomMatcher, [
  Matcher arbitraryMatcher1,
  Matcher arbitraryMatcher2,
  Matcher arbitraryMatcher3,
]) {
  // TODO: Would be nice to create a custom matcher class so that we could customize the error message based on which of the matcher(s) are not present.
  final errorNameMatcher = hasToStringValue(contains('TestingLibraryElementError'));
  final snapshotMatcher = hasToStringValue(stringSnapshotMatcher);
  final prettyDomMatcher =
      stringPrettyDomMatcher != null ? hasToStringValue(stringPrettyDomMatcher) : hasToStringValue(endsWith('</div>'));

  return throwsA(allOf(isA<TestingLibraryElementError>(), errorNameMatcher, snapshotMatcher, prettyDomMatcher,
      arbitraryMatcher1, arbitraryMatcher2, arbitraryMatcher3));
}

/// The value to use in the `templatePattern` argument of [buildContainsPatternUsing].
///
/// This will be replaced by the `expectedValueThatWasNotFound` argument when [buildContainsPatternUsing]
/// is called to form the final string value that is expected to be found.
const valueNotFoundPlaceholder = 'replaced_with_value_not_found_by_query';

/// Like `contains`, but will replace the value of [valueNotFoundPlaceholder] found within [templatePattern]
/// and replace it with the [expectedValueThatWasNotFound].
///
/// Useful if you need to test a bunch of different variations that match the [templatePattern], but have
/// numerous possible values for [expectedValueThatWasNotFound].
///
/// ### Example
///
/// ```dart
/// buildContainsPatternUsing('alt text: $valueNotFoundPlaceholder', altTextValueNotFound));
/// // is equivalent to
/// contains('alt text: $altTextValueNotFound'));
/// ```
Matcher buildContainsPatternUsing(String templatePattern, String expectedValueThatWasNotFound) {
  if (!templatePattern.contains(valueNotFoundPlaceholder)) {
    throw ArgumentError(
        'The buildContainsPatternUsing matcher should only be used if the first argument contains `valueNotFoundPlaceholder`');
  }

  return contains(templatePattern.replaceAll(valueNotFoundPlaceholder, expectedValueThatWasNotFound));
}
