/// https://testing-library.com/docs/queries/bylabeltext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_label_text;

import 'dart:html' show Element, LabelElement, promiseToFuture;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByLabelTextQueries on IQueries {
  /// Returns a single element that is associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByLabelText] if a RTE is not expected.
  ///
  /// > Related: [getAllByLabelText]
  ///
  /// > See: https://testing-library.com/docs/queries/bylabeltext/
  Element getByLabelText(
    // TODO: How to get regex expressions working for the text argument?
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      _jsGetByLabelText(container ?? getDefaultContainer(), text,
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector));

  /// Returns a list of elements that are associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByLabelText] if a RTE is not expected.
  ///
  /// > Related: [getByLabelText]
  ///
  /// > See: https://testing-library.com/docs/queries/bylabeltext/
  List<Element> getAllByLabelText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      _jsGetAllByLabelText(container ?? getDefaultContainer(), text,
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector));

  /// Returns a single element that is associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByLabelText] if a RTE is expected.
  ///
  /// > Related: [queryAllByLabelText]
  ///
  /// > See: https://testing-library.com/docs/queries/bylabeltext/
  Element queryByLabelText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      _jsQueryByLabelText(container ?? getDefaultContainer(), text,
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector));

  /// Returns a list of elements that are associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByLabelText] if a RTE is expected.
  ///
  /// > Related: [queryByLabelText]
  ///
  /// > See: https://testing-library.com/docs/queries/bylabeltext/
  List<Element> queryAllByLabelText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      _jsQueryAllByLabelText(container ?? getDefaultContainer(), text,
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector));

  /// Returns a future with a single element that is associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByLabelText] or [queryByLabelText] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByLabelText]
  ///
  /// > See: https://testing-library.com/docs/queries/bylabeltext/
  Future<Element> findByLabelText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverInit mutationObserverOptions,
  }) {
    final matcherOptions = buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFuture(
        _jsFindByLabelText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }

  /// Returns a list of elements that are associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByLabelText] or [queryByLabelText] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByLabelText]
  ///
  /// > See: https://testing-library.com/docs/queries/bylabeltext/
  Future<List<Element>> findAllByLabelText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverInit mutationObserverOptions,
  }) {
    final matcherOptions = buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFuture(
        _jsFindAllByLabelText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByLabelText')
external Element _jsGetByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.getAllByLabelText')
external List<Element> _jsGetAllByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.queryByLabelText')
external Element _jsQueryByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.queryAllByLabelText')
external List<Element> _jsQueryAllByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.findByLabelText')
external /*Promise<Element>*/ _jsFindByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  SelectorMatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByLabelText')
external /*Promise<List<Element>>*/ _jsFindAllByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  SelectorMatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);
