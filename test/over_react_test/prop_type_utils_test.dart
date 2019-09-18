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

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';

// ignore: uri_has_not_been_generated
part 'prop_type_utils_test.over_react.g.dart';

/// Main entry point for prop_type_utils testing
main() {
  group('testPropTypesWithUiProps() should pass (and catch console errors)', () {
      test('when passed invalid props with no children', () {
        var component = (Sample()..foo = null);

        testPropTypesWithUiProps(componentProps: component,
            customErrorMessage: 'foo cannot be null');
      });

      test('when passed incorrect children', () {
        var component = (Sample()..foo = true);
        var children = [(Dom.div()..key = 1)(), Dom.div(Dom.div()..key = 2)()];

        testPropTypesWithUiProps(componentProps: component, childProps: children,
            customErrorMessage: 'There can only be one child');
      });

      test('when there is a re-render', () {
        var jacket = mount(Sample()());
        var component = (Sample()..foo = null);

        testPropTypesWithUiProps(componentProps: component,
            customErrorMessage: 'foo cannot be null', mountNode: jacket.mountNode);
      });

      test('props that cause an error', () {
        var component = (Sample()..shouldThrowOnRender = true);

        testPropTypesWithUiProps(componentProps: component, errorMatcher: throwsA
          (hasToStringValue(contains('Bad state'))),
            customErrorMessage: 'That will break stuff',
            willThrow: true);
      });
  });

  group('propTypesRerenderTest() should pass (and catch console errors)', () {
    group('when passed invalid props with no children', () {
      var goodComponent = (Sample()..foo = true);
      var badComponent = (Sample()..foo = null);

      propTypesRerenderTest(componentWithNoWarnings: goodComponent,
          componentWithWarnings: badComponent,
          customErrorMessage: 'foo cannot be null');
    });

    group('when passed incorrect children', () {
      var goodComponent = (Sample()..foo = true);
      var childrenOfBadComponent = [(Dom.div()..key = 1)(), Dom.div(Dom.div()
        ..key = 2)()];
      var badComponent = (Sample()..foo = null);

      propTypesRerenderTest(componentWithNoWarnings: goodComponent,
          componentWithWarnings: badComponent,
          componentWithWarningsChildren: childrenOfBadComponent,
          customErrorMessage: 'foo cannot be null');
    });
  });
}

@Factory()
// ignore: undefined_identifier
UiFactory<SampleProps> Sample =
// ignore: undefined_identifier
_$Sample;

@Props()
class _$SampleProps extends UiProps {
  bool foo;

  bool shouldThrowOnRender;
}

@State()
class _$SampleState extends UiState {
  bool bar;
}

@Component2()
class SampleComponent extends UiStatefulComponent2<SampleProps, SampleState> {
  @override
  get propTypes => {
    getPropKey((SampleProps props) => props.foo, typedPropsFactory):
        (props, propName, componentName, location, propFullName) {
      if (props.foo == null) {
        return new PropError.value(
            props.foo, 'foo', 'foo cannot be null');
      }

      return null;
    },
    getPropKey((SampleProps props) => props.shouldThrowOnRender, typedPropsFactory):
        (props, propName, componentName, location, propFullName) {
      if (props.shouldThrowOnRender == true) {
        return new PropError.value(
            props.shouldThrowOnRender, 'shouldThrowOnRender', 'That will '
            'break stuff.');
      }

      return null;
    },
    getPropKey((SampleProps props) => props.children, typedPropsFactory):
        (props, propName, componentName, location, propFullName) {
      if (props.children.length > 1) {
        return new PropError.value(
            props.children, 'children', 'There can only be one child.');
      }

      return null;
    },
  };


  @override
  get defaultProps => (newProps()
    ..foo = false
    ..shouldThrowOnRender = false
  );

  @override
  get initialState => (newState()..bar = false);

  @override
  render() {
    if (!props.shouldThrowOnRender) {
      return Dom.div()(props.children);
    } else {
      throw new StateError('Bad state');
    }
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
