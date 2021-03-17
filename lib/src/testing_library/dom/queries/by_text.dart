// @dart = 2.7

/// https://testing-library.com/docs/queries/bytext/
@JS()
library over_react_test.src.testing_library.dom.queries.by_text;

import 'dart:html' show Element;

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart' show withErrorInterop;

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
  /// > See: <https://testing-library.com/docs/queries/bytext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [ignore]
  /// Accepts a query selector. If `node.matches` returns true for that selector, the node will be ignored.
  /// This defaults to `'script'` because generally you don't want to select script tags, but if your
  /// content is in an inline script file, then the script tag could be returned.
  ///
  /// If you'd rather disable this behavior, set to `false`.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  /// {@macro MatcherOptionsErrorMessage}
  E getByText<E extends Element>(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      withErrorInterop(
          () => _jsGetByText(getContainerForScope(), TextMatch.parse(text),
              buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector)),
          errorMessage: errorMessage);

  /// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
  ///
  /// Throws if no elements are found.
  /// Use [queryAllByText] if a RTE is not expected.
  ///
  /// > Related: [getByText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [ignore]
  /// Accepts a query selector. If `node.matches` returns true for that selector, the node will be ignored.
  /// This defaults to `'script'` because generally you don't want to select script tags, but if your
  /// content is in an inline script file, then the script tag could be returned.
  ///
  /// If you'd rather disable this behavior, set to `false`.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  /// {@macro MatcherOptionsErrorMessage}
  List<E> getAllByText<E extends Element>(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      withErrorInterop(
          () => _jsGetAllByText(getContainerForScope(), TextMatch.parse(text),
                  buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector))
              // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
              .cast<E>(),
          errorMessage: errorMessage);

  /// Returns a single element with the given [text] content, defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found.
  /// Use [getByText] if a RTE is expected.
  ///
  /// > Related: [queryAllByText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [ignore]
  /// Accepts a query selector. If `node.matches` returns true for that selector, the node will be ignored.
  /// This defaults to `'script'` because generally you don't want to select script tags, but if your
  /// content is in an inline script file, then the script tag could be returned.
  ///
  /// If you'd rather disable this behavior, set to `false`.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  E queryByText<E extends Element>(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      _jsQueryByText(getContainerForScope(), TextMatch.parse(text),
          buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector));

  /// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
  /// Use [getAllByText] if a RTE is expected.
  ///
  /// > Related: [queryByText]
  ///
  /// > See: <https://testing-library.com/docs/queries/bytext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [ignore]
  /// Accepts a query selector. If `node.matches` returns true for that selector, the node will be ignored.
  /// This defaults to `'script'` because generally you don't want to select script tags, but if your
  /// content is in an inline script file, then the script tag could be returned.
  ///
  /// If you'd rather disable this behavior, set to `false`.
  ///
  /// ### [text]
  /// {@macro TextMatchArgDescription}
  /// {@macro MatcherOptionsExactArgDescription}
  /// {@macro MatcherOptionsNormalizerArgDescription}
  List<E> queryAllByText<E extends Element>(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String selector,
    /*String|bool*/ ignore,
  }) =>
      _jsQueryAllByText(getContainerForScope(), TextMatch.parse(text),
              buildByTextOptions(exact: exact, normalizer: normalizer, ignore: ignore, selector: selector))
          // <vomit/> https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5
          .cast<E>();

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
  /// > See: <https://testing-library.com/docs/queries/bytext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [ignore]
  /// Accepts a query selector. If `node.matches` returns true for that selector, the node will be ignored.
  /// This defaults to `'script'` because generally you don't want to select script tags, but if your
  /// content is in an inline script file, then the script tag could be returned.
  ///
  /// If you'd rather disable this behavior, set to `false`.
  ///
  /// ### [text]
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
  Future<E> findByText<E extends Element>(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    String selector,
    /*String|bool*/ ignore,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindByText for consistency with our
    // need to use it on the analogous `findAllByText` query.
    return waitFor(
      () => getByText<E>(
        text,
        exact: exact,
        normalizer: normalizer,
        selector: selector,
        errorMessage: errorMessage,
      ),
      container: getContainerForScope(),
      timeout: timeout,
      interval: interval ?? defaultAsyncCallbackCheckInterval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions ?? defaultMutationObserverOptions,
    );
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
  /// > See: <https://testing-library.com/docs/queries/bytext/>
  ///
  /// ## Options
  ///
  /// ### [selector]
  /// If there are multiple labels with the same text, you can use `selector`
  /// to specify the element you want to match.
  ///
  /// ### [ignore]
  /// Accepts a query selector. If `node.matches` returns true for that selector, the node will be ignored.
  /// This defaults to `'script'` because generally you don't want to select script tags, but if your
  /// content is in an inline script file, then the script tag could be returned.
  ///
  /// If you'd rather disable this behavior, set to `false`.
  ///
  /// ### [text]
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
  Future<List<E>> findAllByText<E extends Element>(
    /*TextMatch*/ dynamic text, {
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
    String errorMessage,
    String selector,
    /*String|bool*/ ignore,
    Duration timeout,
    Duration interval,
    QueryTimeoutFn onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindAllByText because of the inability
    // to call `.cast<E>` on the list before returning to consumers (https://dartpad.dev/6d3df9e7e03655ed33f5865596829ef5)
    // like we can/must on the `getAllByText` return value.
    return waitFor(
      () => getAllByText<E>(
        text,
        exact: exact,
        normalizer: normalizer,
        selector: selector,
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

@JS('rtl.getByText')
external Element _jsGetByText(
  Element container,
  /*TextMatch*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.getAllByText')
external List<Element> _jsGetAllByText(
  Element container,
  /*TextMatch*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.queryByText')
external Element _jsQueryByText(
  Element container,
  /*TextMatch*/
  text, [
  ByTextOptions options,
]);

@JS('rtl.queryAllByText')
external List<Element> _jsQueryAllByText(
  Element container,
  /*TextMatch*/
  text, [
  ByTextOptions options,
]);

@JS()
@anonymous
class ByTextOptions extends SelectorMatcherOptions {
  external /*String|bool*/ get ignore;
  external set ignore(/*String|bool*/ value);
}
