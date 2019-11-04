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
import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

// ignore: uri_has_not_been_generated
part 'prop_type_util_test.over_react.g.dart';

main() {
  group('recordConsoleLogs', () {
    test('captures errors correctly', () {
      var logs = recordConsoleLogs(() => mount(
          (Sample()..shouldNeverBeTrue = true)()
      ), errorConfig);

      expect(logs.length, 2);
    });

    test('captures logs correctly', () {
      var logs = recordConsoleLogs(() => mount(Sample()()), logConfig);

      expect(logs.length, 1);
    });

    test('captures warnings correctly', () {
      var logs = recordConsoleLogs(() => mount(Sample()()), warnConfig);

      expect(logs.length, 3);
    });

    test('swallows errors as expected', () {
      var logs = recordConsoleLogs(() => mount(
          (Sample()..shouldError=true)()
      ));

      expect(logs.length, 3);
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

  bool shouldNeverBeTrue;

  bool shouldError;
}

@Component2()
class SampleComponent extends UiComponent2<SampleProps> {
  @override
  Map get defaultProps => (newProps()..shouldError = false);

  @override
  get propTypes => {
    getPropKey((props) => props.foo, typedPropsFactory):
        (props, propName, _, __, ___) {

      if (props.foo == null) {
        return new PropError.required('foo');
      }

      return null;
    },
    getPropKey((props) => props.shouldNeverBeTrue, typedPropsFactory):
        (props, propName, _, __, ___) {

      if (props.shouldNeverBeTrue) {
        return new PropError.value(props.shouldNeverBeTrue, propName);
      }

      return null;
    },
  };

  @override
  void componentDidMount() {
    window.console.warn('Just a lil warning');
  }

  @override
  render() {
    window.console.warn('A second warning');
    if (props.shouldError) {
      throw Error();
    } else {
      window.console.log('Logging a standard log');
      window.console.warn('And a third');
      return Dom.div()();
    }
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class SampleProps extends _$SampleProps with _$SamplePropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForSampleProps;
}
