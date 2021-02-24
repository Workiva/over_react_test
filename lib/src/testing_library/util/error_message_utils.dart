@JS()
library over_react_test.src.testing_library.util.error_message_utils;

import 'dart:html' show Element;

import 'package:js/js.dart' show JS, allowInterop;
import 'package:test/test.dart' show addTearDown;

import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show configure, getConfig;

@JS('buildCustomTestingLibraryElementError')
external /*Error*/ Object buildCustomTestingLibraryElementJsError(Object customMessage, Element container);

/// Builds and configures react-testing-library to use a custom value for `JsConfig.getElementError`
/// if any queries fail in the current test.
///
/// Automatically restores the `JsConfig.getElementError` value that was set before this function was called
/// within the `tearDown` of the current test.
void setEphemeralElementErrorMessage(Object Function(Object originalMessage, Element container) customErrorMessageBuilder) {
  final existingElementErrorFn = getConfig().getElementError;
  configure(getElementError:
      allowInterop((originalMessage, container) => buildCustomTestingLibraryElementJsError(customErrorMessageBuilder(originalMessage, container), container)));

  addTearDown(() {
    configure(getElementError: existingElementErrorFn);
  });
}
