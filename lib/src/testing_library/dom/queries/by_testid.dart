// @dart = 2.7

/// https://testing-library.com/docs/queries/bytestid/
@JS()
library over_react_test.src.testing_library.dom.queries.by_testid;

import 'dart:html' show Element;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart' show withErrorInterop;

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
  /// {@macro MatcherOptionsErrorMessage}
  E getByTestId<E extends Element>(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
  }) =>
      withErrorInterop(
          () => _jsGetByTestId(
                getContainerForScope(),
                TextMatch.parse(testId),
                buildMatcherOptions(exact: exact, normalizer: normalizer),
              ),
          errorMessage: errorMessage);

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
  /// {@macro MatcherOptionsErrorMessage}
  List<E> getAllByTestId<E extends Element>(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
  }) =>
      withErrorInterop(
          () => _jsGetAllByTestId(getContainerForScope(), TextMatch.parse(testId),
                  buildMatcherOptions(exact: exact, normalizer: normalizer))
              // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
              .cast<E>(),
          errorMessage: errorMessage);

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
  E queryByTestId<E extends Element>(
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
  List<E> queryAllByTestId<E extends Element>(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByTestId(getContainerForScope(), TextMatch.parse(testId),
              buildMatcherOptions(exact: exact, normalizer: normalizer))
          // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
          .cast<E>();

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
  /// {@macro MatcherOptionsErrorMessage}
  ///
  /// ## Async Options
  ///
  /// {@macro sharedWaitForOptionsTimeoutDescription}
  /// {@macro sharedWaitForOptionsIntervalDescription}
  /// {@macro sharedWaitForOptionsOnTimeoutDescription}
  /// {@macro sharedWaitForOptionsMutationObserverDescription}
  Future<E> findByTestId<E extends Element>(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindByTestId for consistency with our
    // need to use it on the analogous `findAllByTestId` query.
    return waitFor(
      () => getByTestId<E>(
        testId,
        exact: exact,
        normalizer: normalizer,
        errorMessage: errorMessage,
      ),
      container: getContainerForScope(),
      timeout: timeout,
      interval: interval ?? defaultAsyncCallbackCheckInterval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions ?? defaultMutationObserverOptions,
    );
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
  /// {@macro MatcherOptionsErrorMessage}
  ///
  /// ## Async Options
  ///
  /// {@macro sharedWaitForOptionsTimeoutDescription}
  /// {@macro sharedWaitForOptionsIntervalDescription}
  /// {@macro sharedWaitForOptionsOnTimeoutDescription}
  /// {@macro sharedWaitForOptionsMutationObserverDescription}
  Future<List<E>> findAllByTestId<E extends Element>(
    /*TextMatch*/ dynamic testId, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindAllByTestId because of the inability
    // to call `.cast<E>` on the list before returning to consumers (https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5)
    // like we can/must on the `getAllByTestId` return value.
    return waitFor(
      () => getAllByTestId<E>(
        testId,
        exact: exact,
        normalizer: normalizer,
        errorMessage: errorMessage,
      ),
      container: getContainerForScope(),
      timeout: timeout,
      interval: interval ?? defaultAsyncCallbackCheckInterval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions ?? defaultMutationObserverOptions,
    );
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
