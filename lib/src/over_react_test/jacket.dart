// @dart = 2.12
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

import 'dart:html';

import 'package:over_react/over_react.dart' as over_react;
import 'package:react/react.dart' as react;
import 'package:react/react_client/react_interop.dart' show ReactComponent;
import 'package:react/react_test_utils.dart' as react_test_utils;

import 'package:over_react_test/src/over_react_test/react_util.dart' as react_util;

import './zone_util.dart';

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

/// Renders [reactElement], and returns a `TestJacket` instance to use in a test.
///
/// Will render into [mountNode] if provided.
///
/// To render into a node attached to document.body, as opposed to a detached node, set [attachedToDocument] to true.
///
/// To have the instance not automatically unmounted when the test if over set [autoTearDown] to `false`.
TestJacket<T> mount<T extends react.Component>(over_react.ReactElement reactElement, {
    Element? mountNode,
    bool attachedToDocument = false,
    bool autoTearDown = true
}) {
  return TestJacket<T>._(reactElement,
      mountNode: mountNode,
      attachedToDocument: attachedToDocument,
      autoTearDown: autoTearDown
  );
}

/// Provides more a more consistent and easier to use API to test and manipulate a rendered [ReactComponent].
class TestJacket<T extends react.Component?> {

  TestJacket._(over_react.ReactElement reactElement, {Element? mountNode, this.attachedToDocument = false, this.autoTearDown = true})
      : mountNode = mountNode ?? (DivElement()
    ..style.height = '800px'
    ..style.width = '800px') {
    _render(reactElement);
  }

  /* [1] */ Object? _renderedInstance;
  final Element mountNode;
  final bool attachedToDocument;
  final bool autoTearDown;
  bool _isMounted = false;

  bool get _isCompositeComponent => react_test_utils.isCompositeComponent(_renderedInstance);
  bool get _isDomComponent => react_test_utils.isDOMComponent(_renderedInstance);

  void _render(over_react.ReactElement reactElement) {
    setComponentZone();

    _isMounted = true;
    _renderedInstance = attachedToDocument
        ? react_util.renderAttachedToDocument(reactElement,
            container: mountNode,
            autoTearDown: autoTearDown,
            autoTearDownCallback: unmount)
        : react_util.render(reactElement,
            container: mountNode,
            autoTearDown: autoTearDown,
            autoTearDownCallback: unmount);
  }

  /// Rerenders the [reactElement] into the same [mountNode].
  void rerender(over_react.ReactElement reactElement) {
    _render(reactElement);
  }

  /// Returns the mounted React composite component instance.
  ///
  /// > If you are rendering a function component using [mount], calling [getInstance] will throw a `StateError`.
  /// >
  /// > * If you are trying to access an instance of some other component rendered by the function component, then try either:
  /// >
  /// >     i. Wrapping the component in a class-based wrapper component (such as the `Wrapper` component exported by over_react_test):
  /// >         ```
  /// >         final jacket = mount(Wrapper()(
  /// >           YourFunctionComponent()(),
  /// >         ));
  /// >         ```
  /// >     ii. Using `uiForwardRef` or a ref prop to pass a ref through to the component you need
  /// >
  /// > * If you are trying to access / query for a DOM node rendered by the function component, try using:
  /// >
  /// >   ```
  /// >   queryByTestId(jacket.mountNode, yourTestId)
  /// >   ```
  ReactComponent? getInstance() {
    // [1] Adding an additional check for dom components here because the current behavior when `_renderedInstance` is
    //     a DOM component (Element) - does not throw. The cast to `ReactComponent` - while not "sound", is harmless
    //     since it is an anonymous JS interop class - not a Dart type.
    if (!_isCompositeComponent && /*[1]*/!_isDomComponent) {
      throw StateError(over_react.unindent('''
          getInstance() is only supported when the rendered object is a composite (class based) component.
          
          If you are rendering a function component, and are trying to:
          
          1. Access an instance of some other component rendered by it, then try either:
              i. Wrapping the component in a class-based wrapper component (such as the `Wrapper` component exported by over_react_test):
                  final jacket = mount(Wrapper()(
                    YourFunctionComponent()(),
                  ));
              ii. Using `uiForwardRef` or a ref prop to pass a ref through to the component you need
              
          2. Access / query for a DOM node rendered by the function component, then try using `queryByTestId` with `mountNode`:
              queryByTestId(jacket.mountNode, 'yourTestId')
      '''));
    }

    return _renderedInstance as ReactComponent?;
  }

  /// Returns the props associated with the mounted React composite component instance.
  ///
  /// > If you are rendering a function or DOM component using [mount], calling [getProps] will throw a `StateError`.
  /// >
  /// > See [getInstance] for more information about this limitation.
  Map getProps() {
    if (!_isCompositeComponent) {
      throw StateError(
          'getProps() is only supported when the rendered object is a composite (class based) component.');
    }

    return over_react.getProps(getInstance());
  }

  /// Returns the DOM node associated with the mounted React composite / DOM component instance.
  ///
  /// > If you are rendering a function component using [mount], calling [getNode] will throw a `StateError`.
  /// >
  /// > * Try using [mountNode] if it works for your application.
  /// >
  /// > * Otherwise, try getting the root using one of the following instead:
  /// >
  /// >     ```
  /// >     queryByTestId(jacket.mountNode, yourRootNodeTestId);
  /// >     ```
  /// >
  /// >     ```
  /// >     jacket.mountNode.querySelector(someSelectorThatTargetsTheRootNode);
  /// >     ```
  Element? getNode() {
    if (!_isCompositeComponent && !_isDomComponent) {
      throw StateError(over_react.unindent('''
        getNode() is only supported when the rendered object is a DOM or composite (class based) component.
         
        If you are rendering a function component:
        1. Try using [mountNode] if it works for your application.
        2. Otherwise, try getting the root using one of the following instead:
            jacket.mountNode.querySelector(someSelectorThatTargetsTheRootNode)
            // or
            queryByTestId(jacket.mountNode, yourRootNodeTestId)
      '''));
    }

    return over_react.findDomNode(_renderedInstance);
  }

  /// Returns the native Dart component associated with the mounted React composite component instance,
  /// or null if the component is not Dart based.
  ///
  /// > If you are rendering a function component using [mount], calling [getDartInstance] will throw a `StateError`.
  /// >
  /// > See [getInstance] for more information about this limitation.
  T? getDartInstance() {
    // [1] Adding an additional check for dom components here because the current behavior when `_renderedInstance` is
    //     a DOM component (Element) - is to return `null`. While that will most likely cause null exceptions once the
    //     consumer attempts to make a call on the "Dart instance" they have requested - we don't want this change
    //     to cause new exceptions in a scenario where the consumer was storing a null value and then simply
    //     not using it in their test.
    if (!_isCompositeComponent && /*[1]*/!_isDomComponent) {
      throw StateError(
          'getDartInstance() is only supported when the rendered object is a composite (class based) component.');
    }

    return over_react.getDartComponent(_renderedInstance) as T?;
  }

  /// Returns if the jacket component is mounted or not.
  bool get isMounted => _isMounted;

  /// Update the Dart component's state to the provided [newState] value and force a re-render.
  ///
  /// Optionally accepts a callback that gets called after the component updates.
  ///
  /// Also allows [newState] to be used as a transactional `setState` callback.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#setstate>
  ///
  /// > If you are rendering a function or DOM component using [mount], calling [setState] will throw a `StateError`.
  /// >
  /// > See [getInstance] for more information about this limitation.
  void setState(newState, [callback()?]) {
    if (!_isCompositeComponent) {
      throw StateError(
          'setState() is only supported when the rendered object is a composite (class based) component.');
    }

    getDartInstance()!.setState(newState, callback);
  }

  /// Unmounts the React component instance and cleans up any attached DOM nodes.
  void unmount() {
    _isMounted = false;
    react_util.unmount(_renderedInstance);
    mountNode.remove();
    react_util.tearDownAttachedNodes();
  }
}
