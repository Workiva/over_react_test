/// https://testing-library.com/docs/queries/bytestid/
@JS()
library over_react_test.src.testing_library.dom.queries.by_testid;

import 'dart:html' show Element;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart' show promiseToFutureWithErrorInterop, withErrorInterop;

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByTestIdQueries on IQueries {
  /// Returns a single element with the given [testId] value for the `data-test-id` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByTestId] if a RTE is not expected.
  ///
  /// > Related: [getAllByTestId]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytestid/>
  ///
  /// ## Options
  ///
  /// ### [testId]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  Element getByTestId(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      withErrorInterop(() => _jsGetByTestId(
          getContainerForScope(), TextMatch.parse(testId), buildMatcherOptions(exact: exact, normalizer: normalizer)));

  /// Returns a list of elements with the given [testId] value for the `data-test-id` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByTestId] if a RTE is not expected.
  ///
  /// > Related: [getByTestId]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytestid/>
  ///
  /// ## Options
  ///
  /// ### [testId]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<Element> getAllByTestId(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      withErrorInterop(() => _jsGetAllByTestId(
          getContainerForScope(), TextMatch.parse(testId), buildMatcherOptions(exact: exact, normalizer: normalizer)));

  /// Returns a single element with the given [testId] value for the `data-test-id` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByTestId] if a RTE is expected.
  ///
  /// > Related: [queryAllByTestId]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytestid/>
  ///
  /// ## Options
  ///
  /// ### [testId]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  Element queryByTestId(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByTestId(
          getContainerForScope(), TextMatch.parse(testId), buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [testId] value for the `data-test-id` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByTestId] if a RTE is expected.
  ///
  /// > Related: [queryByTestId]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytestid/>
  ///
  /// ## Options
  ///
  /// ### [testId]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<Element> queryAllByTestId(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByTestId(
          getContainerForScope(), TextMatch.parse(testId), buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single element value with the given [testId] value for the `data-test-id` attribute,
  /// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByTestId]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytestid/>
  ///
  /// ## Options
  ///
  /// ### [testId]
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
  Future<Element> findByTestId(
    /*TextMatch*/ dynamic testId, {
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
        _jsFindByTestId(getContainerForScope(), TextMatch.parse(testId), matcherOptions, waitForOptions));
  }

  /// Returns a list of elements with the given [testId] value for the `data-test-id` attribute,
  /// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByTestId]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytestid/>
  ///
  /// ## Options
  ///
  /// ### [testId]
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
  Future<List<Element>> findAllByTestId(
    /*TextMatch*/ dynamic testId, {
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
        _jsFindAllByTestId(getContainerForScope(), TextMatch.parse(testId), matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByTestId')
external Element _jsGetByTestId(
  Element container,
  /*TextMatch*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.getAllByTestId')
external List<Element> _jsGetAllByTestId(
  Element container,
  /*TextMatch*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.queryByTestId')
external Element _jsQueryByTestId(
  Element container,
  /*TextMatch*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByTestId')
external List<Element> _jsQueryAllByTestId(
  Element container,
  /*TextMatch*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.findByTestId')
external /*Promise<Element>*/ _jsFindByTestId(
  Element container,
  /*TextMatch*/
  testId, [
  MatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByTestId')
external /*Promise<List<Element>>*/ _jsFindAllByTestId(
  Element container,
  /*TextMatch*/
  testId, [
  MatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);
