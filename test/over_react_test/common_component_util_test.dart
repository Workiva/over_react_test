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
import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';

import './utils/test_common_component.dart';
import './utils/test_common_component_required_props.dart';
import './utils/test_common_component_required_props_commponent2.dart';

/// Main entry point for [commonComponentTests] testing
main() {
  group('commonComponentTests', () {
    // TODO: Improve / expand upon these tests.
    group('should pass when the correct unconsumed props are specified', () {
      commonComponentTests(TestCommon, unconsumedPropKeys: [
        PropsThatShouldBeForwarded.meta.keys,
      ]);
    });

    group('should pass when the correct required props are specified', () {
      group('when passed a UiComponent', () {

        commonComponentTests(() => TestCommonRequired()..bar = true,
            shouldTestRequiredProps: true,
            shouldTestClassNameMerging: false,
            shouldTestClassNameOverrides: false,
            shouldTestPropForwarding: false,
        );
      });

    group('when passed a UiComponent2', () {

      commonComponentTests(() => TestCommonRequired2()..bar = true,
          shouldTestRequiredProps: true,
          shouldTestClassNameMerging: false,
          shouldTestClassNameOverrides: false,
          shouldTestPropForwarding: false,
          isComponent2: true,
      );
      });
    });
  });
}
