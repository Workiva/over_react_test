import 'dart:html';
import 'dart:js';

import 'package:matcher/matcher.dart';
import 'package:meta/meta.dart';
import 'package:over_react/component_base.dart';
import 'package:over_react_test/jacket.dart';
import 'package:react/react_client/react_interop.dart' show PropTypes;
import 'package:test/test.dart';

/// Tests the prop types of a component by calling the props, adding children if necessary, and checking the console
/// for expected log output.
void testPropTypesWithUiProps(
    {@required UiProps componentProps, dynamic childProps, String customErrorMessage, Element mountNode}) {
  PropTypes.resetWarningCache();

  List<String> consoleErrors = [];
  JsFunction originalConsoleError = context['console']['error'];
  context['console']['error'] = new JsFunction.withThis((self, [message, arg1, arg2, arg3,  arg4, arg5]) {
    consoleErrors.add(message);
    originalConsoleError.apply([message], thisArg: self);
  });

  dynamic componentFactory = componentProps();

  if (childProps != null) {
    if (childProps is List) {
      componentProps(childProps);
    } else {
      componentFactory = componentProps(childProps());
    }
  }

  if (mountNode != null) {
    mount(componentFactory, attachedToDocument: true, mountNode: mountNode);
  } else {
    mount(componentFactory, attachedToDocument: true);
  }

  expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

  if (customErrorMessage != null) {
    expect(consoleErrors[0].contains(customErrorMessage), isTrue);
  }

  context['console']['error'] = originalConsoleError;
}

/// Tests prop typing similar to [testPropTypesWithUiProps], but expects there to be an error when the component mounts.
///
/// An error may be expected if the props being validated by `propTypes` are necessary to render the component. If
/// when using [testPropTypesWithUiProps] you encounter an `Error`, this function can be used to catch it and still
/// check for the prop validation.
void testPropTypesWithError(
    {@required UiProps componentProps, @required Matcher errorMatcher, dynamic childProps, String customErrorMessage}) {
  PropTypes.resetWarningCache();

  List<String> consoleErrors = [];
  JsFunction originalConsoleError = context['console']['error'];
  //js_util.getProperty(window, console)
  context['console']['error'] = new JsFunction.withThis((self, [message, arg1, arg2, arg3,  arg4, arg5]) {
    consoleErrors.add(message);
    originalConsoleError.apply([message], thisArg: self);
  });

  dynamic componentFactory = componentProps();

  if (childProps != null) {
    if (childProps is List) {
      componentProps(childProps);
    } else {
      componentFactory = componentProps(childProps());
    }
  }

  expect(() {
    mount(componentFactory, attachedToDocument: true);
  }, errorMatcher);

  expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

  if (customErrorMessage != null) {
    expect(consoleErrors[0].contains(customErrorMessage), isTrue);
  }

  context['console']['error'] = originalConsoleError;
}
