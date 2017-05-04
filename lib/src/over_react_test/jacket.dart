import 'dart:html';

import 'package:over_react/over_react.dart' as over_react;
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' show ReactElement;
import 'package:react/react_client/react_interop.dart' show ReactComponent;
import 'package:react/react_test_utils.dart' as react_test_utils;

import 'package:over_react_test/src/over_react_test/react_util.dart' as react_util;

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
TestJacket<T> mount<T extends react.Component>(ReactElement reactElement, {
    Element mountNode,
    bool attachedToDocument: false,
    bool autoTearDown: true
}) {
  return new TestJacket<T>._(reactElement,
      mountNode: mountNode,
      attachedToDocument: attachedToDocument,
      autoTearDown: autoTearDown
  );
}

/// Provides more a more consistent and easier to use API to test and manipulate a rendered [ReactComponent].
class TestJacket<T extends react.Component> {
  /* [1] */ Object _renderedInstance;
  final Element mountNode;
  final bool attachedToDocument;
  final bool autoTearDown;

  TestJacket._(ReactElement reactElement, {Element mountNode, this.attachedToDocument: false, this.autoTearDown: true})
      : this.mountNode = mountNode ?? (new DivElement()
          ..style.height = '800px'
          ..style.width= '800px') {
    _render(reactElement);
  }

  void _render(ReactElement reactElement) {
    _renderedInstance = attachedToDocument
        ? react_util.renderAttachedToDocument(reactElement, container: mountNode, autoTearDown: autoTearDown)
        : react_util.render(reactElement, container: mountNode, autoTearDown: autoTearDown);
  }

  /// Rerenders the [reactElement] into the same [mountNode].
  void rerender(ReactElement reactElement) {
    _render(reactElement);
  }

  /// Returns the mounted React component instance.
  ReactComponent getInstance() {
    if (!react_test_utils.isCompositeComponent(_renderedInstance)) {
      throw new UnsupportedError('Not a composite component');
    }

    return _renderedInstance as ReactComponent;
  }

  /// Returns the props associated with the mounted React component instance.
  Map getProps() {
    return over_react.getProps(getInstance());
  }

  /// Returns the DOM node associated with the mounted React component instance.
  Element getNode() {
    return over_react.findDomNode(_renderedInstance);
  }

  /// Returns the native Dart compoentn associated with the mounted React component instance, or null if the component
  /// is not Dart based.
  T getDartInstance() {
    return over_react.getDartComponent(_renderedInstance) as T;
  }

  /// Update the Dart component's state to the provided [newState] value and force a re-render.
  ///
  /// Optionally accepts a callback that gets called after the component updates.
  ///
  /// Also allows [newState] to be used as a transactional `setState` callback.
  ///
  /// See: <https://facebook.github.io/react/docs/react-component.html#setstate>
  void setState(Map newState, [callback()]) {
    getDartInstance().setState(newState, callback);
  }

  /// Unmounts the React component instance and cleans up any attached DOM nodes.
  void unmount() {
    react_util.unmount(_renderedInstance);
    mountNode?.remove();
    react_util.tearDownAttachedNodes();
  }
}
