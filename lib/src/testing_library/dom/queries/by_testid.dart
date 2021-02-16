/// https://testing-library.com/docs/queries/bytestid/
@JS()
library over_react_test.src.testing_library.dom.queries.by_testid;

import 'dart:html' show Element, promiseToFuture;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByTestIdQueries on IQueries {
  /// Returns a single element with the given [testId] value, defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByTestId] if a RTE is not expected.
  ///
  /// > Related: [getAllByTestId]
  ///
  /// > See: https://testing-library.com/docs/queries/bytestid/
  Element getByTestId(
    // TODO: How to get regex expressions working for the testId argument?
    /*String|regex|bool Function(content, element)*/ testId, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetByTestId(
          container ?? getDefaultContainer(), testId, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [testId] value, defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByTestId] if a RTE is not expected.
  ///
  /// > Related: [getByTestId]
  ///
  /// > See: https://testing-library.com/docs/queries/bytestid/
  List<Element> getAllByTestId(
    /*String|regex|bool Function(content, element)*/ testId, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetAllByTestId(
          container ?? getDefaultContainer(), testId, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a single element with the given [testId] value, defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByTestId] if a RTE is expected.
  ///
  /// > Related: [queryAllByTestId]
  ///
  /// > See: https://testing-library.com/docs/queries/bytestid/
  Element queryByTestId(
    /*String|regex|bool Function(content, element)*/ testId, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByTestId(
          container ?? getDefaultContainer(), testId, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [testId] value, defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByTestId] if a RTE is expected.
  ///
  /// > Related: [queryByTestId]
  ///
  /// > See: https://testing-library.com/docs/queries/bytestid/
  List<Element> queryAllByTestId(
    /*String|regex|bool Function(content, element)*/ testId, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByTestId(
          container ?? getDefaultContainer(), testId, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single element value with the given [testId] value, defaulting to an [exact] match after
  /// waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByTestId]
  ///
  /// > See: https://testing-library.com/docs/queries/bytestid/
  Future<Element> findByTestId(
    /*String|regex|bool Function(content, element)*/ testId, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverInit mutationObserverOptions,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFuture(_jsFindByTestId(container ?? getDefaultContainer(), testId, matcherOptions, waitForOptions));
  }

  /// Returns a list of elements with the given [testId] value, defaulting to an [exact] match after
  /// waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByTestId]
  ///
  /// > See: https://testing-library.com/docs/queries/bytestid/
  Future<List<Element>> findAllByTestId(
    /*String|regex|bool Function(content, element)*/ testId, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverInit mutationObserverOptions,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFuture(
        _jsFindAllByTestId(container ?? getDefaultContainer(), testId, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByTestId')
external Element _jsGetByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.getAllByTestId')
external List<Element> _jsGetAllByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.queryByTestId')
external Element _jsQueryByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByTestId')
external List<Element> _jsQueryAllByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/
  testId, [
  MatcherOptions options,
]);

@JS('rtl.findByTestId')
external /*Promise<Element>*/ _jsFindByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/
  testId, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByTestId')
external /*Promise<List<Element>>*/ _jsFindAllByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/
  testId, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);
