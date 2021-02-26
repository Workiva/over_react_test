@JS()
library over_react_test.src.testing_library.util.error_message_utils;

import 'dart:developer';
import 'dart:html' show Element, promiseToFuture;

import 'package:js/js.dart' show JS;
import 'package:over_react/over_react.dart';
import 'package:test/test.dart' show addTearDown;

import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show configure, getConfig;

/// Builds and configures react-testing-library to use a custom value for `JsConfig.getElementError`
/// if any queries fail in the current test.
///
/// Automatically restores the `JsConfig.getElementError` value that was set before this function was called
/// within the `tearDown` of the current test.
void setEphemeralElementErrorMessage(
    Object Function(Object originalMessage, Element container) customErrorMessageBuilder) {
  final existingElementErrorFn = getConfig().getElementError;
  buildDartGetElementError(Object originalMessage, Element container) {
    return buildJsGetElementError(customErrorMessageBuilder(originalMessage, container), container);
  }

  configure(getElementError: buildDartGetElementError);

  addTearDown(() {
    configure(getElementError: existingElementErrorFn);
  });
}

/// Catches any potential `JsError`s thrown by JS query function by calling [getJsQueryResult],
/// preserving the stack trace of the error thrown from JS by throwing a [TestingLibraryElementError].
///
/// Optionally, a [errorMessage] can be provided to customize the error message.
T withErrorInterop<T>(T Function() getJsQueryResult, {String errorMessage}) {
  T returnValue;

  try {
    returnValue = getJsQueryResult();
  } catch (e) {
    throw TestingLibraryElementError.fromJs(e, errorMessage: errorMessage);
  }

  return returnValue;
}

// TODO: Do we need to export this for consumers?
class TestingLibraryElementError extends Error {
  TestingLibraryElementError(this.message, [this.jsStackTrace]) : super();

  factory TestingLibraryElementError.fromJs(JsError jsError, {String errorMessage}) {
    final message = errorMessage == null ? jsError.toString() : '$jsError\n\n$errorMessage';
    return TestingLibraryElementError(message, StackTrace.fromString(jsError.stack));
  }

  final String message;
  final StackTrace jsStackTrace;

  @override
  String toString() => message;
}

// TODO: Do we need to export this for consumers?
class TestingLibraryAsyncTimeout extends Error {
  TestingLibraryAsyncTimeout(this.message) : super();

  final String message;

  @override
  String toString() => message;
}

@JS('Error')
class JsError {
  external String get name;
  external set name(String value);

  external String get message;
  external set message(String value);

  external String get stack;
  external set stack(String value);
}

@JS()
external JsError buildTestingLibraryElementError(Object message);

@JS()
external JsError buildJsGetElementError(Object message, Element container);
