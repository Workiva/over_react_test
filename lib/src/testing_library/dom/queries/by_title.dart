// @dart = 2.7

/// https://testing-library.com/docs/queries/bytitle/
@JS()
library over_react_test.src.testing_library.dom.queries.by_title;

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
  /// {@macro MatcherOptionsErrorMessage}
  E getByTitle<E extends Element>(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
  }) =>
      withErrorInterop(
          () => _jsGetByTitle(getContainerForScope(), TextMatch.parse(title),
              buildMatcherOptions(exact: exact, normalizer: normalizer)),
          errorMessage: errorMessage);

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
  /// {@macro MatcherOptionsErrorMessage}
  List<E> getAllByTitle<E extends Element>(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
  }) =>
      withErrorInterop(
          () => _jsGetAllByTitle(getContainerForScope(), TextMatch.parse(title),
                  buildMatcherOptions(exact: exact, normalizer: normalizer))
              // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
              .cast<E>(),
          errorMessage: errorMessage);

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
  E queryByTitle<E extends Element>(
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
  List<E> queryAllByTitle<E extends Element>(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByTitle(
              getContainerForScope(), TextMatch.parse(title), buildMatcherOptions(exact: exact, normalizer: normalizer))
          // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
          .cast<E>();

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
  /// {@macro MatcherOptionsErrorMessage}
  ///
  /// ## Async Options
  ///
  /// {@macro sharedWaitForOptionsTimeoutDescription}
  /// {@macro sharedWaitForOptionsIntervalDescription}
  /// {@macro sharedWaitForOptionsOnTimeoutDescription}
  /// {@macro sharedWaitForOptionsMutationObserverDescription}
  Future<E> findByTitle<E extends Element>(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindByTitle for consistency with our
    // need to use it on the analogous `findAllByTitle` query.
    return waitFor(
      () => getByTitle<E>(
        title,
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
  /// {@macro MatcherOptionsErrorMessage}
  ///
  /// ## Async Options
  ///
  /// {@macro sharedWaitForOptionsTimeoutDescription}
  /// {@macro sharedWaitForOptionsIntervalDescription}
  /// {@macro sharedWaitForOptionsOnTimeoutDescription}
  /// {@macro sharedWaitForOptionsMutationObserverDescription}
  Future<List<E>> findAllByTitle<E extends Element>(
    /*TextMatch*/ dynamic title, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindAllByTitle because of the inability
    // to call `.cast<E>` on the list before returning to consumers (https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5)
    // like we can/must on the `getAllByTitle` return value.
    return waitFor(
      () => getAllByTitle<E>(
        title,
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
