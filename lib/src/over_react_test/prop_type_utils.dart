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
///
/// If a Component's `render()` will throw because it is relying on a prop
/// that was not passed in correctly, that can be caught by setting
/// `willThrow` to true and passing in the expected Error Matcher.
///
/// If there are multiple `propType` checks and you wish to test a
/// combination, pass in multiple expected errors into
/// `customErrorMessageList`. The order of the messages in the List should
/// match the order the component will catch them in (e.i. the order of the
/// checks declared in the component).
void testPropTypesWithUiProps(
    {@required UiProps componentProps,
      dynamic childProps,
      List<String> customErrorMessageList = const [],
      Element mountNode,
      bool willThrow = false,
      Matcher errorMatcher,
    }) {
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
  expect(consoleErrors.length, customErrorMessageList.length);

  if (customErrorMessageList.isNotEmpty) {
    if (customErrorMessageList.length == 1) {
      expect(consoleErrors[0].contains(customErrorMessageList.first), isTrue);
    } else {
      for (var i = 0; i < customErrorMessageList.length; i++) {
        consoleErrors[i].contains(customErrorMessageList[i]);
      }
    }
  }

  addTearDown(() => context['console']['error'] = originalConsoleError);
}

/// A method that can be used to test how a Component's propTypes respond to
/// the component being re-rendered.
///
/// The first component will be initially mounted before the second component
/// is passed as the value for the re-render. This can also test that a
/// component's changing props do not trigger a propType error. Must be
/// wrapped in a testing group.
void propTypesRerenderTest({@required UiProps firstComponent,
@required UiProps secondComponent, String customErrorMessage,
  dynamic firstComponentChildren, dynamic secondComponentChildren, bool
  shouldErrorOnReRender = true}) {
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
    var component = _getComponentFactory(firstComponent,
        firstComponentChildren);
    jacket = mount(component, attachedToDocument: true);

    expect(consoleErrors, isEmpty,
        reason: 'should not have outputted a warning');
  });

  test('expects warnings on re-render', () {
    var component = _getComponentFactory(secondComponent,
        secondComponentChildren);

    jacket.rerender(component);

    if (shouldErrorOnReRender) {

      expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

      if (customErrorMessage != null) {
        expect(consoleErrors[0].contains(customErrorMessage), isTrue);
      }
    } else {
      expect(consoleErrors, isEmpty,
          reason: 'should not have outputted a warning');
    }
  });
}

/// A method that validates a Component will not have a propTypes error after
/// initially mounted.
void validateNoPropTypeErrors({@required UiProps componentProps, dynamic childProps}) {
  PropTypes.resetWarningCache();

  List<String> consoleErrors = [];
  JsFunction originalConsoleError = context['console']['error'];
  context['console']['error'] = new JsFunction.withThis((self, [message, arg1, arg2, arg3,  arg4, arg5]) {
    consoleErrors.add(message);
    originalConsoleError.apply([message, arg1, arg2, arg3,  arg4, arg5], thisArg: self);
  });

  var componentFactory = _getComponentFactory(componentProps, childProps);

  mount(componentFactory, attachedToDocument: true);

  expect(consoleErrors, isEmpty,
      reason: 'should not have outputted a warning');

  addTearDown(() => context['console']['error'] = originalConsoleError);
}

/// A utility method that simply returns the factory of a Component for
/// consumption by propType testing functions.
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