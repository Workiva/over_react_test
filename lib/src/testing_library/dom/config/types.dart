@JS()
library over_react_test.src.testing_library.dom.config.types;

import 'dart:html' show Element;

import 'package:js/js.dart';

@JS()
@anonymous
class JsConfig {
  external String get testIdAttribute;
  external set testIdAttribute(String value);

  external int get asyncUtilTimeout;
  external set asyncUtilTimeout(int value);

  external bool get computedStyleSupportsPseudoElements;
  external set computedStyleSupportsPseudoElements(bool value);

  external bool get defaultHidden;
  external set defaultHidden(bool value);

  external bool get showOriginalStackTrace;
  external set showOriginalStackTrace(bool value);

  external bool get throwSuggestions;
  external set throwSuggestions(bool value);

  // TODO: How should we interop this to get Dart errors?
  external /*JsError*/ getElementError(String message, Element container);
}
