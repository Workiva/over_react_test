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

@Factory()
UiFactory<TestCommonProps> TestCommon;

@Props()
class TestCommonProps extends UiProps with PropsThatShouldBeForwarded, PropsThatShouldNotBeForwarded {}

@Component(subtypeOf: TestCommonNestedComponent)
class TestCommonComponent extends UiComponent<TestCommonProps> {
  @override
  get consumedProps => const [
    const $Props(TestCommonProps),
    const $Props(PropsThatShouldNotBeForwarded)
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
  Map get props;

  bool foo;
}

@PropsMixin()
abstract class PropsThatShouldNotBeForwarded {
  Map get props;

  bool bar;
}
