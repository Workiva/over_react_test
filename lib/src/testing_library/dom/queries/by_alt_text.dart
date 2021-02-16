/// https://testing-library.com/docs/queries/byalttext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_alt_text;

import 'dart:html' show Element, ImageElement, promiseToFuture;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';

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
  ImageElement getByAltText(
    // TODO: How to get regex expressions working for the text argument?
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetByAltText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByAltText] if a RTE is not expected.
  ///
  /// > Related: [getByAltText]
  ///
  /// > See: https://testing-library.com/docs/queries/byalttext/
  List<ImageElement> getAllByAltText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsGetAllByAltText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a single [ImageElement] with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByAltText] if a RTE is expected.
  ///
  /// > Related: [queryAllByAltText]
  ///
  /// > See: <https://testing-library.com/docs/queries/byalttext/>
  ImageElement queryByAltText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByAltText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByAltText] if a RTE is expected.
  ///
  /// > Related: [queryByAltText]
  ///
  /// > See: https://testing-library.com/docs/queries/byalttext/
  List<ImageElement> queryAllByAltText(
    /*String|regex|bool Function(content, element)*/ text, {
    Element container,
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByAltText(
          container ?? getDefaultContainer(), text, buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a future with a single [ImageElement] value with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByAltText] or [queryByAltText] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found within the provided [container].
  ///
  /// > Related: [findAllByAltText]
  ///
  /// > See: https://testing-library.com/docs/queries/byalttext/
  Future<ImageElement> findByAltText(
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

    return promiseToFuture(_jsFindByAltText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }

  /// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
  /// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByAltText] or [queryByAltText] in a `waitFor` function.
  ///
  /// Throws if no elements are found within the provided [container].
  ///
  /// > Related: [findByAltText]
  ///
  /// > See: https://testing-library.com/docs/queries/byalttext/
  Future<List<ImageElement>> findAllByAltText(
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
        _jsFindAllByAltText(container ?? getDefaultContainer(), text, matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByAltText')
external ImageElement _jsGetByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.getAllByAltText')
external List<ImageElement> _jsGetAllByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.queryByAltText')
external ImageElement _jsQueryByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByAltText')
external List<ImageElement> _jsQueryAllByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
]);

@JS('rtl.findByAltText')
external /*Promise<Element>*/ _jsFindByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByAltText')
external /*Promise<List<Element>>*/ _jsFindAllByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/
  text, [
  MatcherOptions options,
  SharedWaitForOptions waitForOptions,
]);
