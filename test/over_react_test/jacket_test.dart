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
part 'jacket_test.over_react.g.dart';

/// Main entry point for TestJacket testing
main() {
  group('mount: renders the given instance', () {
    group('attached to the document', () {
      group('and unmounts after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = DivElement();
          jacket = mount(Sample()(), attachedToDocument: true, mountNode: mountNode);

          expect(document.body.children[0], mountNode);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()(), attachedToDocument: true);

          expect(jacket.isMounted, isTrue);
          expect(document.body.children[0].children[0], jacket.getNode());
        });
      });

      group('and does not unmount after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isNotEmpty);
          expect(jacket.isMounted, isTrue);

          jacket.unmount();

          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = DivElement();
          jacket = mount(Sample()(),
              attachedToDocument: true,
              mountNode: mountNode,
              autoTearDown: false
          );

          expect(document.body.children[0], mountNode);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket =
              mount(Sample()(), attachedToDocument: true, autoTearDown: false);

          expect(jacket.isMounted, isTrue);
          expect(document.body.children[0].children[0], jacket.getNode());
        });
      });
    });

    group('not attached to the document', () {
      group('and unmounts after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = DivElement();
          jacket = mount(Sample()(), mountNode: mountNode);

          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()());

          expect(jacket.isMounted, isTrue);
        });
      });

      group('and does not unmount after the test is done', () {
        TestJacket jacket;

        setUp(() {
          expect(document.body.children, isEmpty);
        });

        tearDown(() {
          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isTrue);

          jacket.unmount();

          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isFalse);

          jacket = null;
        });

        test('with the given container', () {
          var mountNode = DivElement();
          jacket = mount(Sample()(), mountNode: mountNode, autoTearDown: false);

          expect(document.body.children.isEmpty, isTrue);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
        });

        test('without the given container', () {
          jacket = mount(Sample()(), autoTearDown: false);

          expect(document.body.children, isEmpty);
          expect(jacket.isMounted, isTrue);
        });
      });
    });
  });

  group('TestJacket:', () {
    TestJacket<SampleComponent> jacket;

    setUp(() {
      var mountNode = DivElement();
      jacket = mount<SampleComponent>((Sample()..addTestId('sample'))(),
          mountNode: mountNode,
          attachedToDocument: true
      );

      expect(Sample(jacket.getProps()).foo, isFalse);
      expect(jacket.getDartInstance().state.bar, isFalse);
    });

    test('rerender', () {
      jacket.rerender((Sample()..foo = true)());

      expect(Sample(jacket.getProps()).foo, isTrue);
    });

    test('getProps', () {
      expect(jacket.getProps(), getProps(jacket.getInstance()));
    });

    test('getNode', () {
      expect(jacket.getNode(), findDomNode(jacket.getInstance()));
    });

    test('getDartInstance', () {
      expect(jacket.getDartInstance(), getDartComponent(jacket.getInstance()));
    });

    test('setState', () {
      jacket.setState(jacket.getDartInstance().newState()..bar = true);

      expect(jacket.getDartInstance().state.bar, isTrue);
    });

    test('unmount', () {
      expect(jacket.isMounted, isTrue);

      jacket.unmount();

      expect(jacket.isMounted, isFalse);
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
}

@State()
class _$SampleState extends UiState {
  bool bar;
}

@Component()
class SampleComponent extends UiStatefulComponent<SampleProps, SampleState> {
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
