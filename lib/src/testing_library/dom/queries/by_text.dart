/// https://testing-library.com/docs/queries/bytext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_text;

import 'dart:html' show Element, promiseToFuture;

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByTextQueries on IQueries {
  @protected
  ByTextOptions buildByTextOptions({
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    /*String|bool*/ ignore,
    String selector,
  }) {
    final selectorMatcherOptions =
        super.buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector);
    final byTextOptions = ByTextOptions()
      ..exact = selectorMatcherOptions.exact
      ..normalizer = selectorMatcherOptions.normalizer;
    if (ignore != null) byTextOptions.ignore = ignore;

    return byTextOptions;
  }

  /// Returns a single element with the given [text] content, defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByText] if a RTE is not expected.
  ///
  /// > Related: [getAllByText]
  ///
  /// > See: https://testing-library.com/docs/queries/bytext/
  Element getByText(
    // TODO: How to get regex expressions working for the text argument?
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      _jsGetByText(container ?? getDefaultContainer(), text,
          buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector));

  /// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByText] if a RTE is not expected.
  ///
  /// > Related: [getByText]
  ///
  /// > See: https://testing-library.com/docs/queries/bytext/
  List<Element> getAllByText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      _jsGetAllByText(container ?? getDefaultContainer(), text,
          buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector));

  /// Returns a single element with the given [text] content, defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByText] if a RTE is expected.
  ///
  /// > Related: [queryAllByText]
  ///
  /// > See: https://testing-library.com/docs/queries/bytext/
  Element queryByText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      _jsQueryByText(container ?? getDefaultContainer(), text,
          buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector));

  /// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByText] if a RTE is expected.
  ///
  /// > Related: [queryByText]
  ///
  /// > See: https://testing-library.com/docs/queries/bytext/
  List<Element> queryAllByText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      _jsQueryAllByText(container ?? getDefaultContainer(), text,
          buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector));

  /// Returns a future with a single element value with the given [text] content, defaulting to an [exact] match after
  /// waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByText] or [queryByText] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// > Related: [findAllByText]
  ///
  /// > See: https://testing-library.com/docs/queries/bytext/
  Future<Element> findByText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverInit mutationObserverOptions,
  }) {
    final matcherOptions = buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFuture(_jsFindByText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }

  /// Returns a list of elements with the given [text] content, defaulting to an [exact] match after
  /// waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByText] or [queryByText] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// > Related: [findByText]
  ///
  /// > See: https://testing-library.com/docs/queries/bytext/
  Future<List<Element>> findAllByText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverInit mutationObserverOptions,
  }) {
    final matcherOptions = buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFuture(_jsFindAllByText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByText')
external Element _jsGetByText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.getAllByText')
external List<Element> _jsGetAllByText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.queryByText')
external Element _jsQueryByText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.queryAllByText')
external List<Element> _jsQueryAllByText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.findByText')
external /*Promise<Element>*/ _jsFindByText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  ByTextOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByText')
external /*Promise<List<Element>>*/ _jsFindAllByText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  ByTextOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS()
@anonymous
class ByTextOptions extends SelectorMatcherOptions {
  external /*String|bool*/ get ignore;
  external set ignore(/*String|bool*/ value);
}
