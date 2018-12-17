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

import './test_common_component_nested.dart';

// ignore: uri_does_not_exist, uri_has_not_been_generated
part 'test_common_component.over_react.g.dart';

@Factory()
// ignore: undefined_identifier
UiFactory<TestCommonProps> TestCommon = $TestCommon;

@Props()
class _$TestCommonProps extends UiProps with PropsThatShouldBeForwarded, $PropsThatShouldBeForwarded, PropsThatShouldNotBeForwarded, $PropsThatShouldNotBeForwarded {}

@Component(subtypeOf: TestCommonNestedComponent)
class TestCommonComponent extends UiComponent<TestCommonProps> {
  @override
  get consumedProps => const [
    TestCommonProps.meta,
    PropsThatShouldNotBeForwarded.meta
  ];

  @override
  render() {
    return (TestCommonNested()
      ..addProps(copyUnconsumedProps())
      ..className = forwardingClassNameBuilder().toClassName()
    )(props.children);
  }
}

@PropsMixin()
abstract class PropsThatShouldBeForwarded {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = $metaForPropsThatShouldBeForwarded;

  Map get props;

  bool foo;
}

@PropsMixin()
abstract class PropsThatShouldNotBeForwarded {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = $metaForPropsThatShouldNotBeForwarded;

  Map get props;

  bool bar;
}

// AF-#### This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class TestCommonProps extends _$TestCommonProps with _$TestCommonPropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = $metaForTestCommonProps;
}
