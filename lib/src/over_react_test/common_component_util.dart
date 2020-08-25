// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:collection';
import 'dart:html';
import 'dart:js';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react/component_base.dart' as component_base;
import 'package:over_react_test/over_react_test.dart';
import 'package:over_react_test/src/over_react_test/props_meta.dart';
import 'package:over_react_test/src/over_react_test/test_helpers.dart';
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;
import 'package:test/test.dart';

import './custom_matchers.dart';
import './react_util.dart';

/// Run common component tests around default props, prop forwarding, class name merging, and class name overrides.
///
/// Best used within a group() within a component's test suite:
///
///     main() {
///       group('SomeComponent', () {
///         // other tests
///
///         group('common component functionality:', () {
///           commonComponentTests(SomeComponentFactory);
///         });
///       });
///     }
///
/// __Options:__
///
/// > __[shouldTestPropForwarding]__ - whether `testPropForwarding` will be called.
/// >
/// > Optionally, set [ignoreDomProps] to false if you want to test the forwarding of keys found within [DomProps].
///
/// > __[shouldTestRequiredProps]__ - whether [testRequiredProps] will be called. __Note__: All required props must be
/// provided by [factory].
///
/// > __[shouldTestClassNameMerging]__ - whether [testClassNameMerging] will be called.
///
/// > __[shouldTestClassNameOverrides]__ - whether [testClassNameOverrides] will be called.
///
/// > [childrenFactory] returns children to be used when rendering components.
/// >
/// > This is necessary for components that need children to render properly.
///
/// > __[unconsumedPropKeys]__ (or [getUnconsumedPropKeys] for new boilerplate)
/// should be used when a component has props as part of it's definition that ARE forwarded
/// to its children _(ie, a smart component wrapping a primitive and forwarding some props to it)_.
/// >
/// > By default, `testPropForwarding` tests that all consumed props are not forwarded, so you can specify
/// forwarding props in [unconsumedPropKeys] _(which gets flattened into a 1D array of strings)_.
/// >
/// > When the forwarding of certain props is ambiguous (see error message in `testPropForwarding`), you can resolve
/// this by specifying [nonDefaultForwardingTestProps], a map of prop values that aren't the same as the forwarding
/// target's defaults.
/// >
/// > If [nonDefaultForwardingTestProps] can't be used for some reason, you can skip prop forwarding tests altogether
/// for certain props by specifying their keys in [skippedPropKeys] (or [getSkippedPropKeys] for new boilerplate)
/// _(which gets flattened into a 1D array of strings)_.
@isTestGroup
void commonComponentTests(BuilderOnlyUiFactory factory, {
  bool shouldTestPropForwarding = true,
  List unconsumedPropKeys = const [],
  List skippedPropKeys = const [],
  List Function(PropsMetaCollection) getUnconsumedPropKeys,
  List Function(PropsMetaCollection) getSkippedPropKeys,
  Map nonDefaultForwardingTestProps = const {},
  bool shouldTestClassNameMerging = true,
  bool shouldTestClassNameOverrides = true,
  bool ignoreDomProps = true,
  bool shouldTestRequiredProps = true,
  @Deprecated('This flag is not needed as the test will auto detect the version')
  bool isComponent2,
  dynamic childrenFactory()
}) {
  childrenFactory ??= _defaultChildrenFactory;

  if (shouldTestPropForwarding) {
    _testPropForwarding(
      factory,
      childrenFactory,
      unconsumedPropKeys: unconsumedPropKeys,
      skippedPropKeys: skippedPropKeys,
      getUnconsumedPropKeys: getUnconsumedPropKeys,
      getSkippedPropKeys: getSkippedPropKeys,
      ignoreDomProps: ignoreDomProps,
      nonDefaultForwardingTestProps: nonDefaultForwardingTestProps,
    );
  }

  if (shouldTestClassNameMerging) {
    testClassNameMerging(factory, childrenFactory);
  }
  if (shouldTestClassNameOverrides) {
    testClassNameOverrides(factory, childrenFactory);
  }
  if (shouldTestRequiredProps) {
    testRequiredProps(factory, childrenFactory);
  }
}

String getPropKeyNamespaceFromPropKey(String propKey) {
  final indexOfNamespaceSeparator = propKey.indexOf('.');
  if (indexOfNamespaceSeparator == -1) return null;
  return propKey.substring(0, indexOfNamespaceSeparator);
}

Iterable _flatten(Iterable iterable) =>
    iterable.expand((item) => item is Iterable ? _flatten(item) : [item]);

/// Adds a [setUpAll] and [tearDownAll] pair to the current group that verifies that
/// no new elements exist on the test surface after everything is done running.
///
///     main() {
///       group('SomeComponent', () {
///         expectCleanTestSurfaceAtEnd();
///
///         // Additional `group`s and/or `test`s
///       });
///     }
void expectCleanTestSurfaceAtEnd() {
  Set<Element> nodesBefore;

  setUpAll(() {
    nodesBefore = document.body.children.toSet();
  });

  tearDownAll(() {
    Set<Element> nodesAfter = document.body.children.toSet();
    var nodesAdded = nodesAfter.difference(nodesBefore).map((element) => element.outerHtml).toList();

    expect(nodesAdded, isEmpty, reason: 'tests should leave the test surface clean.');
  });
}

// ********************************************************
//
//  Individual Test Suites
//
//  Called by `commonComponentTests`
//
// ********************************************************

/// Common test for verifying that unconsumed props are forwarded as expected.
///
/// > Typically not consumed standalone. Use [commonComponentTests] instead.
///
/// todo make this public again if there's a need to expose it, once the API has stabilized
@isTest
void _testPropForwarding(BuilderOnlyUiFactory factory, dynamic childrenFactory(), {
  @required List unconsumedPropKeys,
  @required List skippedPropKeys,
  @required List Function(PropsMetaCollection) getUnconsumedPropKeys,
  @required List Function(PropsMetaCollection) getSkippedPropKeys,
  @required bool ignoreDomProps,
  @required Map nonDefaultForwardingTestProps,
}) {
  testFunction('forwards unconsumed props as expected', () {
    // This needs to be retrieved inside a `test`/`setUp`/etc, not inside a group,
    // in case childrenFactory relies on variables set up in the consumer's setUp blocks.
    final meta = getPropsMeta((factory())(childrenFactory()));

    // We can't test this component if it doesn't have meta.
    if (meta == null) {
      if (getUnconsumedPropKeys != null || getSkippedPropKeys != null) {
        throw ArgumentError(
            'This component does not correspond to a mixin-based syntax component,'
                ' and thus cannot be used with the function syntax to specify '
                'unconsumedPropKeys/skippedPropKeys');
      }

      return;
    }

    if (getUnconsumedPropKeys != null) {
      unconsumedPropKeys = getUnconsumedPropKeys(meta);
    }
    if (getSkippedPropKeys != null) {
      skippedPropKeys = getSkippedPropKeys(meta);
    }
    unconsumedPropKeys = _flatten(unconsumedPropKeys).toList();
    skippedPropKeys = _flatten(skippedPropKeys).toList();

    const Map extraProps = {
      // Add this so we find the right component(s) with [getForwardingTargets] later.
      forwardedPropBeacon: true,

      'data-true': true,
      'aria-true': true,

      'data-null': null,
      'aria-null': null
    };

    const Map otherProps = {
      'other-true': true,
      'other-null': null
    };

    const String testId = 'testIdThatShouldBeForwarded';

    const String key = 'testKeyThatShouldNotBeForwarded';
    const String ref = 'testRefThatShouldNotBeForwarded';

    /// Get defaults from a ReactElement to account for default props and any props added by the factory.
    Map defaultProps = Map.from(getProps(factory()(childrenFactory())))
      ..remove('children');

    // TODO: Account for alias components.
    final propsThatShouldNotGetForwarded = {
      for (var key in meta.keys) key:  null,
      // Add defaults afterwards so that components don't blow up when they have unexpected null props.
      ...defaultProps,
      ...nonDefaultForwardingTestProps,
    };

    /// The props we expect to be present on the `forwardingTarget`.
    final unconsumedProps = <String, dynamic>{
      for (var key in unconsumedPropKeys) key: defaultProps[key],
    };

    unconsumedPropKeys.forEach(propsThatShouldNotGetForwarded.remove);

    if (ignoreDomProps) {
      // Remove DomProps because they should be forwarded.
      DomPropsMixin.meta.keys.forEach(propsThatShouldNotGetForwarded.remove);
    }

    var shallowRenderer = react_test_utils.createRenderer();

    var instance = (factory()
      ..addProps(unconsumedProps)
      ..addProps(propsThatShouldNotGetForwarded)
      ..addProps(extraProps)
      ..addProps(otherProps)
      ..addTestId(testId)
      ..key = key
      ..ref = ref
    )(childrenFactory());

    shallowRenderer.render(instance);
    var result = shallowRenderer.getRenderOutput();

    var forwardingTargets = getForwardingTargets(result, shallowRendered: true);

    for (var forwardingTarget in forwardingTargets) {
      Map actualProps = getProps(forwardingTarget);

      // If the forwarding target is a DOM element it should not have invalid DOM props forwarded to it.
      if (isDomElement(forwardingTarget)) {
        otherProps.forEach((key, value) {
          expect(actualProps[key], isNot(containsPair(key, value)), reason: unindent('''
            The following mock key/value pair(s) added by this test were found on 
            a DOM component that props were forwarded to:
            
                $key: ${actualProps[key]}
                 
            This means that `addUnconsumedProps` is mistakenly being used 
            instead of `addUnconsumedDomProps` on a DOM component.
          '''));
        });
      } else {
        otherProps.forEach((key, value) {
          expect(actualProps, containsPair(key, value));
        });

        final missingUnconsumedPropKeys = unconsumedProps.keys.where((key) => !actualProps.containsKey(key));
        final mixinNamesOfMissingUnconsumedPropKeys = missingUnconsumedPropKeys.map(getPropKeyNamespaceFromPropKey).where((name) => name != null).toSet();
        expect(mixinNamesOfMissingUnconsumedPropKeys, isEmpty, reason: unindent('''
          UnconsumedProps were not forwarded.
        
          These prop keys were not found within the props of the forwarding target: 
            
              ${missingUnconsumedPropKeys.join(',\n    ')}
          
          But they were expected to be there since they live within one of the prop mixins specified
          in the list returned to `commonComponentTests.getUnconsumedPropKeys()` in your test. 
          
          If these props should be forwarded to the forwarding target rendered by this component, 
          the value of `UiComponent2.consumedProps` must be overridden to exclude those keys:
          
              // Option 1: forward everything
              @override
              get consumedProps => [];
              
              // Option 2: specify the prop mixins that should be consumed:
              @override
              get consumedProps => propsMeta.forMixins({
                SomeOtherPropsMixin,
                // leave out ${mixinNamesOfMissingUnconsumedPropKeys.join(', ')}
              });
              
              // Option 3: specify the prop mixins that should NOT be consumed:
              @override
              get consumedProps => propsMeta.allExceptForMixins({
                ${mixinNamesOfMissingUnconsumedPropKeys.join(',\n      ')}
              });
              
          If these props should NOT be forwarded to the forwarding target rendered by this component, 
          remove these lines from the list returned to `commonComponentTests.getUnconsumedPropKeys()`:
          
              ${mixinNamesOfMissingUnconsumedPropKeys.map((mixin) => 'propsMeta.forMixin($mixin).keys').join(',\n    ')}
        '''));
      }

      // Expect the target to have all forwarded props.
      extraProps.forEach((key, value) {
        expect(actualProps, containsPair(key, value));
      });

      // Check that the added testId is part of the final testId string.
      expect(actualProps[defaultTestIdKey], contains(testId),
          reason: '$defaultTestIdKey was not forwarded or was forwarded and then overridden.');

      var ambiguousProps = {};

      Set propKeysThatShouldNotGetForwarded = propsThatShouldNotGetForwarded.keys.toSet();
      // Don't test any keys specified by skippedPropKeys.
      propKeysThatShouldNotGetForwarded.removeAll(skippedPropKeys);

      Set<String> unexpectedKeys = actualProps.keys.toSet().intersection(propKeysThatShouldNotGetForwarded).cast<String>();

      /// Test for prop keys that both are forwarded and exist on the forwarding target's default props.
      if (isDartComponent(forwardingTarget)) {
        final forwardingTargetType = (forwardingTarget as ReactElement).type as ReactClass;
        Map forwardingTargetDefaults;
        switch (forwardingTargetType.dartComponentVersion) { // ignore: invalid_use_of_protected_member
          case ReactDartComponentVersion.component: // ignore: invalid_use_of_protected_member
            forwardingTargetDefaults = forwardingTargetType.dartDefaultProps; // ignore: deprecated_member_use
            break;
          case ReactDartComponentVersion.component2: // ignore: invalid_use_of_protected_member
            forwardingTargetDefaults = JsBackedMap.backedBy(forwardingTargetType.defaultProps);
            break;
        }

        var commonForwardedAndDefaults = propKeysThatShouldNotGetForwarded
            .intersection(forwardingTargetDefaults.keys.toSet());

        /// Don't count these as unexpected keys in later assertions; we'll verify them within this block.
        unexpectedKeys.removeAll(commonForwardedAndDefaults);

        for (final propKey in commonForwardedAndDefaults) {
          var defaultTargetValue = forwardingTargetDefaults[propKey];
          var potentiallyForwardedValue = propsThatShouldNotGetForwarded[propKey];

          if (defaultTargetValue != potentiallyForwardedValue) {
            /// If the potentially forwarded value and the default are different,
            /// we can tell whether it was forwarded.
            expect(actualProps, isNot(containsPair(propKey, potentiallyForwardedValue)),
                reason: 'The `$propKey` prop was forwarded when it should not have been');
          } else {
            /// ...otherwise, we can't be certain that the value isn't being forwarded.
            ambiguousProps[propKey] = defaultTargetValue;
          }
        }
      }

      final propMixinsThatAreUnconsumed = unexpectedKeys.map(getPropKeyNamespaceFromPropKey).toSet().toList();
      expect(unexpectedKeys, isEmpty, reason: unindent('''
            Unexpected keys on forwarding target.
      
            One or more props from the following prop mixin(s) were found within the props of 
            the forwarding target: 
            
                ${propMixinsThatAreUnconsumed.join(',\n    ')}
            
            But they were not expected to be there since they are not specified
            in the list returned to `commonComponentTests.getUnconsumedPropKeys()` in your test. 
            
            If props from the mixin(s) listed above should be forwarded to the forwarding target rendered 
            by this component, add these to the list returned to `commonComponentTests.getUnconsumedPropKeys()`: 
            
                ${propMixinsThatAreUnconsumed.map((mixin) => 'propsMeta.forMixin($mixin).keys').join(',\n    ')}
            
            If props from the mixin(s) listed above should NOT be forwarded to the forwarding target rendered 
            by this component, the value of `UiComponent2.consumedProps` must be overridden to include those mixin(s):
            
                // Option 1: specify that the prop mixin(s) should be consumed:
                @override
                get consumedProps => propsMeta.forMixins({
                  ${propMixinsThatAreUnconsumed.map((mixin) => '$mixin').join(',\n      ')}
                });
                
                // Option 2: specify the prop mixins that should NOT be consumed:
                @override
                get consumedProps => propsMeta.allExceptForMixins({
                  SomeOtherPropsMixin,
                  // Leave out the mixin(s) in question.
                });
          '''));

      if (ambiguousProps.isNotEmpty) {
        fail(unindent(
            '''
            Encountered ambiguous forwarded props; some unconsumed props coincide with defaults on the forwarding target, and cannot be automatically tested.

            Try either:
              - specifying `nonDefaultForwardingTestProps` as a Map with valid prop values that are different than the following: $ambiguousProps
              - specifying `skippedPropKeys` with the following prop keys and testing their forwarding manually: ${ambiguousProps.keys.toList()}
            '''
        ));
      }
    }
  });
}

/// Common test for verifying that [DomProps.className]s are merged/blacklisted as expected.
///
/// > Typically not consumed standalone. Use [commonComponentTests] instead.
///
/// > Related: [testClassNameOverrides]
@isTestGroup
void testClassNameMerging(BuilderOnlyUiFactory factory, dynamic childrenFactory()) {
  testFunction('merges classes as expected', () {
    var builder = factory()
      ..addProp(forwardedPropBeacon, true)
      ..className = 'custom-class-1 blacklisted-class-1 custom-class-2 blacklisted-class-2'
      ..classNameBlacklist = 'blacklisted-class-1 blacklisted-class-2';

    var renderedInstance = render(builder(childrenFactory()));
    Iterable<Element> forwardingTargetNodes = getForwardingTargets(renderedInstance).map(findDomNode);

    expect(forwardingTargetNodes, everyElement(
        allOf(
            hasClasses('custom-class-1 custom-class-2'),
            excludesClasses('blacklisted-class-1 blacklisted-class-2')
        )
    ));

    unmount(renderedInstance);
  });

  testFunction('adds custom classes to one and only one element', () {
    const customClass = 'custom-class';

    var renderedInstance = render(
        (factory()..className = customClass)(childrenFactory())
    );
    var descendantsWithCustomClass = react_test_utils.scryRenderedDOMComponentsWithClass(renderedInstance, customClass);

    expect(descendantsWithCustomClass, hasLength(1), reason: 'expected a single element with the forwarded custom class');

    unmount(renderedInstance);
  });
}

/// Common test for verifying that [DomProps.className]s added by the component can be
/// blacklisted by the consumer using [DomProps.classNameBlacklist].
///
/// > Typically not consumed standalone. Use [commonComponentTests] instead.
///
/// > Related: [testClassNameMerging]
@isTestGroup
void testClassNameOverrides(BuilderOnlyUiFactory factory, dynamic childrenFactory()) {
  Set<String> classesToOverride;
  var error;

  setUp(() {
    /// Render a component without any overrides to get the classes added by the component.
    var reactInstanceWithoutOverrides = render(
        (factory()
          ..addProp(forwardedPropBeacon, true)
        )(childrenFactory()),
        autoTearDown: false
    );

    // Catch and rethrow getForwardingTargets-related errors so we can use classesToOverride in the test description,
    // but still fail the test if something goes wrong.
    try {
      classesToOverride = getForwardingTargets(reactInstanceWithoutOverrides)
          .map((target) => findDomNode(target).classes)
          .expand((CssClassSet classSet) => classSet)
          .toSet();
    } catch(e) {
      error = e;
    }

    unmount(reactInstanceWithoutOverrides);
  });

  testFunction('can override added class names', () {
    if (error != null) {
      throw error;
    }

    // Override any added classes and verify that they are blacklisted properly.
    var reactInstance = render(
        (factory()
          ..addProp(forwardedPropBeacon, true)
          ..classNameBlacklist = classesToOverride.join(' ')
        )(childrenFactory())
    );

    Iterable<Element> forwardingTargetNodes = getForwardingTargets(reactInstance).map(findDomNode);
    expect(forwardingTargetNodes, everyElement(
        hasExactClasses('')
    ), reason: '$classesToOverride not overridden');
  });
}

/// Common test for verifying that props annotated as a [requiredProp] are validated correctly.
///
/// > Typically not consumed standalone. Use [commonComponentTests] instead.
///
/// __Note__: All required props must be provided by [factory].
@isTestGroup
void testRequiredProps(BuilderOnlyUiFactory factory, dynamic childrenFactory()) {
  bool isComponent2;

  var keyToErrorMessage = {};
  var nullableProps = <String>[];
  var requiredProps = <String>[];

  setUp(() {
    // This can't go in a setUpAll since it would be called before consumer setUps.
    //
    // ignore: invalid_use_of_protected_member
    final version = ReactDartComponentVersion.fromType(
      (factory()(childrenFactory())).type,
    );
    // ignore: invalid_use_of_protected_member
    isComponent2 = version == ReactDartComponentVersion.component2;

    var jacket = mount(factory()(childrenFactory()), autoTearDown: false);
    var consumedProps = (jacket.getDartInstance() as component_base.UiComponent).consumedProps;
    jacket.unmount();

    for (var consumedProp in consumedProps) {
      for (var prop in consumedProp.props) {
        if (prop.isNullable) {
          nullableProps.add(prop.key);
        } else if (prop.isRequired) {
          requiredProps.add(prop.key);
        }

        keyToErrorMessage[prop.key] = prop.errorMessage ?? '';
      }
    }
  });

  testFunction('throws (component1) or logs the correct errors (component2) when the required prop is not set or is null', () {
    void component1RequiredPropsTest(){
      for (var propKey in requiredProps) {
        final reactComponentFactory = factory()
            .componentFactory as ReactDartComponentFactoryProxy; // ignore: avoid_as

        // Props that are defined in the default props map will never not be set.
        if (!reactComponentFactory.defaultProps.containsKey(propKey)) {
          var badRenderer = () =>
              render((factory()
                ..remove(propKey)
              )(childrenFactory()));

          expect(badRenderer,
              throwsPropError_Required(propKey, keyToErrorMessage[propKey]),
              reason: '$propKey is not set');
        }

        var propsToAdd = {propKey: null};
        var badRenderer = () =>
            render((factory()
              ..addAll(propsToAdd)
            )(childrenFactory()));

        expect(badRenderer,
            throwsPropError_Required(propKey, keyToErrorMessage[propKey]),
            reason: '$propKey is set to null');
      }
    }

    void component2RequiredPropsTest() {
      PropTypes.resetWarningCache();

      List<String> consoleErrors = [];
      JsFunction originalConsoleError = context['console']['error'];
      addTearDown(() => context['console']['error'] = originalConsoleError);
      context['console']['error'] = JsFunction.withThis((self, [message, arg1, arg2, arg3,  arg4, arg5]) {
        consoleErrors.add(message);
        originalConsoleError.apply([message, arg1, arg2, arg3,  arg4, arg5],
            thisArg: self);
      });

      final reactComponentFactory = factory().componentFactory as
      ReactDartComponentFactoryProxy2; // ignore: avoid_as

      for (var propKey in requiredProps) {
        if (!reactComponentFactory.defaultProps.containsKey(propKey)) {

          try {
            mount((factory()
              ..remove(propKey)
            )(childrenFactory()));
          } catch (_){}

          expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

          if (keyToErrorMessage[propKey] != '') {
            expect(consoleErrors, [contains(keyToErrorMessage[propKey])],
                reason: '$propKey is not set');
          }

          consoleErrors = [];
          PropTypes.resetWarningCache();
        }

        var propsToAdd = {propKey: null};

        try {
          mount((factory()
            ..addAll(propsToAdd)
          )(childrenFactory()));
        } catch (_) {}

        expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

        if (keyToErrorMessage[propKey] != '') {
          expect(consoleErrors, [contains(keyToErrorMessage[propKey])],
              reason: '$propKey is not set');
        }

        consoleErrors = [];
        PropTypes.resetWarningCache();
      }
    }

    isComponent2 ? component2RequiredPropsTest() : component1RequiredPropsTest();
  });

  testFunction('nullable props', () {
    if (!isComponent2) {
      for (var propKey in nullableProps) {
        final reactComponentFactory = factory().componentFactory as
          ReactDartComponentFactoryProxy; // ignore: avoid_as
        // Props that are defined in the default props map will never not be set.
        if (!reactComponentFactory.defaultProps.containsKey(propKey)) {
          var badRenderer = () => render((factory()..remove(propKey))(childrenFactory()));

          expect(badRenderer, throwsPropError_Required(propKey, keyToErrorMessage[propKey]), reason: 'should throw when the required, nullable prop $propKey is not set');

          var propsToAdd = {propKey: null};
          badRenderer = () => render((factory()
            ..addAll(propsToAdd)
          )(childrenFactory()));

          expect(badRenderer, returnsNormally, reason: 'does not throw when the required, nullable prop $propKey is set to null');
        }
      }
    } else {
      PropTypes.resetWarningCache();

      List<String> consoleErrors = [];
      JsFunction originalConsoleError = context['console']['error'];
      addTearDown(() => context['console']['error'] = originalConsoleError);
      context['console']['error'] = JsFunction.withThis((self, [message, arg1, arg2, arg3,  arg4, arg5]) {
        consoleErrors.add(message);
        originalConsoleError.apply([message, arg1, arg2, arg3,  arg4, arg5],
            thisArg: self);
      });

      final reactComponentFactory = factory().componentFactory as
          ReactDartComponentFactoryProxy2; // ignore: avoid_as

      for (var propKey in nullableProps) {
        // Props that are defined in the default props map will never not be set.
        if (!reactComponentFactory.defaultProps.containsKey(propKey)) {
          try {
            mount((factory()
              ..remove(propKey)
            )(childrenFactory()));
          } catch(_) {}
          expect(consoleErrors, isNotEmpty, reason: 'should have outputted a warning');

          if (keyToErrorMessage[propKey] != '') {
            expect(consoleErrors, [contains(keyToErrorMessage[propKey])], reason: '$propKey is not set');
          }

          consoleErrors = [];
          PropTypes.resetWarningCache();
        }

        var propsToAdd = {propKey: null};

        try {
          mount((factory()
            ..addAll(propsToAdd)
          )(childrenFactory()));
        } catch (_) {}

        expect(consoleErrors, isEmpty, reason: 'should not have output a warning');

        consoleErrors = [];
        PropTypes.resetWarningCache();
      }
    }
  });
}

// ********************************************************
//
//  Shared Utils / Constants
//
// ********************************************************

/// Return the components to which `props` have been forwarded.
///
/// > Identified using the [forwardedPropBeacon] prop key.
List getForwardingTargets(reactInstance, {int expectedTargetCount = 1, shallowRendered = false}) {
  if (!forwardedPropBeacon.startsWith('data-')) {
    throw Exception('forwardedPropBeacon must begin with "data-" so that is a valid HTML attribute.');
  }

  List forwardingTargets;

  if (shallowRendered) {
    forwardingTargets = [];

    final descendantsToProcess = Queue<dynamic>()..add(reactInstance);
    while (descendantsToProcess.isNotEmpty) {
      final descendant = descendantsToProcess.removeFirst();

      if (descendant is Iterable) {
        descendantsToProcess.addAll(descendant);
        continue;
      }

      // Some props may be of type Function, and will produce interop errors if passed into isValidElement
      if (descendant is! Function && isValidElement(descendant)) {
        final props = getProps(descendant);
        if (props.containsKey(forwardedPropBeacon)) {
          forwardingTargets.add(descendant);
        }

        Iterable<dynamic> propValues;
        try {
          propValues = props.values;
        } catch (_) {
          // IE 11 doesn't support Object.values
          propValues = props.keys.map((key) => props[key]);
        }
        // Most importantly, this includes children, but also includes other props that could contain React content.
        descendantsToProcess.addAll(propValues);
      }
    }
  } else {
    // Filter out non-DOM components (e.g., React.DOM.Button uses composite components to render)
    forwardingTargets = findDescendantsWithProp(reactInstance, forwardedPropBeacon);
    forwardingTargets = forwardingTargets.where(react_test_utils.isDOMComponent).toList();
  }

  if (forwardingTargets.length != expectedTargetCount) {
    throw StateError('Unexpected number of forwarding targets: ${forwardingTargets.length};'
        ' make sure a component with addUnconsumedProps/addUnconsumedDomProps is being rendered.');
  }
  return forwardingTargets;
}

/// Prop key for use in conjunction with [getForwardingTargets].
const String forwardedPropBeacon = 'data-forwarding-target';

/// By default, render components without children.
dynamic _defaultChildrenFactory() => [];
