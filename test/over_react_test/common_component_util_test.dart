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

import 'package:over_react/over_react.dart';
import 'package:over_react_test/src/over_react_test/props_meta.dart';
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

    group('should skip checking for certain props', () {
      final meta = getPropsMeta(new_boilerplate.TestCommonForwarding()());
      final consumedKeys = meta.forMixin(new_boilerplate.ShouldNotBeForwardedProps).keys;
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
        List Function(PropsMetaCollection) getUnconsumedPropKeys,
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

        setUp(() {
          expect(wasFactoryCalled, isFalse,
              reason: 'factory arg was called within group, '
                  'before consumer setUp blocks are called');
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
  });
}
