// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@JS()
library over_react_test.react_util;

import 'dart:collection';
import 'dart:html';

import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:js/js.dart';
import 'package:over_react/component_base.dart' as component_base;
import 'package:over_react/over_react.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

import '../../over_react_test.dart';

export 'package:over_react/src/util/react_wrappers.dart';

// Notes
// ---------------------------------------------------------------------------
//
// 1.  This is of type `dynamic` out of necessity, since the actual type,
//     `ReactComponent | Element`, cannot be expressed in Dart's type system.
//
//     React 0.14 augments DOM nodes with its own properties and uses them as
//     DOM component instances. To Dart's JS interop, those instances look
//     like DOM nodes, so they get converted to the corresponding DOM node
//     interceptors, and thus cannot be used with a custom `@JS()` class.
//
//     So, React composite component instances will be of type
//     `ReactComponent`, whereas DOM component instance will be of type
//     `Element`.

/// Renders a React component or builder into a detached node and returns the component instance.
///
/// By default the rendered instance will be unmounted after the current test, to prevent this behavior set
/// [autoTearDown] to false. If [autoTearDown] is set to true once it will, if provided, call [autoTearDownCallback]
/// once the component has been unmounted.
/* [1] */ render(dynamic component,
    {bool autoTearDown = true,
    Element? container,
    Callback? autoTearDownCallback}) {
  var renderedInstance;
  component = component is component_base.UiProps ? component() : component;

  setComponentZone();

  if (container == null) {
    renderedInstance = react_test_utils.renderIntoDocument(component);
  } else {
    renderedInstance = react_dom.render(component, container);
  }

  if (autoTearDown) {
    addTearDown(() {
      unmount(renderedInstance);
      if (autoTearDownCallback != null) autoTearDownCallback();
    });
  }

  return renderedInstance;
}

/// Shallow-renders a component using [react_test_utils.ReactShallowRenderer].
///
/// By default the rendered instance will be unmounted after the current test, to prevent this behavior set
/// [autoTearDown] to false.
///
/// See: <https://facebook.github.io/react/docs/test-utils.html#shallow-rendering>.
ReactElement renderShallow(ReactElement instance, {bool autoTearDown = true, Callback? autoTearDownCallback}) {
  var renderer = react_test_utils.createRenderer();
  if (autoTearDown) {
    addTearDown(() {
      renderer.unmount();
      if (autoTearDownCallback != null) autoTearDownCallback();
    });
  }
  renderer.render(instance);
  return renderer.getRenderOutput();
}

/// Unmounts a React component.
///
/// [instanceOrContainerNode] can be a `ReactComponent`/[Element] React instance,
/// or an [Element] container node (argument to [react_dom.render]).
///
/// For convenience, this method does nothing if [instanceOrContainerNode] is null,
/// or if it's a non-mounted React instance.
void unmount(dynamic instanceOrContainerNode) {
  if (instanceOrContainerNode == null) return;

  final Element? containerNode;

  if (instanceOrContainerNode is Element) {
    containerNode = instanceOrContainerNode;
  } else if (
      react_test_utils.isCompositeComponent(instanceOrContainerNode) ||
      react_test_utils.isDOMComponent(instanceOrContainerNode)
  ) {
    try {
      containerNode = findDomNode(instanceOrContainerNode)?.parent;
    } catch (e) {
      return;
    }
  } else {
    throw ArgumentError(
        '`instanceOrNode` must be null, a ReactComponent instance, or an Element. Was: $instanceOrContainerNode.'
    );
  }

  if (containerNode != null) react_dom.unmountComponentAtNode(containerNode);
}

/// Renders a React component or builder into a detached node and returns the associated DOM node.
///
/// By default the rendered instance will be unmounted after the current test, to prevent this behavior set
/// [autoTearDown] to false.
///
/// > If [component] is a function component, calling [renderAndGetDom] will throw a `StateError`.
/// >
/// > See `TestJacket.getNode` for more information about this limitation.
Element? renderAndGetDom(dynamic component, {bool autoTearDown = true, Callback? autoTearDownCallback}) {
  final renderedInstance = render(component, autoTearDown: autoTearDown, autoTearDownCallback: autoTearDownCallback);

  if (!react_test_utils.isCompositeComponent(renderedInstance) && !react_test_utils.isDOMComponent(renderedInstance)) {
    throw StateError(
      'renderAndGetDom() is only supported when the rendered object is a DOM or composite (class based) component.');
  }

  return findDomNode(renderedInstance);
}

/// Renders a React component or builder into a detached node and returns the associated Dart component.
///
/// > If [component] is a function component, calling [renderAndGetComponent] will throw a `StateError`.
/// >
/// > See `TestJacket.getInstance` for more information about this limitation.
react.Component? renderAndGetComponent(dynamic component,
        {bool autoTearDown = true, Callback? autoTearDownCallback}) {
  final renderedInstance = render(component, autoTearDown: autoTearDown, autoTearDownCallback: autoTearDownCallback);

  // [1] Adding an additional check for dom components here because the current behavior when `renderedInstance` is
  //     a DOM component (Element) - is to return `null`. While that will most likely cause null exceptions once the
  //     consumer attempts to make a call on the "Dart instance" they have requested - we don't want this change
  //     to cause new exceptions in a scenario where the consumer was storing a null value and then simply
  //     not using it in their test.
  if (!react_test_utils.isCompositeComponent(renderedInstance) &&
      /*[1]*/!react_test_utils.isDOMComponent(renderedInstance)) {
    throw StateError(
      'renderAndGetComponent() is only supported when the rendered object is a composite (class based) component.');
  }

  return getDartComponent(renderedInstance);
}

/// List of elements attached to the DOM and used as mount points in previous calls to [renderAttachedToDocument].
List<Element> _attachedReactContainers = [];

/// Renders the component into a node attached to document.body as opposed to a detached node.
///
/// Returns the rendered component.
/* [1] */ renderAttachedToDocument(dynamic component,
    {bool autoTearDown = true,
    Element? container,
    Callback? autoTearDownCallback}) {
  final containerElement = container ??
      (DivElement()
        // Set arbitrary height and width for container to ensure nothing is cut off.
        ..style.setProperty('width', '800px')
        ..style.setProperty('height', '800px'));

  setComponentZone();

  document.body!.append(containerElement);

  if (autoTearDown) {
    addTearDown(() {
      react_dom.unmountComponentAtNode(containerElement);
      containerElement.remove();
      if (autoTearDownCallback != null) autoTearDownCallback();
    });
  } else {
    _attachedReactContainers.add(containerElement);
  }

  return react_dom.render(component is component_base.UiProps ? component.build() : component, containerElement);
}

/// Unmounts and removes the mount nodes for components rendered via [renderAttachedToDocument] that are not
/// automatically unmounted.
void tearDownAttachedNodes() {
  for (var container in _attachedReactContainers) {
    react_dom.unmountComponentAtNode(container);
    container.remove();
  }
}

typedef void _EventSimulatorAlias(componentOrNode, [Map? eventData]);

/// Helper function to simulate clicks
final _EventSimulatorAlias click = react_test_utils.Simulate.click;

/// Helper function to simulate change
final _EventSimulatorAlias change = react_test_utils.Simulate.change;

/// Helper function to simulate focus
final _EventSimulatorAlias focus = react_test_utils.Simulate.focus;

/// Helper function to simulate blur
final _EventSimulatorAlias blur = react_test_utils.Simulate.blur;

/// Helper function to simulate mouseMove events.
final _EventSimulatorAlias mouseMove = react_test_utils.Simulate.mouseMove;

/// Helper function to simulate keyDown events.
final _EventSimulatorAlias keyDown = react_test_utils.Simulate.keyDown;

/// Helper function to simulate keyUp events.
final _EventSimulatorAlias keyUp = react_test_utils.Simulate.keyUp;

/// Helper function to simulate keyPress events.
final _EventSimulatorAlias keyPress = react_test_utils.Simulate.keyPress;

/// Helper function to simulate mouseDown events.
final _EventSimulatorAlias mouseDown = react_test_utils.Simulate.mouseDown;

/// Helper function to simulate mouseDown events.
final _EventSimulatorAlias mouseUp = react_test_utils.Simulate.mouseUp;

/// Helper function to simulate mouseEnter events.
final _EventSimulatorAlias mouseEnter = (componentOrNode, [Map? eventData = const {}]) =>
    Simulate._mouseEnter(componentOrNode, jsifyAndAllowInterop(eventData));

/// Helper function to simulate mouseLeave events.
final _EventSimulatorAlias mouseLeave = (componentOrNode, [Map? eventData = const {}]) =>
    Simulate._mouseLeave(componentOrNode, jsifyAndAllowInterop(eventData));

@JS('React.addons.TestUtils.Simulate')
abstract class Simulate {
  @JS('mouseEnter')
  external static void _mouseEnter(dynamic target, [eventData]);

  @JS('mouseLeave')
  external static void _mouseLeave(dynamic target, [eventData]);
}

/// Returns whether [props] contains [key] with a value set to a space-delimited string containing [value].
bool _hasTestId(Map props, String key, String value) {
  var testId = props[key];
  return testId != null && splitSpaceDelimitedString(testId.toString()).contains(value);
}

/// Returns the first descendant of [root] that has its [key] test ID prop value set to a space-delimited string
/// containing [value], or null if no matching descendant can be found.
///
/// This method works for:
///
/// * `ReactComponent` (composite component) render trees (output of [render])
/// * [ReactElement] trees (output of [renderShallow]/`Component.render`)
///
/// __Example:__
///
///     var renderedInstance = render(Dom.div()(
///       // Div1
///       (Dom.div()..addTestId('first'))(),
///
///       Dom.div()(
///         // Div2
///         (Dom.div()
///           ..addTestId('second')
///           ..addTestId('other-id')
///         )(),
///       ),
///     ));
///
///     var first  = getByTestId(renderedInstance, 'first');    // Returns the `Div1` element
///     var second = getByTestId(renderedInstance, 'second');   // Returns the `Div2` element
///     var other  = getByTestId(renderedInstance, 'other-id'); // Returns the `Div2` element
///     var nonexistent = getByTestId(renderedInstance, 'nonexistent'); // Returns `null`
///
/// It is recommended that, instead of setting this [key] prop manually, you should use the
/// [UiProps.addTestId] method so the prop is only set in a test environment.
/* [1] */ getByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  final results = getAllByTestId(root, value, key: key);
  return results.isEmpty ? null : results.first;
}

/// Returns all descendants of [root] with a [key] test ID prop value set to a
/// space-delimited string containing [value].
///
/// This is similar to [getByTestId], which returns only the first matching descendant.
///
/// > __Note: when using with components that forward props (like test IDs), this will return both the__
/// > __Dart components and the components they renders, since they will both have the same test ID.__
/// >
/// > If you want to get only Dart components, use [getAllComponentsByTestId].
///
/// This method works for:
///
/// * `ReactComponent` render trees (output of [render])
/// * [ReactElement] trees (output of [renderShallow]/`Component.render`)
///
/// __Example:__
///
///     var renderedInstance = render(Dom.div()(
///       // Div1
///       (Dom.div()
///         ..addTestId('first')
///         ..addTestId('shared-id')
///       )(),
///
///       Dom.div()(
///         // Div2
///         (Dom.div()
///           ..addTestId('second')
///           ..addTestId('other-id')
///           ..addTestId('shared-id')
///         )(),
///       ),
///     ));
///
///     var allFirsts  = getAllByTestId(renderedInstance, 'first');    // Returns `[Div1]`
///     var allSeconds = getAllByTestId(renderedInstance, 'second');   // Returns `[Div2]`
///     var allOthers  = getAllByTestId(renderedInstance, 'other-id'); // Returns `[Div2]`
///     var allShared  = getAllByTestId(renderedInstance, 'other-id'); // Returns `[Div1, Div2]`
///     var allNonexistents = getAllByTestId(renderedInstance, 'nonexistent'); // Returns `null`
///
/// It is recommended that, instead of setting this [key] prop manually, you should use the
/// [UiProps.addTestId] method so the prop is only set in a test environment.
List /* < [1] > */ getAllByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  if (root is react.Component) root = root.jsThis;

  if (isValidElement(root)) {
    return _getAllByTestIdShallow(root, value, key: key);
  }

  return react_test_utils.findAllInRenderedTree(root, allowInterop((descendant) {
    Map? props;
    if (react_test_utils.isDOMComponent(descendant)) {
      props = findDomNode(descendant)!.attributes;
    } else if (react_test_utils.isCompositeComponent(descendant)) {
      props = getProps(descendant);
    }
    return props != null && _hasTestId(props, key, value);
  }));
}

/// Similar to [getAllByTestId], but filters out results that aren't Dart components.
///
/// This is useful when the Dart component you're targeting forwards props.
///
/// For example, given a usage of a component that forwards its props to the rendered DOM:
///    // Dart Input
///    (ForwardsProps()
///      ..addTestId('foo')
///    )()
///    // HTML output
///    '<div class="forwards-props" data-test-id="foo" />'
///
///    // This returns [
///    //   `Instance of 'JsObject'`, (the JS component)
///    //   `Element:<div class="forwards-props" data-test-id="foo" />`,
///    // ]
///    getAllByTestId(root, 'foo')
///
///    // This returns [ `<Instance of 'ForwardsPropsComponent'>` ]
///    getAllComponentsByTestId(root, 'foo')
List<T> getAllComponentsByTestId<T extends react.Component>(dynamic root, String value, {String key = defaultTestIdKey}) =>
    getAllByTestId(root, value, key: key)
        .map((element) => getDartComponent<T>(element)) // ignore: unnecessary_lambdas
        .whereNotNull()
        .toList();

/// Returns the [Element] of the first descendant of [root] that has its [key] prop value set to [value].
///
/// Returns null if no descendant has its [key] prop value set to [value].
///
/// __Example:__
///
///     // Render method for `Test` `UiFactory`:
///     render() {
///       return (Dom.div()..addTestId('outer'))(
///         (Dom.div()
///           ..addProps(copyUnconsumedProps())
///           ..addTestId('inner')
///         )()
///       );
///     }
///
///     // Within a test:
///     var renderedInstance = render((Test()..addTestId('value'))());
///
///     // Will result in the following DOM:
///     <div data-test-id="outer">
///       <div data-test-id="inner value">
///       </div>
///     </div>
///
///     getComponentRootDomByTestId(renderedInstance, 'value'); // returns the `outer` `<div>`
///
/// Related: [queryByTestId].
Element? getComponentRootDomByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  return findDomNode(getByTestId(root, value, key: key));
}

/// Returns the [Element] of the first descendant of [root] that has its [key] html attribute value set to a
/// space-delimited string containing [value].
///
/// Throws if [root] or `findDomNode(root)` is `null`. [root] is kept nullable for convenience, since the input
/// to this function is often a `dynamic` component instance value.
///
/// Setting [searchInShadowDom] to true will allow the query to search within ShadowRoots that use `mode:"open"`.
/// [shadowDepth] will limit how many layers of ShadowDOM will searched. By default it will search infinitely deep, and this
/// should only be needed if there are a lot of ShadowRoots within ShadowRoots.
///
/// __Example:__
///
///     // Render method for `Test` `UiFactory`:
///     render() {
///       return (Dom.div()..addTestId('outer'))(
///         (Dom.div()
///           ..addProps(copyUnconsumedProps())
///           ..addTestId('inner')
///         )()
///       );
///     }
///
///     // Within a test:
///     var renderedInstance = render((Test()..addTestId('value'))());
///
///     // Will result in the following DOM:
///     <div data-test-id="outer">
///       <div data-test-id="inner value">
///       </div>
///     </div>
///
///     queryByTestId(renderedInstance, 'value'); // returns the `inner` `<div>`
///
/// Related: [queryAllByTestId], [getComponentRootDomByTestId].
Element? queryByTestId(dynamic root, String value, {String key = defaultTestIdKey, bool searchInShadowDom = false, int? shadowDepth}) {
  ArgumentError.checkNotNull(root, 'root');

  final node = findDomNode(root);
  if (node == null) {
    throw ArgumentError('findDomNode(root) must not be null. To use this function, your component must render DOM.');
  }

  var results = _findDeep(node, _makeTestIdSelector(value, key: key), searchInShadowDom: searchInShadowDom, findMany: false, depth: shadowDepth);
  return results.isNotEmpty ? results.first : null;
}

/// Returns all descendant [Element]s of [root] that has their [key] html attribute value set to [value].
///
/// Throws if [root] or `findDomNode(root)` is `null`. [root] is kept nullable for convenience, since the input
/// to this function is often a `dynamic` component instance value.
///
/// Setting [searchInShadowDom] to true will allow the query to search within ShadowRoots that use `mode:"open"`.
/// [shadowDepth] will limit how many layers of ShadowDOM will searched. By default it will search infinitely deep, and this
/// should only be needed if there are a lot of ShadowRoots within ShadowRoots.
///
/// __Example:__
///
///     // Render method for `Test` `UiFactory`:
///     render() {
///       return (Dom.div()..addTestId('outer'))(
///         (Dom.div()
///           ..addProps(copyUnconsumedProps())
///           ..addTestId('inner')
///         )()
///       );
///     }
///
///     // Within a test:
///     var renderedInstance = render(Dom.div()(
///       (Test()..addTestId('value'))(),
///       (Test()..addTestId('value'))()
///     ));
///
///     // Will result in the following DOM:
///     <div data-test-id="outer">
///       <div data-test-id="inner value">
///       </div>
///     </div>
///     <div data-test-id="outer">
///       <div data-test-id="inner value">
///       </div>
///     </div>
///
///     queryAllByTestId(renderedInstance, 'value'); // returns both `inner` `<div>`s
List<Element> queryAllByTestId(dynamic root, String value, {String key = defaultTestIdKey, bool searchInShadowDom = false, int? shadowDepth}) {
  ArgumentError.checkNotNull(root, 'root');

  final node = findDomNode(root);
  if (node == null) {
    throw ArgumentError('findDomNode(root) must not be null. To use this function, your component must render DOM.');
  }

  return _findDeep(node, _makeTestIdSelector(value, key: key), searchInShadowDom: searchInShadowDom, findMany: true, depth: shadowDepth);
}

String _makeTestIdSelector(String value, {String key = defaultTestIdKey}) => '[$key~="$value"]';

List<Element> _findDeep(Node root, String itemSelector, {bool searchInShadowDom = false, bool findMany = true, int? depth}) {
  List<Element> nodes = [];
  void recursiveSeek(Node _root, int _currentDepth) {
    // The LHS type prevents `rootQuerySelectorAll` from returning `_FrozenElementList<JSObject<undefined>>` instead of `<Element>` in DDC
    final List<Element> Function(String) rootQuerySelectorAll;
    if ( _root is ShadowRoot) {
      rootQuerySelectorAll = _root.querySelectorAll;
    } else if (_root is Element) {
      rootQuerySelectorAll =  _root.querySelectorAll;
    } else {
      throw Exception('Unhandled node that is neither a ShadowRoot nor an Element: $_root');
    }
    nodes.addAll(rootQuerySelectorAll(itemSelector));
    if (!findMany && nodes.isNotEmpty) {
      return;
    }
    // This method of finding shadow roots may not be performant, but it's good enough for usage in tests.
    if (searchInShadowDom && (depth == null || _currentDepth < depth)) {
      var foundShadows = rootQuerySelectorAll('*').map((el) => el.shadowRoot).whereNotNull().toList();
      for (var shadowRoot in foundShadows) {
        recursiveSeek(shadowRoot, _currentDepth + 1);
      }
    }
  }
  recursiveSeek(root, 0);
  return nodes;
}

/// Returns the [react.Component] of the first descendant of [root] that has its [key] prop value set to [value].
///
/// Returns null if no descendant has its [key] prop value set to [value].
react.Component? getComponentByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  var instance = getByTestId(root, value, key: key);
  if (instance != null) {
    return getDartComponent(instance);
  }

  return null;
}

/// Returns the props of the first descendant of [root] that has its [key] prop value set to [value].
///
/// Returns null if no descendant has its [key] prop value set to [value].
Map? getPropsByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  var instance = getByTestId(root, value, key: key);
  if (instance != null) {
    return getProps(instance);
  }

  return null;
}

List<ReactElement> _getAllByTestIdShallow(ReactElement root, String value, {String key = defaultTestIdKey}) {
  Iterable flattenChildren(dynamic children) sync* {
    if (children is Iterable) {
      yield* children.expand(flattenChildren);
    } else {
      yield children;
    }
  }

  final matchingDescendants = <ReactElement>[];

  var breadthFirstDescendants = Queue()..add(root);
  while (breadthFirstDescendants.isNotEmpty) {
    var descendant = breadthFirstDescendants.removeFirst();
    if (!isValidElement(descendant)) {
      continue;
    }

    var props = getProps(descendant);
    if (_hasTestId(props, key, value)) {
      matchingDescendants.add(descendant);
    }

    breadthFirstDescendants.addAll(flattenChildren(props['children']));
  }

  return matchingDescendants;
}

/// Returns all descendants of a component that contain the specified prop key.
List findDescendantsWithProp(/* [1] */ root, dynamic propKey) {
  List descendantsWithProp = react_test_utils.findAllInRenderedTree(root, allowInterop((descendant) {
    if (descendant == root) {
      return false;
    }

    Map? props;
    if (react_test_utils.isDOMComponent(descendant)) {
      props = findDomNode(descendant)!.attributes;
    } else if (react_test_utils.isCompositeComponent(descendant)) {
      props = getProps(descendant);
    }

    return props != null && props.containsKey(propKey);
  }));

  return descendantsWithProp;
}
