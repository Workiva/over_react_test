// @dart = 2.7

@JS()
library over_react_test.src.testing_library.react.render.types;

import 'dart:html' show DocumentFragment, Element;

import 'package:js/js.dart';
import 'package:over_react/over_react.dart' show ReactElement;
import 'package:react/react_client/js_backed_map.dart';

import 'package:over_react_test/src/testing_library/react/render/render.dart';

/// A representation of the JS Object that will be returned from the call to `rtl.render`.
///
/// Private. Do not export from this library. Consumers should use [RenderResult].
@JS()
@anonymous
class JsRenderResult {
  external Element get container;
  external set container(Element value);

  external Element get baseElement;
  external set baseElement(Element value);

  external void debug([
    Element baseElement,
    int maxLength,
    // TODO
    /*prettyFormat.OptionsReceived*/ dynamic options,
  ]);

  external void rerender(ReactElement ui);

  external void unmount();

  external DocumentFragment asFragment();
}

/// A representation of the JS Object that will be created by the call to [render]
/// from the individual arguments for that function.
@JS()
@anonymous
class RenderOptions {
  external Element get container;
  external set container(Element value);

  external Element get baseElement;
  external set baseElement(Element value);

  external bool get hydrate;
  external set hydrate(bool value);

  external JsMap get queries;
  external set queries(JsMap value);
}
