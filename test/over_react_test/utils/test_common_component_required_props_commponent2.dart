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

part 'test_common_component_required_props_commponent2.over_react.g.dart';

UiFactory<TestCommonRequiredProps2> TestCommonRequired2 =
    _$TestCommonRequired2; // ignore: undefined_identifier

mixin TestCommonRequiredProps2 on UiProps {
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
  get consumedProps =>  [
    propsMeta.forMixin(TestCommonRequiredProps2),
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


