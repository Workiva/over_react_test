/// https://testing-library.com/docs/queries/byalttext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_alt_text;

import 'dart:html' show Element, ImageElement;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart' show promiseToFutureWithErrorInterop, withErrorInterop;

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByAltTextQueries on IQueries {
  /// Returns a single [ImageElement] with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByAltText] if a RTE is not expected.
  ///
  /// > Related: [getAllByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ///
  /// ## Options
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  ImageElement getByAltText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      withErrorInterop(() => _jsGetByAltText(
          getContainerForScope(), TextMatch.parse(text), buildMatcherOptions(exact: exact, normalizer: normalizer)));

  /// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByAltText] if a RTE is not expected.
  ///
  /// > Related: [getByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ///
  /// ## Options
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<ImageElement> getAllByAltText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      withErrorInterop(() => _jsGetAllByAltText(
          getContainerForScope(), TextMatch.parse(text), buildMatcherOptions(exact: exact, normalizer: normalizer)));

  /// Returns a single [ImageElement] with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByAltText] if a RTE is expected.
  ///
  /// > Related: [queryAllByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ///
  /// ## Options
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  ImageElement queryByAltText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByAltText(
          getContainerForScope(), TextMatch.parse(text), buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByAltText] if a RTE is expected.
  ///
  /// > Related: [queryByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ///
  /// ## Options
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<ImageElement> queryAllByAltText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByAltText(
          getContainerForScope(), TextMatch.parse(text), buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single [ImageElement] value with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByAltText] or [queryByAltText] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ///
  /// ## Options
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  ///
  /// ## Async Options
  ///
  /// {@macro sharedWaitForOptionsTimeoutDescription}
  /// {@macro sharedWaitForOptionsIntervalDescription}
  /// {@macro sharedWaitForOptionsOnTimeoutDescription}
  /// {@macro sharedWaitForOptionsMutationObserverDescription}
  Future<ImageElement> findByAltText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    Duration timeout,
    Duration interval,
    /*Error*/dynamic Function(/*Error*/dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFutureWithErrorInterop(
        _jsFindByAltText(getContainerForScope(), TextMatch.parse(text), matcherOptions, waitForOptions));
  }

  /// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByAltText] or [queryByAltText] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ///
  /// ## Options
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  ///
  /// ## Async Options
  ///
  /// {@macro sharedWaitForOptionsTimeoutDescription}
  /// {@macro sharedWaitForOptionsIntervalDescription}
  /// {@macro sharedWaitForOptionsOnTimeoutDescription}
  /// {@macro sharedWaitForOptionsMutationObserverDescription}
  Future<List<ImageElement>> findAllByAltText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    Duration timeout,
    Duration interval,
    /*Error*/dynamic Function(/*Error*/dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFutureWithErrorInterop(
        _jsFindAllByAltText(getContainerForScope(), TextMatch.parse(text), matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByAltText')
external ImageElement _jsGetByAltText(
  Element container,
  /*TextMatch*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.getAllByAltText')
external List<ImageElement> _jsGetAllByAltText(
  Element container,
  /*TextMatch*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.queryByAltText')
external ImageElement _jsQueryByAltText(
  Element container,
  /*TextMatch*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByAltText')
external List<ImageElement> _jsQueryAllByAltText(
  Element container,
  /*TextMatch*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.findByAltText')
external /*Promise<Element>*/ _jsFindByAltText(
  Element container,
  /*TextMatch*/
  text, [
  MatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByAltText')
external /*Promise<List<Element>>*/ _jsFindAllByAltText(
  Element container,
  /*TextMatch*/
  text, [
  MatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);
