@JS()
library over_react_test.src.testing_library.dom.matches.types;

import 'dart:developer';
import 'dart:html';

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'package:over_react_test/src/testing_library/dom/config/configure.dart';
import 'package:over_react_test/src/testing_library/dom/matches/get_default_normalizer.dart';
import 'package:over_react_test/src/testing_library/util/js_interop_helpers.dart';
import 'package:test/test.dart';

/// {@template TextMatchArgDescription}
/// can be either a `String`, regex, or a function which returns `true` for a match and `false` for a mismatch.
///
/// See the [JS `TextMatch` docs](https://testing-library.com/docs/queries/about#textmatch) for more details
/// and examples.
/// {@endtemplate}
class TextMatch {
  /// Parses the provided [value], checking its type and returning a value compatible with the JS `TextMatch` type.
  ///
  /// See: <https://testing-library.com/docs/queries/about#textmatch>
  static dynamic parse(dynamic value) {
    if (value is RegExp) {
      RegExp regExp = value;
      final dartValue = (String content, Element _) => regExp.hasMatch(content);
      _updateElementErrorMessageToPrintDartFnTextMatch(value);
      value = allowInterop(dartValue);
    } else if (value is Function) {
      // TODO: Any way to get the actual string value of the function provided instead?
      final fnStringValue = value.toString();
      final consumerConditional = fnStringValue.substring(fnStringValue.lastIndexOf('=>') + 2).trim();
      _updateElementErrorMessageToPrintDartFnTextMatch('$functionValueErrorMessage \n\n    $consumerConditional\n\n');
      value = allowInterop<Function>(value);
    } else if (value is! String) {
      throw ArgumentError('Argument must be a String, a RegExp or a function that returns a bool.');
    }

    return value;
  }

  static void _updateElementErrorMessageToPrintDartFnTextMatch(dynamic value) {
    final existingElementErrorFn = getConfig().getElementError;
    configure(
        getElementError:
            allowInterop((message, container) => getTextMatchDartFunctionElementError(message, container, value)));

    addTearDown(() {
      configure(getElementError: existingElementErrorFn);
    });
  }

  @visibleForTesting
  static const functionValueErrorMessage = 'that would result in the following conditional returning true:';
}

@JS()
@anonymous
class MatcherOptions {
  /// {@template MatcherOptionsExactArgDescription}
  /// ### Precision
  ///
  /// Queries also accept arguments that affect the precision of string matching:
  ///
  /// - `exact`: Defaults to `true`; matches full strings, case-sensitive. When `false`, matches substrings
  /// and is not case-sensitive. It has no effect on regex or function arguments. In most cases using a
  /// regex instead of a string gives you more control over fuzzy matching and should be preferred over `exact: false`.
  /// - `normalizer`: An optional function which overrides normalization behavior. See the Normalization section below.
  ///
  /// See the [JS `TextMatch` precision docs](https://testing-library.com/docs/queries/about#precision) for more details and examples.
  /// {@endtemplate}
  external bool get exact;
  external set exact(bool value);

  /// {@template MatcherOptionsNormalizerArgDescription}
  /// ### Normalization
  ///
  /// Before running any matching logic against text in the DOM, DOM Testing Library automatically
  /// normalizes that text. By default, normalization consists of trimming whitespace from the start
  /// and end of text, and collapsing multiple adjacent whitespace characters into a single space.
  ///
  /// If you want to prevent that normalization, or provide alternative normalization
  /// _(e.g. to remove Unicode control characters)_, you can provide a [normalizer] function.
  /// This function will be given a string and is expected to return a normalized version of that string.
  ///
  /// > __Note__
  /// >
  /// > Specifying a value for [normalizer] replaces the built-in normalization, but you can call
  /// > [getDefaultNormalizer] to obtain a built-in normalizer, either to adjust that normalization
  /// > or to call it from your own normalizer.
  ///
  /// See the [JS `TextMatch` Normalization docs](https://testing-library.com/docs/queries/about#normalization)
  /// for more details and examples.
  /// {@endtemplate}
  external NormalizerFn Function(NormalizerOptions) get normalizer;
  external set normalizer(NormalizerFn Function(NormalizerOptions) value);
}

@JS()
@anonymous
class SelectorMatcherOptions extends MatcherOptions {
  external String get selector;
  external set selector(String value);
}

@JS()
@anonymous
class NormalizerOptions {
  external bool get trim;
  external set trim(bool value);

  external bool get collapseWhitespace;
  external set collapseWhitespace(bool value);
}

typedef NormalizerFn = String Function(String);
