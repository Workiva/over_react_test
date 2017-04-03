import 'dart:html';

import 'package:over_react/over_react.dart' as over_react;
import 'package:over_react/component_base.dart' as component_base;
import 'package:react/react_client.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as react_test_utils;

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

class ReactWrapper<T extends component_base.UiComponent<component_base.UiProps>> {
  /* [1] */ Object _renderedInstance;
  final Element _mountNode;

  ReactWrapper(ReactElement node, {Element attachTo}) : this._mountNode = attachTo {
    _render(node);
  }

  void _render(ReactElement node) {
    if (_mountNode != null) {
      _renderedInstance = react_dom.render(node, _mountNode);
    } else {
      _renderedInstance = react_test_utils.renderIntoDocument(node);
    }
  }

  void rerender(ReactElement node) {
    _render(node);
  }

  /* [1] */ getInstance() {
    return _renderedInstance;
  }

  Element getDomNode() {
    return react_dom.findDOMNode(_renderedInstance);
  }

  T getDartComponent() {
    return over_react.getDartComponent(_renderedInstance) as T;
  }

  void setState(newState, [callback]) {
    getDartComponent().setState(newState, callback);
  }
}
