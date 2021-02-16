import 'dart:html' show Element, ImageElement, InputElement, LabelElement, SelectElement, TextAreaElement;

import 'package:over_react_test/src/testing_library/dom/async/types.dart' show MutationObserverInit;
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
ImageElement getByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getByAltText(text, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByAltText] if a RTE is not expected.
///
/// > Related: [getByAltText]
///
/// > See: https://testing-library.com/docs/queries/byalttext/
List<ImageElement> getAllByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getAllByAltText(text, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a single [ImageElement] with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByAltText] if a RTE is expected.
///
/// > Related: [queryAllByAltText]
///
/// > See: <https://testing-library.com/docs/queries/byalttext/>
ImageElement queryByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryByAltText(text, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of [ImageElement]s with the given [text] as the value of the `alt` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByAltText] if a RTE is expected.
///
/// > Related: [queryByAltText]
///
/// > See: https://testing-library.com/docs/queries/byalttext/
List<ImageElement> queryAllByAltText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryAllByAltText(text, container: container, exact: exact, normalizer: normalizer);
}

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
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByAltText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
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
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByAltText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bydisplayvalue/
Element getByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/ value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getByDisplayValue(value, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByDisplayValue] if a RTE is not expected.
///
/// > Related: [getByDisplayValue]
///
/// > See: https://testing-library.com/docs/queries/bydisplayvalue/
List<Element> getAllByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/ value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getAllByDisplayValue(value, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a single [InputElement], [TextAreaElement] or [SelectElement] that has the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByDisplayValue] if a RTE is expected.
///
/// > Related: [queryAllByDisplayValue]
///
/// > See: https://testing-library.com/docs/queries/bydisplayvalue/
Element queryByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/ value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryByDisplayValue(value, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of [InputElement]s, [TextAreaElement]s or [SelectElement]s that have the matching [value] displayed,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByDisplayValue] if a RTE is expected.
///
/// > Related: [queryByDisplayValue]
///
/// > See: https://testing-library.com/docs/queries/bydisplayvalue/
List<Element> queryAllByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/ value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryAllByDisplayValue(value, container: container, exact: exact, normalizer: normalizer);
}

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
/// > See: https://testing-library.com/docs/queries/bydisplayvalue/
Future<Element> findByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/ value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByDisplayValue(value,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bydisplayvalue/
Future<List<Element>> findAllByDisplayValue(
  Element container,
  /*String|regex|bool Function(content, element)*/ value, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByDisplayValue(value,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bylabeltext/
Element getByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) {
  return within(container)
      .getByLabelText(text, container: container, exact: exact, normalizer: normalizer, selector: selector);
}

/// Returns a list of elements that are associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByLabelText] if a RTE is not expected.
///
/// > Related: [getByLabelText]
///
/// > See: https://testing-library.com/docs/queries/bylabeltext/
List<Element> getAllByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) {
  return within(container)
      .getAllByLabelText(text, container: container, exact: exact, normalizer: normalizer, selector: selector);
}

/// Returns a single element that is associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByLabelText] if a RTE is expected.
///
/// > Related: [queryAllByLabelText]
///
/// > See: https://testing-library.com/docs/queries/bylabeltext/
Element queryByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) {
  return within(container)
      .queryByLabelText(text, container: container, exact: exact, normalizer: normalizer, selector: selector);
}

/// Returns a list of elements that are associated with a [LabelElement] with the given [text],
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByLabelText] if a RTE is expected.
///
/// > Related: [queryByLabelText]
///
/// > See: https://testing-library.com/docs/queries/bylabeltext/
List<Element> queryAllByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
}) {
  return within(container)
      .queryAllByLabelText(text, container: container, exact: exact, normalizer: normalizer, selector: selector);
}

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
/// > See: https://testing-library.com/docs/queries/bylabeltext/
Future<Element> findByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByLabelText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      selector: selector,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bylabeltext/
Future<List<Element>> findAllByLabelText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByLabelText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      selector: selector,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/byplaceholdertext/
Element getByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getByPlaceholderText(text, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByPlaceholderText] if a RTE is not expected.
///
/// > Related: [getByPlaceholderText]
///
/// > See: https://testing-library.com/docs/queries/byplaceholdertext/
List<Element> getAllByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getAllByPlaceholderText(text, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a single element with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByPlaceholderText] if a RTE is expected.
///
/// > Related: [queryAllByPlaceholderText]
///
/// > See: https://testing-library.com/docs/queries/byplaceholdertext/
Element queryByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryByPlaceholderText(text, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of elements with the given [text] as the value of the `placeholder` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByPlaceholderText] if a RTE is expected.
///
/// > Related: [queryByPlaceholderText]
///
/// > See: https://testing-library.com/docs/queries/byplaceholdertext/
List<Element> queryAllByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryAllByPlaceholderText(text, container: container, exact: exact, normalizer: normalizer);
}

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
/// > See: https://testing-library.com/docs/queries/byplaceholdertext/
Future<Element> findByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByPlaceholderText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/byplaceholdertext/
Future<List<Element>> findAllByPlaceholderText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByPlaceholderText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/byrole/
///
/// ## Options
///
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
Element getByRole(
  Element container,
  /*String|regex|bool Function(content, element)*/ role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*String|regex|bool Function(content, element)*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) {
  return within(container).getByRole(role,
      container: container,
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
}

/// Returns a list of elements with the given [role] value, defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container]. Use [queryAllByRole] if a RTE is not expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [getByRole]
///
/// > See: https://testing-library.com/docs/queries/byrole/
///
/// ## Options
///
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
List<Element> getAllByRole(
  Element container,
  /*String|regex|bool Function(content, element)*/ role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*String|regex|bool Function(content, element)*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) {
  return within(container).getAllByRole(role,
      container: container,
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
}

/// Returns a single element with the given [role] value, defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container]. Use [getByRole] if a RTE is expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [queryAllByRole]
///
/// > See: https://testing-library.com/docs/queries/byrole/
///
/// ## Options
///
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
Element queryByRole(
  Element container,
  /*String|regex|bool Function(content, element)*/ role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*String|regex|bool Function(content, element)*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) {
  return within(container).queryByRole(role,
      container: container,
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
}

/// Returns a list of elements with the given [role] value, defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByRole] if a RTE is expected.
///
/// {@macro byRoleOptionsName}
///
/// > Related: [queryByRole]
///
/// > See: https://testing-library.com/docs/queries/byrole/
///
/// ## Options
///
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
List<Element> queryAllByRole(
  Element container,
  /*String|regex|bool Function(content, element)*/ role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*String|regex|bool Function(content, element)*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
}) {
  return within(container).queryAllByRole(role,
      container: container,
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
}

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
/// > See: https://testing-library.com/docs/queries/byrole/
///
/// ## Options
///
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
Future<Element> findByRole(
  Element container,
  /*String|regex|bool Function(content, element)*/ role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*String|regex|bool Function(content, element)*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByRole(role,
      container: container,
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
}

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
/// > See: https://testing-library.com/docs/queries/byrole/
///
/// ## Options
///
/// {@macro byRoleOptionsHidden}
/// {@macro byRoleOptionsSelected}
/// {@macro byRoleOptionsChecked}
/// {@macro byRoleOptionsPressed}
/// {@macro byRoleOptionsExpanded}
/// {@macro byRoleOptionsQueryFallbacks}
/// {@macro byRoleOptionsLevel}
Future<List<Element>> findAllByRole(
  Element container,
  /*String|regex|bool Function(content, element)*/ role, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  bool hidden = false,
  /*String|regex|bool Function(content, element)*/ dynamic name,
  bool selected,
  bool checked,
  bool pressed,
  bool expanded,
  bool queryFallbacks,
  int level,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByRole(role,
      container: container,
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
}

// ----------------------------------------------------
//  ByTestId
// ----------------------------------------------------

/// Returns a single element with the given [testId] value, defaulting to an [exact] match.
///
/// Throws if no element is found within the provided [container].
/// Use [queryByTestId] if a RTE is not expected.
///
/// > Related: [getAllByTestId]
///
/// > See: https://testing-library.com/docs/queries/bytestid/
Element getByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/ testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getByTestId(testId, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of elements with the given [testId] value, defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByTestId] if a RTE is not expected.
///
/// > Related: [getByTestId]
///
/// > See: https://testing-library.com/docs/queries/bytestid/
List<Element> getAllByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/ testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getAllByTestId(testId, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a single element with the given [testId] value, defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByTestId] if a RTE is expected.
///
/// > Related: [queryAllByTestId]
///
/// > See: https://testing-library.com/docs/queries/bytestid/
Element queryByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/ testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryByTestId(testId, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of elements with the given [testId] value, defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByTestId] if a RTE is expected.
///
/// > Related: [queryByTestId]
///
/// > See: https://testing-library.com/docs/queries/bytestid/
List<Element> queryAllByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/ testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryAllByTestId(testId, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a future with a single element value with the given [testId] value, defaulting to an [exact] match after
/// waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
///
/// Throws if exactly one element is not found within the provided [container].
///
/// > Related: [findAllByTestId]
///
/// > See: https://testing-library.com/docs/queries/bytestid/
Future<Element> findByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/ testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByTestId(testId,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

/// Returns a list of elements with the given [testId] value, defaulting to an [exact] match after
/// waiting 1000ms (or the provided [timeout] duration).
///
/// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
/// a non-async query like [findByTestId] or [queryByTestId] in a `waitFor` function.
///
/// Throws if no elements are found within the provided [container].
///
/// > Related: [findByTestId]
///
/// > See: https://testing-library.com/docs/queries/bytestid/
Future<List<Element>> findAllByTestId(
  Element container,
  /*String|regex|bool Function(content, element)*/ testId, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByTestId(testId,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bytext/
Element getByText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) {
  return within(container)
      .getByText(text, container: container, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);
}

/// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByText] if a RTE is not expected.
///
/// > Related: [getByText]
///
/// > See: https://testing-library.com/docs/queries/bytext/
List<Element> getAllByText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) {
  return within(container).getAllByText(text,
      container: container, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);
}

/// Returns a single element with the given [text] content, defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByText] if a RTE is expected.
///
/// > Related: [queryAllByText]
///
/// > See: https://testing-library.com/docs/queries/bytext/
Element queryByText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) {
  return within(container).queryByText(text,
      container: container, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);
}

/// Returns a list of elements with the given [text] content, defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByText] if a RTE is expected.
///
/// > Related: [queryByText]
///
/// > See: https://testing-library.com/docs/queries/bytext/
List<Element> queryAllByText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
}) {
  return within(container).queryAllByText(text,
      container: container, exact: exact, normalizer: normalizer, selector: selector, ignore: ignore);
}

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
/// > See: https://testing-library.com/docs/queries/bytext/
Future<Element> findByText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      selector: selector,
      ignore: ignore,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bytext/
Future<List<Element>> findAllByText(
  Element container,
  /*String|regex|bool Function(content, element)*/ text, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  String selector,
  /*String|bool*/ ignore,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByText(text,
      container: container,
      exact: exact,
      normalizer: normalizer,
      selector: selector,
      ignore: ignore,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bytitle/
Element getByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/ title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getByTitle(title, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of elements with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Throws if no elements are found within the provided [container].
/// Use [queryAllByTitle] if a RTE is not expected.
///
/// > Related: [getByTitle]
///
/// > See: https://testing-library.com/docs/queries/bytitle/
List<Element> getAllByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/ title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).getAllByTitle(title, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a single element with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Returns `null` if no element is found within the provided [container].
/// Use [getByTitle] if a RTE is expected.
///
/// > Related: [queryAllByTitle]
///
/// > See: https://testing-library.com/docs/queries/bytitle/
Element queryByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/ title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryByTitle(title, container: container, exact: exact, normalizer: normalizer);
}

/// Returns a list of elements with the given [title] as the value of the `title` attribute,
/// defaulting to an [exact] match.
///
/// Returns an empty list if no element(s) are found within the provided [container].
/// Use [getAllByTitle] if a RTE is expected.
///
/// > Related: [queryByTitle]
///
/// > See: https://testing-library.com/docs/queries/bytitle/
List<Element> queryAllByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/ title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
}) {
  return within(container).queryAllByTitle(title, container: container, exact: exact, normalizer: normalizer);
}

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
/// > See: https://testing-library.com/docs/queries/bytitle/
Future<Element> findByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/ title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findByTitle(title,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}

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
/// > See: https://testing-library.com/docs/queries/bytitle/
Future<List<Element>> findAllByTitle(
  Element container,
  /*String|regex|bool Function(content, element)*/ title, {
  bool exact = true,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  return within(container).findAllByTitle(title,
      container: container,
      exact: exact,
      normalizer: normalizer,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions);
}
