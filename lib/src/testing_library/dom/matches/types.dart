// @dart = 2.7

@JS()
library over_react_test.src.testing_library.dom.matches.types;

import 'dart:developer';
import 'dart:html';

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'package:over_react_test/src/testing_library/dom/matches/get_default_normalizer.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart';

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
      // Display the regex as the value that could not be matched to the consumer in the test failure message
      // instead of the string representation of the `dartValue` (interop'd function) set below.
      setEphemeralElementErrorMessage(_replaceDartInteropFunctionStringWith('$value'));

      // Set the value to a function to be called on the JS side, and do the actual
      // regex matching using a Dart regex within that interop'd function call.
      RegExp regExp = value;
      final dartValue = (String content, Element _) => regExp.hasMatch(content);
      value = allowInterop(dartValue);
    } else if (value is Function) {
      // Display the nicest string representation of the Dart function that we can as the value that
      // could not be matched to the consumer in the test failure message instead of the string
      // representation of the interop `value` set below.
      setEphemeralElementErrorMessage(
          _replaceDartInteropFunctionStringWith('$functionValueErrorMessage\n\n    $value\n\n'));

      // Set the value to an interop'd function.
      value = allowInterop<Function>(value);
    } else if (value is! String) {
      throw ArgumentError('Argument must be a String, a RegExp or a function that returns a bool.');
    }

    return value;
  }

  static Object Function(Object originalMessage, Element container) _replaceDartInteropFunctionStringWith(
      Object newValue) {
    final dartInteropFunctionValueRegex = RegExp(r'([\"`]*)(function[\s\S]+})([\"`]*)(.*)([\s\S]+)*', multiLine: true);

    return (originalMessage, container) {
      var newMessage = originalMessage.toString().replaceAllMapped(dartInteropFunctionValueRegex, (match) {
        final optionalOpeningQuoteOrBacktick = match.group(1);
        final optionalClosingQuoteOrBacktick = match.group(3);
        final restOfMessageBeforePrettyDomOrAccessibleRolesPrintout = match.group(4);
        final newValueLines = newValue.toString().split('\n');
        // Split out the first line of the new message so we can add
        // the `restOfMessageBeforePrettyDomOrAccessibleRolesPrintout` after it before any optional newlines are added
        final newValueFirstLine = newValueLines.first;
        final newValueRestOfLines = newValueLines..removeAt(0);
        var returnValue =
            '$newValueFirstLine$restOfMessageBeforePrettyDomOrAccessibleRolesPrintout${newValueRestOfLines.join('\n')}';
        if (optionalOpeningQuoteOrBacktick.isNotEmpty || optionalClosingQuoteOrBacktick.isNotEmpty) {
          // Restore quotes around the first line of the new value if they were previously found around
          // the `function...` portion of the original message.
          returnValue = returnValue.replaceFirst(newValueFirstLine, '"$newValueFirstLine"');
        }
        return returnValue;
      });

      return newMessage;
    };
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

  /// {@template MatcherOptionsErrorMessage}
  /// ### Error Message
  ///
  /// Use the `errorMessage` argument to customize error messages displayed when
  /// tests using the query fail.
  /// {@endtemplate}
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
