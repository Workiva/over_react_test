// @dart = 2.7

/// https://testing-library.com/docs/queries/bydisplayvalue/
@JS()
library over_react_test.src.testing_library.dom.queries.by_display_value;

import 'dart:html' show Element, InputElement, SelectElement, TextAreaElement;

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
mixin ByDisplayValueQueries on IQueries {
  /// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByDisplayValue] if a RTE is not expected.
  ///
  /// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
  ///
  /// ## Options
  ///
  /// ### [value]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  /// {@macro MatcherOptionsErrorMessage}
  E getByDisplayValue<E extends Element>(
    /*TextMatch*/ dynamic value, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
  }) =>
      withErrorInterop(
          () => _jsGetByDisplayValue(getContainerForScope(), TextMatch.parse(value),
              buildMatcherOptions(exact: exact, normalizer: normalizer)),
          errorMessage: errorMessage);

  /// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByDisplayValue] if a RTE is not expected.
  ///
  /// > Related: [getByDisplayValue]
  ///
  /// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
  ///
  /// ## Options
  ///
  /// ### [value]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  /// {@macro MatcherOptionsErrorMessage}
  List<E> getAllByDisplayValue<E extends Element>(
    /*TextMatch*/ dynamic value, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
  }) =>
      withErrorInterop(
          () => _jsGetAllByDisplayValue(
                  getContainerForScope(),
                  TextMatch.parse(value),
                  buildMatcherOptions(
                      exact: exact,
                      normalizer: normalizer)) // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
              .cast<E>(),
          errorMessage: errorMessage);

  /// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByDisplayValue] if a RTE is expected.
  ///
  /// > Related: [queryAllByDisplayValue]
  ///
  /// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
  ///
  /// ## Options
  ///
  /// ### [value]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  E queryByDisplayValue<E extends Element>(
    /*TextMatch*/ dynamic value, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryByDisplayValue(
          getContainerForScope(), TextMatch.parse(value), buildMatcherOptions(exact: exact, normalizer: normalizer));

  /// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByDisplayValue] if a RTE is expected.
  ///
  /// > Related: [queryByDisplayValue]
  ///
  /// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
  ///
  /// ## Options
  ///
  /// ### [value]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<E> queryAllByDisplayValue<E extends Element>(
    /*TextMatch*/ dynamic value, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) =>
      _jsQueryAllByDisplayValue(
              getContainerForScope(), TextMatch.parse(value), buildMatcherOptions(exact: exact, normalizer: normalizer))
          // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
          .cast<E>();

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
  /// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
  ///
  /// ## Options
  ///
  /// ### [value]
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
  Future<E> findByDisplayValue<E extends Element>(
    /*TextMatch*/ dynamic value, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindByDisplayValue for consistency with our
    // need to use it on the analogous `findAllByDisplayValue` query.
    return waitFor(
      () => getByDisplayValue(
        value,
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
  /// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
  ///
  /// ## Options
  ///
  /// ### [value]
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
  Future<List<E>> findAllByDisplayValue<E extends Element>(
    /*TextMatch*/ dynamic value, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindAllByDisplayValue because of the inability
    // to call `.cast<E>` on the list before returning to consumers (https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5)
    // like we can/must on the `getAllByDisplayValue` return value.
    return waitFor(
      () => getAllByDisplayValue<E>(
        value,
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

@JS('rtl.getByDisplayValue')
external Element _jsGetByDisplayValue(
  Element container,
  /*TextMatch*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.getAllByDisplayValue')
external List<Element> _jsGetAllByDisplayValue(
  Element container,
  /*TextMatch*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.queryByDisplayValue')
external Element _jsQueryByDisplayValue(
  Element container,
  /*TextMatch*/
  value, [
  MatcherOptions options,
]);

@JS('rtl.queryAllByDisplayValue')
external List<Element> _jsQueryAllByDisplayValue(
  Element container,
  /*TextMatch*/
  value, [
  MatcherOptions options,
]);
