import 'dart:html';

import 'package:over_react/over_react.dart' as over_react;
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' show ReactElement;
import 'package:react/react_dom.dart' as react_dom;

import 'package:ui_test_utils/src/test_util/react_util.dart' as react_util;

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

/// Renders [node], and returns a `TestJacket` instance to use in a test.
///
/// Will render into [mountNode] if provided.
TestJacket<T> mount<T extends react.Component>(ReactElement node, {Element mountNode}) => new TestJacket<T>(node, mountNode: mountNode);

/// Renders [node] attached to the document, and returns a `TestJacket` instance to use in a test.
///
/// Will render into [mountNode] if provided.
TestJacket<T> mountToDocument<T extends react.Component>(ReactElement node, {Element mountNode}) => new TestJacket<T>.attached(node, mountNode: mountNode);

class TestJacket<T extends react.Component> {
  /* [1] */ Object _renderedInstance;
  final Element _mountNode;

  TestJacket(ReactElement node, {Element mountNode}) : this._mountNode = mountNode ?? new DivElement() {
    _render(node);
  }

  TestJacket.attached(ReactElement node, {Element mountNode}) : this._mountNode = mountNode ?? new DivElement() {
    if (document.contains(mountNode)) throw new StateError('');

    document.body.append(_mountNode);
    _render(node);
  }

  void _render(ReactElement node) {
    _renderedInstance = react_dom.render(node, _mountNode);
  }

  void rerender(ReactElement node) {
    _render(node);
  }

  /* [1] */ getInstance() {
    return _renderedInstance;
  }

  Element getNode() {
    return over_react.findDomNode(_renderedInstance);
  }

  T getDartInstance() {
    return over_react.getDartComponent(_renderedInstance) as T;
  }

  void setState(newState, [callback]) {
    getDartInstance().setState(newState, callback);
  }

  void unmount() {
    react_util.unmount(_mountNode);
    _mountNode.remove();
  }
}
