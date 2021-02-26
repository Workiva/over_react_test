import 'dart:html' show Element, ImageElement, InputElement, LabelElement, SelectElement, TextAreaElement;

import 'package:over_react_test/src/testing_library/dom/async/types.dart'
    show MutationObserverOptions, QueryTimeoutFn, defaultMutationObserverOptions;
import 'package:over_react_test/src/testing_library/dom/matches/types.dart' show NormalizerFn, NormalizerOptions;
import 'package:over_react_test/src/testing_library/dom/within.dart' show within;

// ----------------------------------------------------
//  ByAltText
// ----------------------------------------------------

/// Returns a single [ImageElement] with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
/// Use [queryByAltText] if a RTE is not expected.
///
/// > Related: [getAllByAltText]
///
/// > See: <https://testing-library.com/docs/queries/byalttext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
ImageElement getByAltText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getByAltText(text, exact: exact, normalizer: normalizer);

/// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByAltText] if a RTE is not expected.
///
/// > Related: [getByAltText]
///
/// > See: <https://testing-library.com/docs/queries/byalttext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<ImageElement> getAllByAltText(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getAllByAltText(text, exact: exact, normalizer: normalizer);

/// Returns a single [ImageElement] with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByAltText] if a RTE is expected.
///
/// > Related: [queryAllByAltText]
///
/// > See: <https://testing-library.com/docs/queries/byalttext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
ImageElement queryByAltText(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryByAltText(text, exact: exact, normalizer: normalizer);

/// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByAltText] if a RTE is expected.
///
/// > Related: [queryByAltText]
///
/// > See: <https://testing-library.com/docs/queries/byalttext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<ImageElement> queryAllByAltText(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryAllByAltText(text, exact: exact, normalizer: normalizer);

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
/// > See: <https://testing-library.com/docs/queries/byalttext/>
///
/// ## Options
///
/// __[text]__
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
Future<ImageElement> findByAltText(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByAltText(text,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

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
/// > See: <https://testing-library.com/docs/queries/byalttext/>
///
/// ## Options
///
/// __[text]__
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
Future<List<ImageElement>> findAllByAltText(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByAltText(text,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByDisplayValue
// ----------------------------------------------------

/// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
/// Use [queryByDisplayValue] if a RTE is not expected.
///
/// > Related: [getAllByDisplayValue]
///
/// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
///
/// ## Options
///
/// __[value]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E getByDisplayValue<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getByDisplayValue<E>(value, exact: exact, normalizer: normalizer);

/// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByDisplayValue] if a RTE is not expected.
///
/// > Related: [getByDisplayValue]
///
/// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
///
/// ## Options
///
/// __[value]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> getAllByDisplayValue<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getAllByDisplayValue<E>(value, exact: exact, normalizer: normalizer);

/// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByDisplayValue] if a RTE is expected.
///
/// > Related: [queryAllByDisplayValue]
///
/// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
///
/// ## Options
///
/// __[value]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E queryByDisplayValue<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryByDisplayValue<E>(value, exact: exact, normalizer: normalizer);

/// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByDisplayValue] if a RTE is expected.
///
/// > Related: [queryByDisplayValue]
///
/// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
///
/// ## Options
///
/// __[value]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> queryAllByDisplayValue<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryAllByDisplayValue<E>(value, exact: exact, normalizer: normalizer);

/// Returns a future with a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
/// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByDisplayValue] or [queryByDisplayValue] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
///
/// > Related: [findAllByDisplayValue]
///
/// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
///
/// ## Options
///
/// __[value]__
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
Future<E> findByDisplayValue<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByDisplayValue<E>(value,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
/// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByDisplayValue] or [queryByDisplayValue] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
///
/// > Related: [findByDisplayValue]
///
/// > See: <https://testing-library.com/docs/queries/bydisplayvalue/>
///
/// ## Options
///
/// __[value]__
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
Future<List<E>> findAllByDisplayValue<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByDisplayValue<E>(value,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByLabelText
// ----------------------------------------------------

/// Returns a single element that is associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
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
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E getByLabelText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) =>
    within(container).getByLabelText<E>(text, exact: exact, normalizer: normalizer, selector: selector);

/// Returns a list of elements that are associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
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
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> getAllByLabelText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) =>
    within(container).getAllByLabelText<E>(text, exact: exact, normalizer: normalizer, selector: selector);

/// Returns a single element that is associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
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
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E queryByLabelText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) =>
    within(container).queryByLabelText<E>(text, exact: exact, normalizer: normalizer, selector: selector);

/// Returns a list of elements that are associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
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
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> queryAllByLabelText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) =>
    within(container).queryAllByLabelText<E>(text, exact: exact, normalizer: normalizer, selector: selector);

/// Returns a future with a single element that is associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByLabelText] or [queryByLabelText] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
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
/// __[text]__
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
Future<E> findByLabelText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByLabelText<E>(text,
        exact: exact,
        normalizer: normalizer,
        selector: selector,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of elements that are associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByLabelText] or [queryByLabelText] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
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
/// __[text]__
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
Future<List<E>> findAllByLabelText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByLabelText<E>(text,
        exact: exact,
        normalizer: normalizer,
        selector: selector,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByPlaceholderText
// ----------------------------------------------------

/// Returns a single element with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
/// Use [queryByPlaceholderText] if a RTE is not expected.
///
/// > Related: [getAllByPlaceholderText]
///
/// > See: <https://testing-library.com/docs/queries/byplaceholdertext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E getByPlaceholderText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getByPlaceholderText<E>(text, exact: exact, normalizer: normalizer);

/// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByPlaceholderText] if a RTE is not expected.
///
/// > Related: [getByPlaceholderText]
///
/// > See: <https://testing-library.com/docs/queries/byplaceholdertext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> getAllByPlaceholderText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getAllByPlaceholderText<E>(text, exact: exact, normalizer: normalizer);

/// Returns a single element with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByPlaceholderText] if a RTE is expected.
///
/// > Related: [queryAllByPlaceholderText]
///
/// > See: <https://testing-library.com/docs/queries/byplaceholdertext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E queryByPlaceholderText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryByPlaceholderText<E>(text, exact: exact, normalizer: normalizer);

/// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByPlaceholderText] if a RTE is expected.
///
/// > Related: [queryByPlaceholderText]
///
/// > See: <https://testing-library.com/docs/queries/byplaceholdertext/>
///
/// ## Options
///
/// __[text]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> queryAllByPlaceholderText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryAllByPlaceholderText<E>(text, exact: exact, normalizer: normalizer);

/// Returns a future with a single element value with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByPlaceholderText] or [queryByPlaceholderText] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
///
/// > Related: [findAllByPlaceholderText]
///
/// > See: <https://testing-library.com/docs/queries/byplaceholdertext/>
///
/// ## Options
///
/// __[text]__
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
Future<E> findByPlaceholderText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByPlaceholderText<E>(text,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByPlaceholderText] or [queryByPlaceholderText] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
///
/// > Related: [findByPlaceholderText]
///
/// > See: <https://testing-library.com/docs/queries/byplaceholdertext/>
///
/// ## Options
///
/// __[text]__
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
Future<List<E>> findAllByPlaceholderText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByPlaceholderText<E>(text,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByRole
// ----------------------------------------------------

/// Returns a single element with the given [role] value, defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container]. Use [queryByRole] if a RTE is not expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [getAllByRole]
///
/// > See: <https://testing-library.com/docs/queries/byrole/>
///
/// ## Options
///
/// __[role]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
E getByRole<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*TextMatch*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) =>
    within(container).getByRole<E>(role,
        exact: exact,
        normalizer: normalizer,
        hidden: hidden,
        name: name,
        selected: selected,
        checked: checked,
        pressed: pressed,
        expanded: expanded,
        queryFallbacks: queryFallbacks,
        level: level);

/// Returns a list of elements with the given [role] value, defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container]. Use [queryAllByRole] if a RTE is not expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [getByRole]
///
/// > See: <https://testing-library.com/docs/queries/byrole/>
///
/// ## Options
///
/// __[role]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
List<E> getAllByRole<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*TextMatch*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) =>
    within(container).getAllByRole<E>(role,
        exact: exact,
        normalizer: normalizer,
        hidden: hidden,
        name: name,
        selected: selected,
        checked: checked,
        pressed: pressed,
        expanded: expanded,
        queryFallbacks: queryFallbacks,
        level: level);

/// Returns a single element with the given [role] value, defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container]. Use [getByRole] if a RTE is expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [queryAllByRole]
///
/// > See: <https://testing-library.com/docs/queries/byrole/>
///
/// ## Options
///
/// __[role]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
E queryByRole<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*TextMatch*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) =>
    within(container).queryByRole<E>(role,
        exact: exact,
        normalizer: normalizer,
        hidden: hidden,
        name: name,
        selected: selected,
        checked: checked,
        pressed: pressed,
        expanded: expanded,
        queryFallbacks: queryFallbacks,
        level: level);

/// Returns a list of elements with the given [role] value, defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByRole] if a RTE is expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [queryByRole]
///
/// > See: <https://testing-library.com/docs/queries/byrole/>
///
/// ## Options
///
/// __[role]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
List<E> queryAllByRole<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*TextMatch*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) =>
    within(container).queryAllByRole<E>(role,
        exact: exact,
        normalizer: normalizer,
        hidden: hidden,
        name: name,
        selected: selected,
        checked: checked,
        pressed: pressed,
        expanded: expanded,
        queryFallbacks: queryFallbacks,
        level: level);

/// Returns a future with a single element value with the given [role] value, defaulting to an [exact] match after
/// waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByRole] or [queryByRole] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
///
/// {@macro byRoleOptionsName}
///
/// > Related: [findAllByRole]
///
/// > See: <https://testing-library.com/docs/queries/byrole/>
///
/// ## Options
///
/// __[role]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
///
/// ## Async Options
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<E> findByRole<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*TextMatch*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByRole<E>(role,
        exact: exact,
        normalizer: normalizer,
        hidden: hidden,
        name: name,
        selected: selected,
        checked: checked,
        pressed: pressed,
        expanded: expanded,
        queryFallbacks: queryFallbacks,
        level: level,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of elements with the given [role] value, defaulting to an [exact] match after
/// waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByRole] or [queryByRole] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
///
/// {@macro byRoleOptionsName}
///
/// > Related: [findByRole]
///
/// > See: <https://testing-library.com/docs/queries/byrole/>
///
/// ## Options
///
/// __[role]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
///
/// ## Async Options
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<List<E>> findAllByRole<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*TextMatch*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByRole<E>(role,
        exact: exact,
        normalizer: normalizer,
        hidden: hidden,
        name: name,
        selected: selected,
        checked: checked,
        pressed: pressed,
        expanded: expanded,
        queryFallbacks: queryFallbacks,
        level: level,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByTestId
// ----------------------------------------------------

/// Returns a single element with the given [testId] value for the `data-test-id` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
/// Use [queryByTestId] if a RTE is not expected.
///
/// > Related: [getAllByTestId]
///
/// > See: <https://testing-library.com/docs/queries/bytestid/>
///
/// ## Options
///
/// __[testId]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E getByTestId<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getByTestId<E>(testId, exact: exact, normalizer: normalizer);

/// Returns a list of elements with the given [testId] value for the `data-test-id` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByTestId] if a RTE is not expected.
///
/// > Related: [getByTestId]
///
/// > See: <https://testing-library.com/docs/queries/bytestid/>
///
/// ## Options
///
/// __[testId]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> getAllByTestId<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getAllByTestId<E>(testId, exact: exact, normalizer: normalizer);

/// Returns a single element with the given [testId] value for the `data-test-id` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByTestId] if a RTE is expected.
///
/// > Related: [queryAllByTestId]
///
/// > See: <https://testing-library.com/docs/queries/bytestid/>
///
/// ## Options
///
/// __[testId]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
E queryByTestId<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryByTestId<E>(testId, exact: exact, normalizer: normalizer);

/// Returns a list of elements with the given [testId] value for the `data-test-id` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByTestId] if a RTE is expected.
///
/// > Related: [queryByTestId]
///
/// > See: <https://testing-library.com/docs/queries/bytestid/>
///
/// ## Options
///
/// __[testId]__
/// {@macro TextMatchArgDescription}
/// {@macro MatcherOptionsExactArgDescription}
/// {@macro MatcherOptionsNormalizerArgDescription}
List<E> queryAllByTestId<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryAllByTestId<E>(testId, exact: exact, normalizer: normalizer);

/// Returns a future with a single element value with the given [testId] value for the `data-test-id` attribute,
/// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
///
/// > Related: [findAllByTestId]
///
/// > See: <https://testing-library.com/docs/queries/bytestid/>
///
/// ## Options
///
/// __[testId]__
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
Future<E> findByTestId<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByTestId<E>(testId,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of elements with the given [testId] value for the `data-test-id` attribute,
/// defaulting to an [exact] match after waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
///
/// > Related: [findByTestId]
///
/// > See: <https://testing-library.com/docs/queries/bytestid/>
///
/// ## Options
///
/// __[testId]__
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
Future<List<E>> findAllByTestId<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByTestId<E>(testId,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByText
// ----------------------------------------------------

/// Returns a single element with the given [text] content, defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
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
E getByText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) =>
    within(container).getByText<E>(text, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);

/// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
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
List<E> getAllByText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) =>
    within(container).getAllByText<E>(text, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);

/// Returns a single element with the given [text] content, defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
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
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) =>
    within(container).queryByText<E>(text, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);

/// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
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
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) =>
    within(container).queryAllByText<E>(text, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);

/// Returns a future with a single element value with the given [text] content, defaulting to an [exact] match after
/// waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByText] or [queryByText] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
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
///
/// ## Async Options
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<E> findByText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByText<E>(text,
        exact: exact,
        normalizer: normalizer,
        selector: selector,
        ignore: ignore,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of elements with the given [text] content, defaulting to an [exact] match after
/// waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByText] or [queryByText] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
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
///
/// ## Async Options
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<List<E>> findAllByText<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByText<E>(text,
        exact: exact,
        normalizer: normalizer,
        selector: selector,
        ignore: ignore,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

// ----------------------------------------------------
//  ByTitle
// ----------------------------------------------------

/// Returns a single element with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
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
E getByTitle<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getByTitle<E>(title, exact: exact, normalizer: normalizer);

/// Returns a list of elements with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
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
List<E> getAllByTitle<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).getAllByTitle<E>(title, exact: exact, normalizer: normalizer);

/// Returns a single element with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
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
  Element container,
  /*TextMatch*/ dynamic title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryByTitle<E>(title, exact: exact, normalizer: normalizer);

/// Returns a list of elements with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
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
  Element container,
  /*TextMatch*/ dynamic title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) =>
    within(container).queryAllByTitle<E>(title, exact: exact, normalizer: normalizer);

/// Returns a future with a single element value with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByTitle] or [queryByTitle] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
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
Future<E> findByTitle<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findByTitle<E>(title,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);

/// Returns a list of elements with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match after waiting `1000ms` (or the specified [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByTitle] or [queryByTitle] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
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
Future<List<E>> findAllByTitle<E extends Element>(
  Element container,
  /*TextMatch*/ dynamic title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) =>
    within(container).findAllByTitle<E>(title,
        exact: exact,
        normalizer: normalizer,
        timeout: timeout,
        interval: interval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions);
