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

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';

// ignore: uri_has_not_been_generated
part 'prop_type_util_test.over_react.g.dart';

/// Main entry point for TestJacket testing
main() {

}

@Factory()
// ignore: undefined_identifier
UiFactory<SampleProps> Sample =
// ignore: undefined_identifier
_$Sample;

@Props()
class _$SampleProps extends UiProps {
  bool foo;
}

@State()
class _$SampleState extends UiState {
  bool bar;
}

@Component2()
class SampleComponent extends UiStatefulComponent2<SampleProps, SampleState> {
  @override
  Map getDefaultProps() => (newProps()..foo = false);

  @override
  Map getInitialState() => (newState()..bar = false);

  @override
  render() {
    return Dom.div()();
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class SampleProps extends _$SampleProps with _$SamplePropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForSampleProps;
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class SampleState extends _$SampleState with _$SampleStateAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const StateMeta meta = _$metaForSampleState;
}
