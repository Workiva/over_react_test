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

part 'test_common_component.over_react.g.dart';

@Factory()
UiFactory<TestCommonProps> TestCommon =
    _$TestCommon; // ignore: undefined_identifier

@Props()
class _$TestCommonProps extends UiProps with
    PropsThatShouldBeForwarded,
    // ignore: mixin_of_non_class, undefined_class
    $PropsThatShouldBeForwarded,
    PropsThatShouldNotBeForwarded,
    // ignore: mixin_of_non_class, undefined_class
    $PropsThatShouldNotBeForwarded {}

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
  // To ensure the codemod regression checking works properly, please keep this
  // field at the top of the class!
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForPropsThatShouldBeForwarded;

  Map get props;

  bool/*?*/ foo;
}

@PropsMixin()
abstract class PropsThatShouldNotBeForwarded {
  // To ensure the codemod regression checking works properly, please keep this
  // field at the top of the class!
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForPropsThatShouldNotBeForwarded;

  Map get props;

  bool/*?*/ bar;
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class TestCommonProps extends _$TestCommonProps with _$TestCommonPropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForTestCommonProps;
}
