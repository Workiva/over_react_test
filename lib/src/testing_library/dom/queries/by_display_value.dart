/// https://testing-library.com/docs/queries/bydisplayvalue/
@JS()
library over_react_test.src.testing_library.dom.queries.by_display_value;

import 'dart:html' show Element, InputElement, SelectElement, TextAreaElement, promiseToFuture;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByDisplayValueQueries on IQueries {
  /// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByDisplayValue] if a RTE is not expected.
  ///
  /// > See: https://testing-library.com/docs/queries/bydisplayvalue/
  Element getByDisplayValue(
    // TODO: How to get regex expressions working for the text argument?
    /*String|regex|bool Function(content, element)*/ value, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetByDisplayValue(
          container ?? getDefaultContainer(), value, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByDisplayValue] if a RTE is not expected.
  ///
  /// > Related: [getByDisplayValue]
  ///
  /// > See: https://testing-library.com/docs/queries/bydisplayvalue/
  List<Element> getAllByDisplayValue(
    /*String|regex|bool Function(content, element)*/ value, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetAllByDisplayValue(
          container ?? getDefaultContainer(), value, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByDisplayValue] if a RTE is expected.
  ///
  /// > Related: [queryAllByDisplayValue]
  ///
  /// > See: https://testing-library.com/docs/queries/bydisplayvalue/
  Element queryByDisplayValue(
    /*String|regex|bool Function(content, element)*/ value, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByDisplayValue(
          container ?? getDefaultContainer(), value, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByDisplayValue] if a RTE is expected.
  ///
  /// > Related: [queryByDisplayValue]
  ///
  /// > See: https://testing-library.com/docs/queries/bydisplayvalue/
  List<Element> queryAllByDisplayValue(
    /*String|regex|bool Function(content, element)*/ value, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByDisplayValue(
          container ?? getDefaultContainer(), value, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
  /// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByDisplayValue] or [queryByDisplayValue] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByDisplayValue]
  ///
  /// > See: https://testing-library.com/docs/queries/bydisplayvalue/
  Future<Element> findByDisplayValue(
    /*String|regex|bool Function(content, element)*/ value, {
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
        _jsFindByDisplayValue(container ?? getDefaultContainer(), value, matcherOptions, waitForOptions));
  }

  /// Returns a list of [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
  /// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByDisplayValue] or [queryByDisplayValue] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByDisplayValue]
  ///
  /// > See: https://testing-library.com/docs/queries/bydisplayvalue/
  Future<List<Element>> findAllByDisplayValue(
    /*String|regex|bool Function(content, element)*/ value, {
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
        _jsFindAllByDisplayValue(container ?? getDefaultContainer(), value, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByDisplayValue')
external Element _jsGetByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.getAllByDisplayValue')
external List<Element> _jsGetAllByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.queryByDisplayValue')
external Element _jsQueryByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByDisplayValue')
external List<Element> _jsQueryAllByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.findByDisplayValue')
external /*Promise<Element>*/ _jsFindByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/
  value, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByDisplayValue')
external /*Promise<List<Element>>*/ _jsFindAllByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/
  value, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);
