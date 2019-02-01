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

import './test_common_component.dart';
import './test_common_component_nested2.dart';

// ignore: uri_has_not_been_generated
part 'test_common_component_nested.over_react.g.dart';

@Factory()
// ignore: undefined_identifier
UiFactory<TestCommonNestedProps> TestCommonNested = _$TestCommonNested;

@Props()
class _$TestCommonNestedProps extends UiProps with PropsThatShouldBeForwarded {}

@Component()
class TestCommonNestedComponent extends UiComponent<TestCommonNestedProps> {
  @override
  render() {
    return (TestCommonNested2()
      ..addProps(copyUnconsumedProps())
    )(props.children);
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class

