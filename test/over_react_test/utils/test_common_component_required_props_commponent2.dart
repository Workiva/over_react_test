// Copyright 2019 Workiva Inc.
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

// ignore: uri_has_not_been_generated
part 'test_common_component_required_props_commponent2.over_react.g.dart';

@Factory()
UiFactory<TestCommonRequiredProps2> TestCommonRequired2 =
    // ignore: undefined_identifier
    _$TestCommonRequired2;

@Props()
class _$TestCommonRequiredProps2 extends UiProps {
  @nullableRequiredProp
  bool foobar;

  @requiredProp
  bool bar;

  @nullableRequiredProp
  bool defaultFoo;
}

@Component2()
class TestCommonRequiredComponent2 extends
    UiComponent2<TestCommonRequiredProps2> {
  @override
  get consumedProps => const [
    TestCommonRequiredProps2.meta,
  ];

  @override
  Map get defaultProps => (newProps()..defaultFoo = true);

  @override
  render() {
    return (Dom.div()
      ..modifyProps(addUnconsumedDomProps)
      ..className = forwardingClassNameBuilder().toClassName()
    )(props.children);
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class TestCommonRequiredProps2 extends _$TestCommonRequiredProps2 with _$TestCommonRequiredProps2AccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForTestCommonRequiredProps2;
}
