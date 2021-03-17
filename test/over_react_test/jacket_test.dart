// @dart = 2.7

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

import 'helper_components/sample_function_component.dart';

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

  group('TestJacket: composite component:', () {
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

  group('TestJacket: DOM component:', () {
    Element mountNode;
    TestJacket jacket;

    setUp(() {
      mountNode = DivElement();
      jacket = mount(Dom.span()(),
        mountNode: mountNode,
        attachedToDocument: true
      );

      expect(mountNode.children.single, isA<SpanElement>());
    });

    tearDown(() {
      mountNode.remove();
      mountNode = null;
    });

    test('rerender', () {
      jacket.rerender((Dom.span()..id = 'foo')());

      expect(mountNode.children.single.id, 'foo');
    });

    test('getProps throws a StateError', () {
      expect(() => jacket.getProps(), throwsStateError);
    });

    test('getNode', () {
      expect(jacket.getNode(), mountNode.children.single);
    });

    test('getDartInstance returns null', () {
      expect(jacket.getDartInstance(), isNull);
    });

    test('setState throws a StateError', () {
      expect(() => jacket.setState({}), throwsStateError);
    });

    test('unmount', () {
      expect(jacket.isMounted, isTrue);

      jacket.unmount();

      expect(jacket.isMounted, isFalse);
    });
  });

  group('TestJacket: function component:', () {
    Element mountNode;
    TestJacket jacket;

    setUp(() {
      mountNode = DivElement();
      jacket = mount(testFunctionComponent({'id': 'foo'}),
        mountNode: mountNode,
        attachedToDocument: true
      );

      expect(mountNode.children.single.id, 'foo');
    });

    tearDown(() {
      mountNode.remove();
      mountNode = null;
    });

    test('rerender', () {
      jacket.rerender(testFunctionComponent({'id': 'bar'}));

      expect(mountNode.children.single.id, 'bar');
    });

    test('getProps throws a StateError', () {
      expect(() => jacket.getProps(), throwsStateError);
    });

    test('getNode throws a StateError', () {
      expect(() => jacket.getNode(), throwsStateError);
    });

    test('getDartInstance throws a StateError', () {
      expect(() => jacket.getDartInstance(), throwsStateError);
    });

    test('setState throws a StateError', () {
      expect(() => jacket.setState({}), throwsStateError);
    });

    test('unmount', () {
      expect(jacket.isMounted, isTrue);

      jacket.unmount();

      expect(jacket.isMounted, isFalse);
    });
  });
}

UiFactory<SampleProps> Sample = castUiFactory(_$Sample); // ignore: undefined_identifier

mixin SampleProps on UiProps {
  bool foo;
}

mixin SampleState on UiState {
  bool bar;
}

class SampleComponent extends UiStatefulComponent2<SampleProps, SampleState> {
  @override
   get defaultProps => (newProps()..foo = false);

  @override
   get initialState => (newState()..bar = false);

  @override
  render() {
    return Dom.div()();
  }
}
