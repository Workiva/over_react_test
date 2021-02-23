@JS()
library over_react_test.src.testing_library.dom.config.configure;

import 'dart:html';

import 'package:js/js.dart';
import 'package:over_react_test/src/testing_library/dom/config/types.dart';
import 'package:test/test.dart' show TestFailure;

export 'package:over_react_test/src/testing_library/dom/config/types.dart' show JsConfig;

/// Configuration for the react-testing-library.
///
/// > See: <https://testing-library.com/docs/dom-testing-library/api-configuration/>
void configure({
  String testIdAttribute,
  int asyncUtilTimeout,
  bool computedStyleSupportsPseudoElements,
  bool defaultHidden,
  bool showOriginalStackTrace,
  bool throwSuggestions,
  TestFailure getElementError(String message, Element container),
}) {
  return jsConfigure(JsConfig()
        ..testIdAttribute = testIdAttribute
        ..asyncUtilTimeout = asyncUtilTimeout
        ..computedStyleSupportsPseudoElements = computedStyleSupportsPseudoElements
        ..defaultHidden = defaultHidden
        ..showOriginalStackTrace = showOriginalStackTrace
        ..throwSuggestions = throwSuggestions
      // TODO: Wrap this
      //..getElementError = allowInterop(getElementError)
      );
}

@JS('rtl.configure')
external void jsConfigure([JsConfig newConfig]);

/// Returns the configuration options being used by react-testing-library.
///
/// > See: <https://testing-library.com/docs/dom-testing-library/api-configuration/>
@JS('rtl.getConfig')
external JsConfig getConfig();
