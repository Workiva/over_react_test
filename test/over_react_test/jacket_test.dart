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
    // Helper method to clean up each test.
    void umountJacket(TestJacket jacket) {
      jacket.unmount();
      expect(document.body!.children, isEmpty);
      expect(jacket.isMounted, isFalse);
    }

    group('attached to the document', () {
      group('and unmounts after the test is done', () {
        setUp(() {
          expect(document.body!.children, isEmpty);
        });

        test('with the given container', () {
          var mountNode = DivElement();
          final jacket = mount(Sample()(), attachedToDocument: true, mountNode: mountNode);

          expect(document.body!.children[0], mountNode);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
          umountJacket(jacket);
        });

        test('without the given container', () {
          final jacket = mount(Sample()(), attachedToDocument: true);

          expect(jacket.isMounted, isTrue);
          expect(document.body!.children[0].children[0], jacket.getNode());
          umountJacket(jacket);
        });
      });

      group('and does not unmount after the test is done', () {
        setUp(() {
          expect(document.body!.children, isEmpty);
        });

        test('with the given container', () {
          var mountNode = DivElement();
          final jacket = mount(Sample()(),
              attachedToDocument: true,
              mountNode: mountNode,
              autoTearDown: false
          );

          expect(document.body!.children[0], mountNode);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
          umountJacket(jacket);
        });

        test('without the given container', () {
          final jacket =
              mount(Sample()(), attachedToDocument: true, autoTearDown: false);

          expect(jacket.isMounted, isTrue);
          expect(document.body!.children[0].children[0], jacket.getNode());
          umountJacket(jacket);
        });
      });
    });

    group('not attached to the document', () {
      group('and unmounts after the test is done', () {
        setUp(() {
          expect(document.body!.children, isEmpty);
        });

        test('with the given container', () {
          var mountNode = DivElement();
          final jacket = mount(Sample()(), mountNode: mountNode);

          expect(document.body!.children, isEmpty);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
          umountJacket(jacket);
        });

        test('without the given container', () {
          final jacket = mount(Sample()());

          expect(jacket.isMounted, isTrue);
          umountJacket(jacket);
        });
      });

      group('and does not unmount after the test is done', () {
        setUp(() {
          expect(document.body!.children, isEmpty);
        });

        test('with the given container', () {
          var mountNode = DivElement();
          final jacket = mount(Sample()(), mountNode: mountNode, autoTearDown: false);

          expect(document.body!.children.isEmpty, isTrue);
          expect(jacket.isMounted, isTrue);
          expect(mountNode.children[0], jacket.getNode());
          umountJacket(jacket);
        });

        test('without the given container', () {
          final jacket = mount(Sample()(), autoTearDown: false);

          expect(document.body!.children, isEmpty);
          expect(jacket.isMounted, isTrue);
          umountJacket(jacket);
        });
      });
    });

    test('uses an 800px by 800px mountNode when none is provided', () {
      final jacket = mount(Sample()());
      expect(jacket.mountNode.style.width, '800px');
      expect(jacket.mountNode.style.height, '800px');
    });

    test('does not mutate the styles (including width/height) of the provided mountNode', () {
      final mountNode = DivElement()
        ..style.width = '123px'
        ..style.height = '456px';
      final initialMountNodeCssText = mountNode.style.cssText;

      final jacket = mount(Sample()(), mountNode: mountNode);
      expect(jacket.mountNode, mountNode, reason: 'test setup check');

      expect(mountNode.style.width, '123px');
      expect(mountNode.style.height, '456px');
      expect(mountNode.style.cssText, initialMountNodeCssText);
    });
  });

  group('TestJacket: composite component:', () {
    late TestJacket<SampleComponent> jacket;

    setUp(() {
      var mountNode = DivElement();
      jacket = mount<SampleComponent>((Sample()..addTestId('sample'))(),
          mountNode: mountNode,
          attachedToDocument: true
      );

      expect(Sample(jacket.getProps()).foo, isFalse);
      expect(jacket.getDartInstance()!.state.bar, isFalse);
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
      jacket.setState(jacket.getDartInstance()!.newState()..bar = true);

      expect(jacket.getDartInstance()!.state.bar, isTrue);
    });

    test('unmount', () {
      expect(jacket.isMounted, isTrue);

      jacket.unmount();

      expect(jacket.isMounted, isFalse);
    });
  });

  group('TestJacket: DOM component:', () {
    late Element mountNode;
    late TestJacket jacket;

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
    late Element mountNode;
    late TestJacket jacket;

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
  bool? foo;
}

mixin SampleState on UiState {
  bool? bar;
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
