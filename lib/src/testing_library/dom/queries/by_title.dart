/// https://testing-library.com/docs/queries/bytitle/
@JS()
library over_react_test.src.testing_library.dom.queries.by_title;

import 'dart:html' show Element;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart'
    show promiseToFutureWithErrorInterop, withErrorInterop;

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByTitleQueries on IQueries {
  /// Returns a single element with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByTitle] if a RTE is not expected.
  ///
  /// > Related: [getAllByTitle]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytitle/>
  ///
  /// ## Options
  ///
  /// ### [title]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  Element getByTitle(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      withErrorInterop(() => _jsGetByTitle(
          getContainerForScope(), TextMatch.parse(title), buildMatcherOptions(exact: exact, normalizer: normalizer)));

  /// Returns a list of elements with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByTitle] if a RTE is not expected.
  ///
  /// > Related: [getByTitle]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytitle/>
  ///
  /// ## Options
  ///
  /// ### [title]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<Element> getAllByTitle(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      withErrorInterop(() => _jsGetAllByTitle(
          getContainerForScope(), TextMatch.parse(title), buildMatcherOptions(exact: exact, normalizer: normalizer)));

  /// Returns a single element with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByTitle] if a RTE is expected.
  ///
  /// > Related: [queryAllByTitle]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytitle/>
  ///
  /// ## Options
  ///
  /// ### [title]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  Element queryByTitle(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByTitle(
          getContainerForScope(), TextMatch.parse(title), buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of elements with the given [title] as the value of the `title` attribute,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByTitle] if a RTE is expected.
  ///
  /// > Related: [queryByTitle]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytitle/>
  ///
  /// ## Options
  ///
  /// ### [title]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<Element> queryAllByTitle(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByTitle(
          getContainerForScope(), TextMatch.parse(title), buildMatcherOptions(exact: exact, normalizer: normalizer));

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
  /// > See: <https://testing-library.com/docs/queries/bytitle/>
  ///
  /// ## Options
  ///
  /// ### [title]
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
  Future<Element> findByTitle(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    Duration timeout,
    Duration interval,
    /*Error*/ dynamic Function(/*Error*/ dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFutureWithErrorInterop(
        _jsFindByTitle(getContainerForScope(), TextMatch.parse(title), matcherOptions, waitForOptions));
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
  /// > See: <https://testing-library.com/docs/queries/bytitle/>
  ///
  /// ## Options
  ///
  /// ### [title]
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
  Future<List<Element>> findAllByTitle(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    Duration timeout,
    Duration interval,
    /*Error*/ dynamic Function(/*Error*/ dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFutureWithErrorInterop(
        _jsFindAllByTitle(getContainerForScope(), TextMatch.parse(title), matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByTitle')
external Element _jsGetByTitle(
  Element container,
  /*TextMatch*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.getAllByTitle')
external List<Element> _jsGetAllByTitle(
  Element container,
  /*TextMatch*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.queryByTitle')
external Element _jsQueryByTitle(
  Element container,
  /*TextMatch*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByTitle')
external List<Element> _jsQueryAllByTitle(
  Element container,
  /*TextMatch*/
  title, [
  MatcherOptions options,
]);

@JS('rtl.findByTitle')
external /*Promise<Element>*/ _jsFindByTitle(
  Element container,
  /*TextMatch*/
  title, [
  MatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByTitle')
external /*Promise<List<Element>>*/ _jsFindAllByTitle(
  Element container,
  /*TextMatch*/
  title, [
  MatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);
