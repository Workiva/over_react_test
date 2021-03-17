// @dart = 2.7

@JS()
library over_react_test.src.testing_library.dom.config.configure;

import 'dart:html' show Element;

import 'package:js/js.dart' show JS, allowInterop;
import 'package:over_react_test/src/testing_library/dom/config/types.dart' show JsConfig;

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
  /*TestFailure*/ Function(Object message, Element container) getElementError,
}) {
  final existingConfig = getConfig();
  return jsConfigure(JsConfig()
    ..testIdAttribute = testIdAttribute ?? existingConfig.testIdAttribute
    ..asyncUtilTimeout = asyncUtilTimeout ?? existingConfig.asyncUtilTimeout
    ..computedStyleSupportsPseudoElements =
        computedStyleSupportsPseudoElements ?? existingConfig.computedStyleSupportsPseudoElements
    ..defaultHidden = defaultHidden ?? existingConfig.defaultHidden
    ..showOriginalStackTrace = showOriginalStackTrace ?? existingConfig.showOriginalStackTrace
    ..throwSuggestions = throwSuggestions ?? existingConfig.throwSuggestions
    // TODO: Wrap this?
    ..getElementError = getElementError != null ? allowInterop(getElementError) : existingConfig.getElementError);
}

@JS('rtl.configure')
external void jsConfigure([JsConfig newConfig]);

/// Returns the configuration options being used by react-testing-library.
///
/// > See: <https://testing-library.com/docs/dom-testing-library/api-configuration/>
@JS('rtl.getConfig')
external JsConfig getConfig();
