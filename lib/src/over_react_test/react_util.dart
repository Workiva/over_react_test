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

import 'dart:async';
import 'dart:collection';
import 'dart:html';

import 'package:js/js.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react/component_base.dart' as component_base;
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_client/js_interop_helpers.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

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
    Element container,
    Callback autoTearDownCallback}) {
  var renderedInstance;
  component = component is component_base.UiProps ? component.build() : component;

  // ignore: invalid_use_of_visible_for_testing_member
  currentComponentZone = Zone.current;

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
ReactElement renderShallow(ReactElement instance, {bool autoTearDown = true, Callback autoTearDownCallback}) {
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

  Element containerNode;

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
Element renderAndGetDom(dynamic component, {bool autoTearDown = true, Callback autoTearDownCallback}) {
  return findDomNode(render(component, autoTearDown: autoTearDown, autoTearDownCallback: autoTearDownCallback));
}

/// Renders a React component or builder into a detached node and returns the associtated Dart component.
react.Component renderAndGetComponent(dynamic component,
        {bool autoTearDown = true, Callback autoTearDownCallback}) =>
    getDartComponent(render(component, autoTearDown: autoTearDown, autoTearDownCallback: autoTearDownCallback));

/// List of elements attached to the DOM and used as mount points in previous calls to [renderAttachedToDocument].
List<Element> _attachedReactContainers = [];

/// Renders the component into a node attached to document.body as opposed to a detached node.
///
/// Returns the rendered component.
/* [1] */ renderAttachedToDocument(dynamic component,
    {bool autoTearDown = true,
    Element container,
    Callback autoTearDownCallback}) {
  container ??= DivElement()
    // Set arbitrary height and width for container to ensure nothing is cut off.
    ..style.setProperty('width', '800px')
    ..style.setProperty('height', '800px');

  // ignore: invalid_use_of_visible_for_testing_member
  currentComponentZone = Zone.current;

  document.body.append(container);

  if (autoTearDown) {
    addTearDown(() {
      react_dom.unmountComponentAtNode(container);
      container.remove();
      if (autoTearDownCallback != null) autoTearDownCallback();
    });
  } else {
    _attachedReactContainers.add(container);
  }

  return react_dom.render(component is component_base.UiProps ? component.build() : component, container);
}

/// Unmounts and removes the mount nodes for components rendered via [renderAttachedToDocument] that are not
/// automatically unmounted.
void tearDownAttachedNodes() {
  for (var container in _attachedReactContainers) {
    react_dom.unmountComponentAtNode(container);
    container.remove();
  }
}

typedef void _EventSimulatorAlias(componentOrNode, [Map eventData]);

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
final _EventSimulatorAlias mouseEnter = (componentOrNode, [Map eventData = const {}]) =>
    Simulate._mouseEnter(componentOrNode, jsifyAndAllowInterop(eventData));

/// Helper function to simulate mouseLeave events.
final _EventSimulatorAlias mouseLeave = (componentOrNode, [Map eventData = const {}]) =>
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
/// * `ReactComponent` render trees (output of [render])
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
    Map props;
    if (react_test_utils.isDOMComponent(descendant)) {
      props = findDomNode(descendant).attributes;
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
        .where((component) => component != null)
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
Element getComponentRootDomByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  return findDomNode(getByTestId(root, value, key: key));
}

/// Returns the [Element] of the first descendant of [root] that has its [key] html attribute value set to a
/// space-delimited string containing [value].
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
Element queryByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  return findDomNode(root).querySelector('[$key~="$value"]');
}

/// Returns all descendant [Element]s of [root] that has their [key] html attribute value set to [value].
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
List<Element> queryAllByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  return findDomNode(root).querySelectorAll('[$key~="$value"]');
}

/// Returns the [react.Component] of the first descendant of [root] that has its [key] prop value set to [value].
///
/// Returns null if no descendant has its [key] prop value set to [value].
react.Component getComponentByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
  var instance = getByTestId(root, value, key: key);
  if (instance != null) {
    return getDartComponent(instance);
  }

  return null;
}

/// Returns the props of the first descendant of [root] that has its [key] prop value set to [value].
///
/// Returns null if no descendant has its [key] prop value set to [value].
Map getPropsByTestId(dynamic root, String value, {String key = defaultTestIdKey}) {
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

    Map props;
    if (react_test_utils.isDOMComponent(descendant)) {
      props = findDomNode(descendant).attributes;
    } else if (react_test_utils.isCompositeComponent(descendant)) {
      props = getProps(descendant);
    }

    return props != null && props.containsKey(propKey);
  }));

  return descendantsWithProp;
}
