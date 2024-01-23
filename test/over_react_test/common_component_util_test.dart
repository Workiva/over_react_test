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

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react_test/src/over_react_test/props_meta.dart';
import 'package:over_react_test/src/over_react_test/test_helpers.dart';
import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';

import './utils/test_common_component.dart';
import './utils/test_common_component_new_boilerplate.dart' as new_boilerplate;
import './utils/test_common_component_required_props.dart';
import './utils/test_common_component_required_props_commponent2.dart';

/// Main entry point for [commonComponentTests] testing
main() {
  group('commonComponentTests', () {
    // TODO: Improve / expand upon these tests.
    group('should be a noop and pass when used with a legacy boilerplate component', () {
      commonComponentTests(TestCommon, unconsumedPropKeys: [
        PropsThatShouldBeForwarded.meta.keys,
      ]);
    });

    group('should pass when the correct unconsumed props are specified', () {
      commonComponentTests(
        new_boilerplate.TestCommonForwarding,
        getUnconsumedPropKeys: (meta) => [
          ...meta.forMixin(new_boilerplate.ShouldBeForwardedProps).keys,
        ],
      );
    });

    group('should pass when only dom props are forwarded to a dom element', () {
      commonComponentTests(new_boilerplate.TestCommonDomOnlyForwarding);
    });

    group('should skip checking for certain props', () {
      final meta = getPropsMeta(new_boilerplate.TestCommonForwarding()());
      final consumedKeys = meta!.forMixin(new_boilerplate.ShouldNotBeForwardedProps).keys;
      final skippedKey = consumedKeys.first;

      commonComponentTests(
        () => new_boilerplate.TestCommonForwarding()
          ..propKeysToForwardAnyways = [skippedKey],
        getUnconsumedPropKeys: (meta) => [
          ...meta.forMixin(new_boilerplate.ShouldBeForwardedProps).keys,
        ],
        getSkippedPropKeys: (meta) => [
          skippedKey,
        ],
      );
    });

    group('should pass when the correct required props are specified', () {
      group('when passed a UiComponent', () {
        commonComponentTests(() => (TestCommonRequired()
              ..bar = true
              ..foobar = true),
            shouldTestRequiredProps: true,
            shouldTestClassNameMerging: false,
            shouldTestClassNameOverrides: false,
            shouldTestPropForwarding: false,
        );
      });

      group('when passed a UiComponent2', () {
        commonComponentTests(() => (TestCommonRequired2()
              ..bar = true
              ..foobar = true),
            shouldTestRequiredProps: true,
            shouldTestClassNameMerging: false,
            shouldTestClassNameOverrides: false,
            shouldTestPropForwarding: false,
        );
      });
    });

    // This causes issues when consumers access properties on variables
    // initialized in setUp blocks within `factory`.
    group('does not call `factory` directly within the consuming group', () {
      void sharedTest(
        BuilderOnlyUiFactory factory, {
        List Function(PropsMetaCollection)? getUnconsumedPropKeys,
      }) {
        var wasFactoryCalled = false;

        // These needs to be before declared before commonComponentTests is called,
        // or these tests may fail when they shouldn't.

        // Test both setUpAll/setUp since they have different timings relative
        // to commonComponent test setup blocks.
        //
        // setUp is the important one, but might as well test both while we're
        // here!

        setUpAll(() {
          expect(wasFactoryCalled, isFalse,
              reason: 'factory arg was called within group, '
                  'before consumer setUpAll blocks are called');
        });

        int setUpCallCount = 0;
        setUp(() {
          // Only do this the first time, since it gets called before every
          // test inside commonComponentTests.
          if (setUpCallCount == 0) {
            expect(wasFactoryCalled, isFalse,
                reason: 'factory arg was called within group, '
                    'before consumer setUp blocks are called');
          }
          setUpCallCount++;
        });

        commonComponentTests(() {
          wasFactoryCalled = true;
          return factory();
        }, getUnconsumedPropKeys: getUnconsumedPropKeys);
      }

      group('when passed a UiComponent', () {
        // todo create a new component for this
        sharedTest(() => TestCommonRequired()
          ..bar = true
          ..foobar = true);
      });

      group('when passed a UiComponent2', () {
        group('(old boilerplate)', () {
          // todo create a new component for this
          sharedTest(() => TestCommonRequired2()
            ..bar = true
            ..foobar = true);
        });

        group('(new boilerplate)', () {
          // todo create a new component for this
          sharedTest(new_boilerplate.TestCommonForwarding, getUnconsumedPropKeys: (meta) => [
            ...meta.forMixin(new_boilerplate.ShouldBeForwardedProps).keys,
          ]);
        });
      });
    });

    group('fails when a component', () {
      /// Declares a [group] in which tests declared via [testFunction] are expected to fail
      /// with an error matching [testFailureMatcher].
      @isTestGroup
      void expectedFailGroup(String description, void Function() groupBody, {@required dynamic testFailureMatcher}) {
        group(description, () {
          int totalTestCount = 0;
          late List<TestFailure> testFailureErrors;
          setUpAll(() => testFailureErrors = []);

          void testButReAndIgnoreExceptions(name, testBody) {
            totalTestCount++;
            test(name, () async {
              try {
                await testBody();
              } on TestFailure catch (e) {
                testFailureErrors.add(e);
              } catch(e, st) {
                fail('Unexpected test error: $e\n$st');
              }
            });
          }

          ;

          testFunction = testButReAndIgnoreExceptions;
          groupBody();
          testFunction = test;

          test('(tests fail check)', () {
            expect(testFailureErrors, isNotEmpty, reason: 'Expected at least 1 of $totalTestCount tests to fail');
            expect(
                testFailureErrors,
                everyElement(
                    isA<TestFailure>().having((source) => source.message, 'error message', testFailureMatcher)));
          });
        });
      }

      final testPropsMeta = PropsMetaCollection({
        DummyProps1: createTestPropsMeta(['Foo.prop1', 'Foo.prop2']),
        DummyProps2: createTestPropsMeta(['Bar.prop1', 'Bar.prop2']),
      });

      expectedFailGroup('forwards consumed props -', () {
        final factory = registerHelperComponent(
          propsMeta: testPropsMeta,
          consumedProps: testPropsMeta.all,
          render: (component) => (Wrapper()..addAll(component.props))(),
        );
        commonComponentTests(
          factory,
          shouldTestClassNameMerging: false,
          shouldTestRequiredProps: false,
          shouldTestClassNameOverrides: false,
        );
      }, testFailureMatcher: contains('Unexpected keys on forwarding target'));

      expectedFailGroup('does not forward all of the unconsumed props in propsMeta -', () {
        var factory = registerHelperComponent(
          propsMeta: testPropsMeta,
          consumedProps: [],
          render: (component) => (Wrapper()
            ..addAll(component.props)
            ..remove('Foo.prop1'))(),
        );
        commonComponentTests(
          factory,
          getUnconsumedPropKeys: (meta) => [
            ...meta.forMixin(DummyProps1).keys,
            ...meta.forMixin(DummyProps2).keys,
          ],
          shouldTestClassNameMerging: false,
          shouldTestRequiredProps: false,
          shouldTestClassNameOverrides: false,
        );
      }, testFailureMatcher: contains('UnconsumedProps were not forwarded'));
    });
  });
}

abstract class DummyProps1 {}

abstract class DummyProps2 {}

PropsMeta createTestPropsMeta(List<String> keys) => PropsMeta(
      keys: keys,
      fields: keys.map((k) => PropDescriptor(k)).toList(),
    );

typedef HelperRenderFunction = dynamic Function(CommonHelperComponent component);

const UiFactory<UiProps> arbitraryUiFactory = domProps;

UiFactory<UiProps> registerHelperComponent({
  required HelperRenderFunction render,
  Map? defaultProps,
  Iterable<ConsumedProps>? consumedProps,
  PropsMetaCollection? propsMeta,
}) {
  final factory = registerComponent2(() {
    return CommonHelperComponent(
        defaultPropsValue: defaultProps,
        consumedPropsValue: consumedProps,
        propsMetaValue: propsMeta,
        renderValue: render,
      );
  });

  return ([Map? backingMap]) => arbitraryUiFactory(backingMap)..componentFactory = factory;
}

class CommonHelperComponent extends UiComponent2<UiProps> {
  final Map defaultPropsValue;
  final Iterable<ConsumedProps> consumedPropsValue;
  final PropsMetaCollection propsMetaValue;
  final HelperRenderFunction renderValue;

  CommonHelperComponent({
    required Map? defaultPropsValue,
    required Iterable<ConsumedProps>? consumedPropsValue,
    required PropsMetaCollection? propsMetaValue,
    required this.renderValue,
  }) :
    defaultPropsValue = defaultPropsValue ?? {},
    propsMetaValue = propsMetaValue ?? const PropsMetaCollection({}),
    consumedPropsValue = consumedPropsValue ?? propsMetaValue?.all ?? [];

  @override
  get defaultProps => defaultPropsValue; // ignore: over_react_pseudo_static_lifecycle

  @override
  get consumedProps => consumedPropsValue;

  @override
  get propsMeta => propsMetaValue;

  @override
  render()  => renderValue(this);

  // Implement typically-generated members

  @override
  bool get $isClassGenerated => false;

  @override
  typedPropsFactory(map) => arbitraryUiFactory(map);

  @override
  typedPropsFactoryJs(map) => typedPropsFactory(map);

  late UiProps _cachedTypedProps;

  @override
  UiProps get props => _cachedTypedProps;

  @override
  set props(Map value) {
    _cachedTypedProps = typedPropsFactory(value);
  }
}
