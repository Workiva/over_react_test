// @dart = 2.7

/// https://testing-library.com/docs/react-testing-library/api#render
@JS()
library over_react_test.src.testing_library.react.render.render;

import 'dart:html' show DocumentFragment, Element;

import 'package:js/js.dart';
import 'package:over_react/over_react.dart' show ReactElement, UiFactory;
import 'package:over_react_test/src/testing_library/dom/scoped_queries.dart' show ScopedQueries;
import 'package:test/test.dart' show addTearDown;

import 'package:over_react_test/src/testing_library/react/render/types.dart' show JsRenderResult, RenderOptions;

/// Renders the [ui] into the DOM, returning a [RenderResult] API that can be used
/// to do things like [RenderResult.rerender] with different props, or to call
/// a query function scoped within the [container] that was rendered into.
///
/// By default, the [container] will be removed from the DOM and [RenderResult.unmount] will be called
/// along with an optional [autoTearDownCallback] in the `tearDown` of any test that calls this
/// function unless [autoTearDown] is set to false.
///
/// Optionally, you can specify:
///
/// * __[container]__, which will be the mount point of the React tree.
/// This must be a [Element] that exists in the DOM at the time that `render` is called.
/// * __[wrapper]__, which will be wrapped around the [ui] - which is
/// especially useful when testing components that need a context provider of some kind.
///
/// > See: <https://testing-library.com/docs/react-testing-library/api#render>
RenderResult render(
  ReactElement ui, {
  Element container,
  Element baseElement,
  bool hydrate = false,
  // TODO: Implement if CPLAT-13502 is deemed necessary
  // Map<String, Query> queries,
  UiFactory wrapper,
  bool autoTearDown = true,
  Function() autoTearDownCallback,
}) {
  final renderOptions = RenderOptions()..hydrate = hydrate;
  if (container != null) renderOptions.container = container;
  if (baseElement != null) renderOptions.baseElement = baseElement;
  if (wrapper != null) {
    ui = wrapper()(ui);
  }

  final jsResult = _render(ui, renderOptions);

  addTearDown(() {
    if (autoTearDown) {
      jsResult.unmount();
      jsResult.container?.remove();
      autoTearDownCallback?.call();
    }
  });

  return RenderResult._(jsResult, ui);
}

/// The model returned from [render], which includes all the [ScopedQueries] scoped to the
/// container that was rendered within.
///
/// TODO: Document fields / methods
/// TODO: Document how to use the bound queries on the container
class RenderResult extends ScopedQueries {
  RenderResult._(this._jsRenderResult, this._renderedElement) : super(() => _jsRenderResult.container);

  final JsRenderResult _jsRenderResult;

  ReactElement get renderedElement => _renderedElement;
  ReactElement _renderedElement;

  Element get container => _jsRenderResult.container;

  Element get baseElement => _jsRenderResult.baseElement;

  void debug([
    Element baseElement,
    int maxLength,
    // TODO
    /*prettyFormat.OptionsReceived*/ dynamic options,
  ]) =>
      _jsRenderResult.debug(baseElement, maxLength, options);

  void rerender(ReactElement ui) {
    _renderedElement = ui;
    _jsRenderResult.rerender(ui);
  }

  void unmount() => _jsRenderResult.unmount();

  DocumentFragment asFragment() => _jsRenderResult.asFragment();
}

@JS('rtl.render')
external JsRenderResult _render(ReactElement ui, RenderOptions options);
