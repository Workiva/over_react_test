/// https://testing-library.com/docs/queries/bylabeltext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_label_text;

import 'dart:html' show Element, LabelElement;

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
mixin ByLabelTextQueries on IQueries {
  /// Returns a single element that is associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Throws if no element is found.
  /// Use [queryByLabelText] if a RTE is not expected.
  ///
  /// > Related: [getAllByLabelText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bylabeltext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  Element getByLabelText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      withErrorInterop(() => _jsGetByLabelText(getContainerForScope(), TextMatch.parse(text),
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector)));

  /// Returns a list of elements that are associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByLabelText] if a RTE is not expected.
  ///
  /// > Related: [getByLabelText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bylabeltext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<Element> getAllByLabelText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      withErrorInterop(() => _jsGetAllByLabelText(getContainerForScope(), TextMatch.parse(text),
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector)));

  /// Returns a single element that is associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByLabelText] if a RTE is expected.
  ///
  /// > Related: [queryAllByLabelText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bylabeltext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  Element queryByLabelText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      _jsQueryByLabelText(getContainerForScope(), TextMatch.parse(text),
          buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector));

  /// Returns a list of elements that are associated with a [LabelElement] with the given [text],
  /// defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByLabelText] if a RTE is expected.
  ///
  /// > Related: [queryByLabelText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bylabeltext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<Element> queryAllByLabelText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
  }) =>
      _jsQueryAllByLabelText(getContainerForScope(), TextMatch.parse(text),
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
  /// > See: <https://testing-library.com/docs/queries/bylabeltext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [text]
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
  Future<Element> findByLabelText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    Duration timeout,
    Duration interval,
    /*Error*/ dynamic Function(/*Error*/ dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFutureWithErrorInterop(
        _jsFindByLabelText(getContainerForScope(), TextMatch.parse(text), matcherOptions, waitForOptions));
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
  /// > See: <https://testing-library.com/docs/queries/bylabeltext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [text]
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
  Future<List<Element>> findAllByLabelText(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    Duration timeout,
    Duration interval,
    /*Error*/ dynamic Function(/*Error*/ dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildSelectorMatcherOptions(exact: exact, normalizer: normalizer, selector: selector);
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    return promiseToFutureWithErrorInterop(
        _jsFindAllByLabelText(getContainerForScope(), TextMatch.parse(text), matcherOptions, waitForOptions));
  }
}

@JS('rtl.getByLabelText')
external Element _jsGetByLabelText(
  Element container,
  /*TextMatch*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.getAllByLabelText')
external List<Element> _jsGetAllByLabelText(
  Element container,
  /*TextMatch*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.queryByLabelText')
external Element _jsQueryByLabelText(
  Element container,
  /*TextMatch*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.queryAllByLabelText')
external List<Element> _jsQueryAllByLabelText(
  Element container,
  /*TextMatch*/
  text, [
  SelectorMatcherOptions options,
]);

@JS('rtl.findByLabelText')
external /*Promise<Element>*/ _jsFindByLabelText(
  Element container,
  /*TextMatch*/
  text, [
  SelectorMatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);

@JS('rtl.findAllByLabelText')
external /*Promise<List<Element>>*/ _jsFindAllByLabelText(
  Element container,
  /*TextMatch*/
  text, [
  SelectorMatcherOptions options,
  SharedJsWaitForOptions waitForOptions,
]);
