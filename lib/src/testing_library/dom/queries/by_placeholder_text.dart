/// https://testing-library.com/docs/queries/byplaceholdertext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_placeholder_text;

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
mixin ByPlaceholderTextQueries on IQueries {
  /// Returns a single element with the given [text] as the value of the `placeholder` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByPlaceholderText] if a RTE is not expected.
  ///
  /// > Related: [getAllByPlaceholderText]
  ///
  /// > See: https://testing-library.com/docs/queries/byplaceholdertext/
  Element getByPlaceholderText(
    // TODO: How to get regex expressions working for the text argument?
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetByPlaceholderText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByPlaceholderText] if a RTE is not expected.
  ///
  /// > Related: [getByPlaceholderText]
  ///
  /// > See: https://testing-library.com/docs/queries/byplaceholdertext/
  List<Element> getAllByPlaceholderText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetAllByPlaceholderText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a single element with the given [text] as the value of the `placeholder` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByPlaceholderText] if a RTE is expected.
  ///
  /// > Related: [queryAllByPlaceholderText]
  ///
  /// > See: https://testing-library.com/docs/queries/byplaceholdertext/
  Element queryByPlaceholderText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByPlaceholderText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByPlaceholderText] if a RTE is expected.
  ///
  /// > Related: [queryByPlaceholderText]
  ///
  /// > See: https://testing-library.com/docs/queries/byplaceholdertext/
  List<Element> queryAllByPlaceholderText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByPlaceholderText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single element value with the given [text] as the value of the `placeholder` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByPlaceholderText] or [queryByPlaceholderText] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByPlaceholderText]
  ///
  /// > See: https://testing-library.com/docs/queries/byplaceholdertext/
  Future<Element> findByPlaceholderText(
    /*String|regex|bool Function(content, element)*/ text, {
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
        _jsFindByPlaceholderText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }

  /// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByPlaceholderText] or [queryByPlaceholderText] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByPlaceholderText]
  ///
  /// > See: https://testing-library.com/docs/queries/byplaceholdertext/
  Future<List<Element>> findAllByPlaceholderText(
    /*String|regex|bool Function(content, element)*/ text, {
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
        _jsFindAllByPlaceholderText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByPlaceholderText')
external Element _jsGetByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.getAllByPlaceholderText')
external List<Element> _jsGetAllByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.queryByPlaceholderText')
external Element _jsQueryByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByPlaceholderText')
external List<Element> _jsQueryAllByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.findByPlaceholderText')
external /*Promise<Element>*/ _jsFindByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByPlaceholderText')
external /*Promise<List<Element>>*/ _jsFindAllByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);
