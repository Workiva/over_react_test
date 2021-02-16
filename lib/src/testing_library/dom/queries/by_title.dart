/// https://testing-library.com/docs/queries/bytitle/
@JS()
library over_react_test.src.testing_library.dom.queries.by_title;

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
mixin ByTitleQueries on IQueries {
  /// Returns a single element with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found within the provided [container].
  /// Use [queryByTitle] if a RTE is not expected.
  ///
  /// > Related: [getAllByTitle]
  ///
  /// > See: https://testing-library.com/docs/queries/bytitle/
  Element getByTitle(
    // TODO: How to get regex expressions working for the title argument?
    /*String|regex|bool Function(content, element)*/ title, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetByTitle(
          container ?? getDefaultContainer(), title, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByTitle] if a RTE is not expected.
  ///
  /// > Related: [getByTitle]
  ///
  /// > See: https://testing-library.com/docs/queries/bytitle/
  List<Element> getAllByTitle(
    /*String|regex|bool Function(content, element)*/ title, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetAllByTitle(
          container ?? getDefaultContainer(), title, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a single element with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByTitle] if a RTE is expected.
  ///
  /// > Related: [queryAllByTitle]
  ///
  /// > See: https://testing-library.com/docs/queries/bytitle/
  Element queryByTitle(
    /*String|regex|bool Function(content, element)*/ title, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByTitle(
          container ?? getDefaultContainer(), title, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByTitle] if a RTE is expected.
  ///
  /// > Related: [queryByTitle]
  ///
  /// > See: https://testing-library.com/docs/queries/bytitle/
  List<Element> queryAllByTitle(
    /*String|regex|bool Function(content, element)*/ title, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByTitle(
          container ?? getDefaultContainer(), title, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single element value with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByTitle] or [queryByTitle] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByTitle]
  ///
  /// > See: https://testing-library.com/docs/queries/bytitle/
  Future<Element> findByTitle(
    /*String|regex|bool Function(content, element)*/ title, {
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

    return promiseToFuture(_jsFindByTitle(container ?? getDefaultContainer(), title, matcherOptions, waitForOptions));
  }

  /// Returns a list of elements with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByTitle] or [queryByTitle] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByTitle]
  ///
  /// > See: https://testing-library.com/docs/queries/bytitle/
  Future<List<Element>> findAllByTitle(
    /*String|regex|bool Function(content, element)*/ title, {
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
        _jsFindAllByTitle(container ?? getDefaultContainer(), title, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByTitle')
external Element _jsGetByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.getAllByTitle')
external List<Element> _jsGetAllByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.queryByTitle')
external Element _jsQueryByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByTitle')
external List<Element> _jsQueryAllByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.findByTitle')
external /*Promise<Element>*/ _jsFindByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/
  title, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByTitle')
external /*Promise<List<Element>>*/ _jsFindAllByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/
  title, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);
