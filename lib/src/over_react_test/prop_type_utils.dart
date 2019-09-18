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
    {@required UiProps componentProps, dynamic childProps, String
    customErrorMessage, Element mountNode, bool willThrow = false, Matcher errorMatcher}) {
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
      componentFactory = componentProps(childProps);
    } else {
      componentFactory = componentProps(childProps());
    }
  }

  if (mountNode != null) {
    expect(() => mount(componentFactory, attachedToDocument: true,
        mountNode: mountNode),
        willThrow ? errorMatcher : returnsNormally);
  } else {
    expect(() => mount(componentFactory, attachedToDocument: true),
        willThrow ? errorMatcher : returnsNormally);
  }

  expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

  if (customErrorMessage != null) {
    expect(consoleErrors[0].contains(customErrorMessage), isTrue);
  }

  context['console']['error'] = originalConsoleError;
}
