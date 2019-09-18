import 'dart:html';
import 'dart:js';

import 'package:matcher/matcher.dart';
import 'package:meta/meta.dart';
import 'package:over_react/component_base.dart';
import 'package:over_react_test/jacket.dart';
import 'package:react/react_client/react_interop.dart' show PropTypes, ReactElement;
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
    originalConsoleError.apply([message, arg1, arg2, arg3,  arg4, arg5], thisArg: self);
  });

  var componentFactory = _getComponentFactory(componentProps, childProps);

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

  addTearDown(() => context['console']['error'] = originalConsoleError);
}

void propTypesRerenderTest({@required UiProps componentWithNoWarnings,
@required UiProps componentWithWarnings, String customErrorMessage,
  componentWithNoWarningsChildren, componentWithWarningsChildren}) {
  TestJacket jacket;
  List<String> consoleErrors;
  JsFunction originalConsoleError;

  setUp(() {
    PropTypes.resetWarningCache();

    consoleErrors = [];
    originalConsoleError = context['console']['error'];
    context['console']['error'] = new JsFunction.withThis((self, [message, arg1, arg2, arg3,  arg4, arg5]) {
      consoleErrors.add(message);
      originalConsoleError.apply([message, arg1, arg2, arg3,  arg4, arg5], thisArg: self);
    });
  });

  tearDown(() {
    consoleErrors = [];
    PropTypes.resetWarningCache();
    context['console']['error'] = originalConsoleError;
  });

  test('expects no warnings on mount', () {
    var goodComponent = _getComponentFactory(componentWithNoWarnings,
        componentWithNoWarningsChildren);
    jacket = mount(goodComponent, attachedToDocument: true);

    expect(consoleErrors, isEmpty,
        reason: 'should not have outputted a warning');
  });

  test('expects warnings on re-render', () {
    var badComponent = _getComponentFactory(componentWithWarnings,
        componentWithWarningsChildren);

    jacket.rerender(badComponent);

    expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

    if (customErrorMessage != null) {
      expect(consoleErrors[0].contains(customErrorMessage), isTrue);
    }
  });
}

ReactElement _getComponentFactory(UiProps component, dynamic children) {
  if (children == null) return component();

  dynamic componentFactory = component();

  if (children is List) {
    componentFactory = component(children);
  } else {
    componentFactory = component(children());
  }


  return componentFactory;
}