/// https://testing-library.com/docs/queries/byrole/
@JS()
library over_react_test.src.testing_library.dom.queries.by_role;

import 'dart:html' show Element;

import 'package:js/js.dart';
import 'package:meta/meta.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/async/wait_for.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart';
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart' show promiseToFutureWithErrorInterop, withErrorInterop;

/// PRIVATE. Do not export from this library.
///
/// The public API is either the top level function by the same name as the methods in here,
/// or the methods by the same name exposed by `screen` / `within()`.
mixin ByRoleQueries on IQueries {
  @protected
  ByRoleOptions buildByRoleOptions({
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
  }) {
    final matcherOptions = super.buildMatcherOptions(exact: exact, normalizer: normalizer);
    final byRoleOptions = ByRoleOptions()
      ..exact = matcherOptions.exact
      ..normalizer = matcherOptions.normalizer
      ..hidden = hidden;
    if (name != null) byRoleOptions.name = TextMatch.parse(name);
    if (selected != null) byRoleOptions.selected = selected;
    if (checked != null) byRoleOptions.checked = checked;
    if (pressed != null) byRoleOptions.pressed = pressed;
    if (expanded != null) byRoleOptions.expanded = expanded;
    if (queryFallbacks != null) byRoleOptions.queryFallbacks = queryFallbacks;
    if (level != null) byRoleOptions.level = level;

    return byRoleOptions;
  }

  /// Returns a single element with the given [role] value, defaulting to an [exact] match.
  ///
  /// Throws if no element is found. Use [queryByRole] if a RTE is not expected.
  ///
  /// {@macro byRoleOptionsName}
  ///
  /// > Related: [getAllByRole]
  ///
  /// > See: <https://testing-library.com/docs/queries/byrole/>
  ///
  /// ## Options
  ///
  /// ### [role]
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
  Element getByRole(
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
      withErrorInterop(() => _jsGetByRole(
          getContainerForScope(),
          TextMatch.parse(role),
          buildByRoleOptions(
              exact: exact,
              normalizer: normalizer,
              hidden: hidden,
              name: name,
              selected: selected,
              checked: checked,
              pressed: pressed,
              expanded: expanded,
              queryFallbacks: queryFallbacks,
              level: level)));

  /// Returns a list of elements with the given [role] value, defaulting to an [exact] match.
  ///
  /// Throws if no elements are found. Use [queryAllByRole] if a RTE is not expected.
  ///
  /// {@macro byRoleOptionsName}
  ///
  /// > Related: [getByRole]
  ///
  /// > See: <https://testing-library.com/docs/queries/byrole/>
  ///
  /// ## Options
  ///
  /// ### [role]
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
  List<Element> getAllByRole(
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
      withErrorInterop(() => _jsGetAllByRole(
          getContainerForScope(),
          TextMatch.parse(role),
          buildByRoleOptions(
              exact: exact,
              normalizer: normalizer,
              hidden: hidden,
              name: name,
              selected: selected,
              checked: checked,
              pressed: pressed,
              expanded: expanded,
              queryFallbacks: queryFallbacks,
              level: level)));

  /// Returns a single element with the given [role] value, defaulting to an [exact] match.
  ///
  /// Returns `null` if no element is found. Use [getByRole] if a RTE is expected.
  ///
  /// {@macro byRoleOptionsName}
  ///
  /// > Related: [queryAllByRole]
  ///
  /// > See: <https://testing-library.com/docs/queries/byrole/>
  ///
  /// ## Options
  ///
  /// ### [role]
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
  Element queryByRole(
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
      _jsQueryByRole(
          getContainerForScope(),
          TextMatch.parse(role),
          buildByRoleOptions(
              exact: exact,
              normalizer: normalizer,
              hidden: hidden,
              name: name,
              selected: selected,
              checked: checked,
              pressed: pressed,
              expanded: expanded,
              queryFallbacks: queryFallbacks,
              level: level));

  /// Returns a list of elements with the given [role] value, defaulting to an [exact] match.
  ///
  /// Returns an empty list if no element(s) are found.
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
  /// ### [role]
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
  List<Element> queryAllByRole(
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
      _jsQueryAllByRole(
          getContainerForScope(),
          TextMatch.parse(role),
          buildByRoleOptions(
              exact: exact,
              normalizer: normalizer,
              hidden: hidden,
              name: name,
              selected: selected,
              checked: checked,
              pressed: pressed,
              expanded: expanded,
              queryFallbacks: queryFallbacks,
              level: level));

  /// Returns a future with a single element value with the given [role] value, defaulting to an [exact] match after
  /// waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByRole] or [queryByRole] in a `waitFor` function.
  ///
  /// Throws if exactly one element is not found.
  ///
  /// {@macro byRoleOptionsName}
  ///
  /// > Related: [findAllByRole]
  ///
  /// > See: <https://testing-library.com/docs/queries/byrole/>
  ///
  /// ## Options
  ///
  /// ### [role]
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
  Future<Element> findByRole(
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
    /*Error*/dynamic Function(/*Error*/dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildByRoleOptions(
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
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindAllByRole because of some weirdness with
    // the wrong error message being displayed when the role is found, but the name arg is specified and it isn't found in the DOM.
    // return promiseToFuture(
    //     _jsFindByRole(getContainerForScope(), TextMatch.parse(role), matcherOptions, waitForOptions));
    return waitFor(
        () => getByRole(role,
          exact: matcherOptions.exact,
          normalizer: matcherOptions.normalizer,
          hidden: matcherOptions.hidden,
          name: matcherOptions.name,
          selected: matcherOptions.selected,
          checked: matcherOptions.checked,
          pressed: matcherOptions.pressed,
          expanded: matcherOptions.expanded,
          queryFallbacks: matcherOptions.queryFallbacks,
          level: matcherOptions.level,
        ),
        container: getContainerForScope(),
        timeout: timeout,
        interval: interval ?? defaultAsyncCallbackCheckInterval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions ?? defaultMutationObserverOptions,
    );
  }

  /// Returns a list of elements with the given [role] value, defaulting to an [exact] match after
  /// waiting 1000ms (or the provided [timeout] duration).
  ///
  /// If there is a specific condition you want to wait for other than the DOM node being on the page, wrap
  /// a non-async query like [findByRole] or [queryByRole] in a `waitFor` function.
  ///
  /// Throws if no elements are found.
  ///
  /// {@macro byRoleOptionsName}
  ///
  /// > Related: [findByRole]
  ///
  /// > See: <https://testing-library.com/docs/queries/byrole/>
  ///
  /// ## Options
  ///
  /// ### [role]
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
  Future<List<Element>> findAllByRole(
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
    /*Error*/dynamic Function(/*Error*/dynamic originalError) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final matcherOptions = buildByRoleOptions(
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
    final waitForOptions = buildWaitForOptions(
        timeout: timeout, interval: interval, onTimeout: onTimeout, mutationObserverOptions: mutationObserverOptions);

    // NOTE: Using our own Dart waitFor as a wrapper instead of calling _jsFindAllByRole because of some weirdness with
    // the wrong error message being displayed when the role is found, but the name arg is specified and it isn't found in the DOM.
    // return promiseToFuture(
    //     _jsFindAllByRole(getContainerForScope(), TextMatch.parse(role), matcherOptions, waitForOptions));
    return waitFor(
        () => getAllByRole(role,
          exact: matcherOptions.exact,
          normalizer: matcherOptions.normalizer,
          hidden: matcherOptions.hidden,
          name: matcherOptions.name,
          selected: matcherOptions.selected,
          checked: matcherOptions.checked,
          pressed: matcherOptions.pressed,
          expanded: matcherOptions.expanded,
          queryFallbacks: matcherOptions.queryFallbacks,
          level: matcherOptions.level,
        ),
        container: getContainerForScope(),
        timeout: timeout,
        interval: interval ?? defaultAsyncCallbackCheckInterval,
        onTimeout: onTimeout,
        mutationObserverOptions: mutationObserverOptions ?? defaultMutationObserverOptions,
    );
  }
}

@JS('rtl.getByRole')
external Element _jsGetByRole(
  Element container,
  /*TextMatch*/
  role, [
  ByRoleOptions options,
]);

@JS('rtl.getAllByRole')
external List<Element> _jsGetAllByRole(
  Element container,
  /*TextMatch*/
  role, [
  ByRoleOptions options,
]);

@JS('rtl.queryByRole')
external Element _jsQueryByRole(
  Element container,
  /*TextMatch*/
  role, [
  ByRoleOptions options,
]);

@JS('rtl.queryAllByRole')
external List<Element> _jsQueryAllByRole(
  Element container,
  /*TextMatch*/
  role, [
  ByRoleOptions options,
]);

// @JS('rtl.findByRole')
// external /*Promise<Element>*/ _jsFindByRole(
//   Element container,
//   /*TextMatch*/
//   role, [
//   ByRoleOptions options,
//   SharedJsWaitForOptions waitForOptions,
// ]);
//
// @JS('rtl.findAllByRole')
// external /*Promise<List<Element>>*/ _jsFindAllByRole(
//   Element container,
//   /*TextMatch*/
//   role, [
//   ByRoleOptions options,
//   SharedJsWaitForOptions waitForOptions,
// ]);

@JS()
@anonymous
class ByRoleOptions extends MatcherOptions {
  /// {@template byRoleOptionsName}
  /// You can also query the returned element(s) by their [accessible name](https://www.w3.org/TR/accname-1.1/)
  /// by specifying the `name` argument: `getByRole(expectedRole, name: 'The name')`.
  ///
  /// The accessible `name` is for simple cases equal to the label of a form element, or the text content of a button,
  /// or the value of the `aria-label` attribute. It can be used to query a specific element if multiple elements
  /// with the same role are present on the rendered content.
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#api> for more details and examples.
  /// {@endtemplate}
  external /*TextMatch*/ dynamic get name;
  external set name(/*TextMatch*/ dynamic value);

  /// {@template byRoleOptionsHidden}
  /// ### hidden
  /// If you set `hidden` to true, elements that are normally excluded from the accessibility tree are
  /// considered for the query as well.
  ///
  /// The default behavior follows <https://www.w3.org/TR/wai-aria-1.2/#tree_exclusion> with the exception of
  /// `role="none"` and `role="presentation"` which are considered in the query in any case.
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#hidden> for more details and examples.
  /// {@endtemplate}
  external bool get hidden;
  external set hidden(bool value);

  /// {@template byRoleOptionsSelected}
  /// ### selected
  /// You can filter the returned elements by their selected state by setting `selected: true` or `selected: false`.
  ///
  /// To learn more about the selected state and which elements can have this state see
  /// [ARIA `aria-selected`](https://www.w3.org/TR/wai-aria-1.2/#aria-selected).
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#selected> for more details and examples.
  /// {@endtemplate}
  external bool get selected;
  external set selected(bool value);

  /// {@template byRoleOptionsChecked}
  /// ### checked
  /// You can filter the returned elements by their checked state by setting `checked: true` or `checked: false`.
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#checked> for more details and examples.
  /// {@endtemplate}
  external bool get checked;
  external set checked(bool value);

  /// {@template byRoleOptionsPressed}
  /// ### pressed
  /// Buttons can have a pressed state. You can filter the returned elements by their pressed state by
  /// setting `pressed: true` or `pressed: false`.
  ///
  /// To learn more about the pressed state see [ARIA `aria-pressed`](https://www.w3.org/TR/wai-aria-1.2/#aria-pressed).
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#pressed> for more details and examples.
  /// {@endtemplate}
  external bool get pressed;
  external set pressed(bool value);

  /// {@template byRoleOptionsExpanded}
  /// ### expanded
  /// You can filter the returned elements by their expanded state by setting `expanded: true` or `expanded: false`.
  ///
  /// To learn more about the expanded state and which elements can have this state see
  /// [ARIA `aria-expanded`](https://www.w3.org/TR/wai-aria-1.2/#aria-expanded).
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#expanded> for more details and examples.
  /// {@endtemplate}
  external bool get expanded;
  external set expanded(bool value);

  /// {@template byRoleOptionsQueryFallbacks}
  /// ### queryFallbacks
  /// By default, it's assumed that the first role of each element is supported,
  /// so only the first role can be queried. If you need to query an element by
  /// any of its fallback roles instead, you can use `queryFallbacks: true`.
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#queryfallbacks> for more details and examples.
  /// {@endtemplate}
  external bool get queryFallbacks;
  external set queryFallbacks(bool value);

  /// {@template byRoleOptionsLevel}
  /// ### level
  /// An element with the `heading` role can be queried by any heading level `getByRole('heading')`
  /// or by a specific heading level using the `level` option `getByRole('heading', level: 2)`.
  ///
  /// The level option queries the element(s) with the `heading` role matching the indicated level
  /// determined by the semantic HTML heading elements `<h1>`-`<h6>` or matching the `aria-level` attribute.
  ///
  /// To learn more about the `aria-level` property, see
  /// [ARIA `aria-level`](https://www.w3.org/TR/wai-aria-1.2/#aria-level).
  ///
  /// See: <https://testing-library.com/docs/queries/byrole#level> for more details and examples.
  /// {@endtemplate}
  external int get level;
  external set level(int value);
}
