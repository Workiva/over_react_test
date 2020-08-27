// Copyright 2020 Workiva Inc.
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
import 'package:over_react_test/src/over_react_test/wrapper_component.dart';

// ignore: uri_has_not_been_generated
part 'test_common_component_new_boilerplate.over_react.g.dart';

UiFactory<TestCommonForwardingProps> TestCommonForwarding =
    _$TestCommonForwarding; // ignore: undefined_identifier

class TestCommonForwardingProps = UiProps
    with ShouldBeForwardedProps, ShouldNotBeForwardedProps;

class TestCommonForwardingComponent extends UiComponent2<TestCommonForwardingProps> {
  @override
  get defaultProps => (newProps()..propKeysToForwardAnyways = []);

  @override
  get consumedProps => [
        propsMeta.forMixin(ShouldNotBeForwardedProps),
      ];

  @override
  render() {
    return (Wrapper()
      ..modifyProps(addUnconsumedProps)
      ..className = forwardingClassNameBuilder().toClassName()
      ..modifyProps((p) {
        for (var key in props.propKeysToForwardAnyways) {
          p[key] = props[key];
        }
      })
    )(props.children);
  }
}

mixin ShouldBeForwardedProps on UiProps {
  bool foo;
  bool foo2;
}

mixin ShouldNotBeForwardedProps on UiProps {
  bool bar;
  Iterable propKeysToForwardAnyways;
}

UiFactory<TestCommonDomOnlyForwardingProps> TestCommonDomOnlyForwarding =
    _$TestCommonDomOnlyForwarding; // ignore: undefined_identifier

class TestCommonDomOnlyForwardingProps = UiProps
    with ShouldBeForwardedProps, ShouldNotBeForwardedProps;

class TestCommonDomOnlyForwardingComponent extends UiComponent2<TestCommonDomOnlyForwardingProps> {
  @override
  render() {
    return (Dom.div()
      ..modifyProps(addUnconsumedDomProps)
      ..className = forwardingClassNameBuilder().toClassName()
    )(props.children);
  }
}
