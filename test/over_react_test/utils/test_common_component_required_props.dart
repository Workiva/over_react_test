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

part 'test_common_component_required_props.over_react.g.dart';

@Factory()
UiFactory<TestCommonRequiredProps> TestCommonRequired =
    _$TestCommonRequired; // ignore: undefined_identifier

@Props()
class _$TestCommonRequiredProps extends UiProps {
  @nullableRequiredProp
  bool? foobar;

  @requiredProp
  bool? bar;

  @nullableRequiredProp
  bool? defaultFoo;

  late bool lateProp;
}

@Component()
class TestCommonRequiredComponent extends UiComponent<TestCommonRequiredProps> {
  @override
  get consumedProps => const [
    TestCommonRequiredProps.meta,
  ];

  @override
  Map getDefaultProps() {
    return (newProps()..defaultFoo = true);
  }

  @override
  render() {
    return (Dom.div()
      ..addProps(copyUnconsumedDomProps())
      ..className = forwardingClassNameBuilder().toClassName()
    )(props.children);
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class TestCommonRequiredProps extends _$TestCommonRequiredProps with _$TestCommonRequiredPropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForTestCommonRequiredProps;
}
