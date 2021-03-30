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

import 'dart:developer';
import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react_test/over_react_test.dart';
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_test_utils.dart' as rtu;
import 'package:test/test.dart';

import 'helper_components/sample_function_component.dart';
import 'utils/nested_component.dart';
import 'utils/shadow_nested_component.dart';

part 'react_util_test.over_react.g.dart';

/// Main entry point for ReactUtil testing
main() {
  group('ReactUtil', () {
    group('render behaves as expected when a UiProps instance is provided', () {
      test('(UiComponent)', () {
        final renderedInstance = render(Test());
        expect(Test(getProps(renderedInstance)).children, isEmpty);
      });

      test('(UiComponent2)', () {
        final renderedInstance = render(Test2());
        expect(Test2(getProps(renderedInstance)).children, isEmpty);
      });
    });

    test('renderShallow renders a shallow instance of a component', () {
      var shallowInstance = renderShallow(Test()());
      expect(shallowInstance.type, 'div', reason: 'should be the div ReactElement returned by render()');
      expect(getProps(shallowInstance), containsPair('isRenderResult', true), reason: 'should be the div ReactElement returned by render()');
    });

    group('', () {
      var renderedInstance;

      tearDown(() {
        expect(() => findDomNode(renderedInstance),
            throwsA(anyOf(
                hasToStringValue(contains('unmounted component')),
                hasToStringValue(contains('Invariant Violation'))
            )),
            reason: 'The React instance should have been unmounted.'
        );

        expect(document.body.children, isEmpty, reason: 'All attached mount points should have been removed.');
      });

      test('renderAttachedToDocument renders the component into the document', () {
        expect(document.body.children, isEmpty);

        renderedInstance = renderAttachedToDocument(Wrapper());

        expect(document.body.children[0].children.contains(findDomNode(renderedInstance)), isTrue,
            reason: 'The component should have been rendered into the container div.');
      });

      test('renderAttachedToDocument renders the component into the document with a given container', () {
        expect(document.body.children, isEmpty);

        var container = DivElement();
        renderedInstance = renderAttachedToDocument(Wrapper(), container: container);

        expect(document.body.children[0].children.contains(findDomNode(renderedInstance)), isTrue,
            reason: 'The component should have been rendered into the container div.');
        expect(document.body.children[0], container);
      });
    });


    test('renderAttachedToDocument renders the component into the document and tearDownAttachedNodes cleans them up', () {
      expect(document.body.children, isEmpty);

      var renderedInstance = renderAttachedToDocument(Wrapper(), autoTearDown: false);

      expect(document.body.children[0].children.contains(findDomNode(renderedInstance)), isTrue,
          reason: 'The component should have been rendered into the container div.');

      tearDownAttachedNodes();

      expect(() => findDomNode(renderedInstance),
          throwsA(anyOf(
              hasToStringValue(contains('unmounted component')),
              hasToStringValue(contains('Invariant Violation'))
          )),
          reason: 'The React instance should have been unmounted.'
      );

      expect(document.body.children, isEmpty, reason: 'All attached mount points should have been removed.');
    });

    group('renderAndGetDom', () {
      test('renders and returns the root node of a composite component', () {
        expect(renderAndGetDom(Test()()), isA<Element>());
      });

      test('renders and returns a Dom component node', () {
        expect(renderAndGetDom(Dom.div()()), isA<Element>());
      });

      test('throws a StateError if the provided component is a function component', () {
        expect(() => renderAndGetDom(testFunctionComponent({})), throwsStateError);
      });
    });

    group('renderAndGetComponent', () {
      test('renders and returns a Dart component instance when a composite component is provided', () {
        expect(renderAndGetComponent(Test()()), isA<TestComponent>());
      });

      test('renders and returns null when a DOM component is provided', () {
        expect(renderAndGetComponent(Dom.div()()), isNull);
      });

      test('throws a StateError if the provided component is a function component', () {
        expect(() => renderAndGetComponent(testFunctionComponent({})), throwsStateError);
      });
    });

    group('click', () {
      test('simulates a click on a component', () {
        var flag = false;
        var renderedInstance = render((Dom.div()..onClick = (evt) => flag = true)());

        click(renderedInstance);

        expect(flag, isTrue);
      });

      test('simulates a click on a component with additional event data', () {
        var flag = false;
        SyntheticMouseEvent event;
        var renderedInstance = render((Dom.div()
          ..onClick = (evt) {
            flag = true;
            event = evt;
          }
        )());

        click(renderedInstance, {'shiftKey': true, 'metaKey': true, 'button': 5});

        expect(flag, isTrue);
        expect(event.shiftKey, isTrue);
        expect(event.metaKey, isTrue);
        expect(event.button, equals(5));
      });
    });

    test('change simulates change on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onChange = (evt) => flag = true)());

      change(renderedInstance);

      expect(flag, isTrue);
    });

    test('focus simulates focus on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onFocus = (evt) => flag = true)());

      focus(renderedInstance);

      expect(flag, isTrue);
    });

    test('blur simulates blur on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onBlur = (evt) => flag = true)());

      blur(renderedInstance);

      expect(flag, isTrue);
    });

    test('keyDown simulates a keyDown on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onKeyDown = (evt) => flag = true)());

      keyDown(renderedInstance);

      expect(flag, isTrue);
    });

    test('keyUp simulates a keyDown on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onKeyUp = (evt) => flag = true)());

      keyUp(renderedInstance);

      expect(flag, isTrue);
    });

    test('keyPress simulates a keyPress on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onKeyPress = (evt) => flag = true)());

      keyPress(renderedInstance);

      expect(flag, isTrue);
    });

    test('mouseMove simulates a mouseMove on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onMouseMove = (evt) => flag = true)());

      mouseMove(renderedInstance);

      expect(flag, isTrue);
    });

    test('mouseEnter simulates a mouseEnter on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onMouseEnter = (evt) => flag = true)());

      mouseEnter(renderedInstance);

      expect(flag, isTrue);
    });

    test('mouseLeave simulates a mouseLeave on a component', () {
      var flag = false;
      var renderedInstance = render((Dom.div()..onMouseLeave = (evt) => flag = true)());

      mouseLeave(renderedInstance);

      expect(flag, isTrue);
    });

    test('defaultTestIdKey is equal to the default key used by addTestId', () {
      var renderedInstance = render((Test()
        ..addTestId('testTestId')
      )());
      var props = getProps(renderedInstance);

      expect(props[defaultTestIdKey], equals('testTestId'));
    });

    group('getByTestId returns', () {
      sharedTests({bool shallow}) {
        testSpecificRender(ReactElement instance) =>
            shallow ? renderShallow(instance) : render(instance);

        group('the single descendant that has the appropriate value for the `data-test-id` prop key when it is a', () {
          const String targetFlagProp = 'data-name';

          const Map testProps = {
            'data-test-id': 'value',
            'data-name': 'target',
          };

          test('DOM component', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()..addProps(testProps))()
            ));

            var descendant = getByTestId(renderedInstance, 'value');
            expect(descendant, hasProp(targetFlagProp, 'target'));
          });

          test('Dart component', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Test()..addProps(testProps))()
            ));

            var descendant = getByTestId(renderedInstance, 'value');
            expect(descendant, hasProp(targetFlagProp, 'target'));
          });

          test('JS composite component', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              testJsComponentFactory(testProps)
            ));

            var descendant = getByTestId(renderedInstance, 'value');
            expect(descendant, hasProp(targetFlagProp, 'target'));
          });
        });

        test('the topmost descendant that has the appropriate value for the `data-test-id` prop key', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Dom.div()
              ..addTestId('value')
              ..addProp('data-name', 'First Descendant')
            )(),
            Dom.div()(
              (Dom.div()
                ..addTestId('value')
                ..addProp('data-name', 'Nested Descendant')
              )()
            )
          ));

          var descendant = getByTestId(renderedInstance, 'value');

          expect(descendant, hasProp('data-name', 'First Descendant'));
        });

        test('the topmost descendant that has the appropriate value for the custom prop key', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Dom.div()
              ..addTestId('value')
              ..addProp('data-name', 'First Descendant')
            )(),
            Dom.div()(
              (Dom.div()
                ..addTestId('value', key: 'data-custom-id')
                ..addProp('data-name', 'Nested Descendant')
              )()
            )
          ));

          var descendant = getByTestId(renderedInstance, 'value', key: 'data-custom-id');

          expect(descendant, hasProp('data-name', 'Nested Descendant'));
        });

        test('the topmost descendant that has the `data-test-id` prop set to \'null\' when the user searches for \'null\'', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Dom.div()
              ..addTestId('null')
              ..addProp('data-name', 'First Descendant')
            )(),
            Dom.div()(
              (Dom.div()
                ..addTestId('null')
                ..addProp('data-name', 'Nested Descendant')
              )()
            )
          ));

          var descendant = getByTestId(renderedInstance, 'null');

          expect(descendant, hasProp('data-name', 'First Descendant'));
        });

        group('the topmost descendant that has the appropriate value for the `data-test-id` prop key, an additional testId is added, and then', () {
          test('the first testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1')
                ..addTestId('testId2')
                ..addProp('data-name', 'Nested Descendant')
              )(
                Dom.div()('Nested Descendant 2')
              )
            ));

            var descendant = getByTestId(renderedInstance, 'testId1');
            expect(descendant, hasProp('data-name', 'Nested Descendant'));
          });

          test('the new testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1')
                ..addTestId('testId2')
                ..addProp('data-name', 'Nested Descendant')
              )(
                Dom.div()('Nested Descendant 2')
              )
            ));

            var descendant = getByTestId(renderedInstance, 'testId2');
            expect(descendant, hasProp('data-name', 'Nested Descendant'));
          });
        });

        group('the topmost descendant that has the appropriate value for a custom prop key and', () {
          test('the first testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1', key: 'data-custom-id')
                ..addTestId('testId2', key: 'data-custom-id')
                ..addProp('data-name', 'Nested Descendant')
              )(),
              Dom.div()('Nested Descendant 2')
            ));

            var descendant = getByTestId(renderedInstance, 'testId1', key: 'data-custom-id');
            expect(descendant, hasProp('data-name', 'Nested Descendant'));
          });

          test('the new testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1', key: 'data-custom-id')
                ..addTestId('testId2', key: 'data-custom-id')
                ..addProp('data-name', 'Nested Descendant')
              )(),
              Dom.div()('Nested Descendant 2')
            ));

            var descendant = getByTestId(renderedInstance, 'testId2', key: 'data-custom-id');
            expect(descendant, hasProp('data-name', 'Nested Descendant'));
          });
        });

        test('null if no descendant has the appropriate value for the `data-test-id` prop key', () {
          var renderedInstance = testSpecificRender(Wrapper()());

          var descendant = getByTestId(renderedInstance, 'value');

          expect(descendant, isNull);
        });

        test('null if the user searches for a test ID of \'null\' when no test ID is set', () {
          var renderedInstance = testSpecificRender(Wrapper()());

          var descendant = getByTestId(renderedInstance, 'null');

          expect(descendant, isNull);
        });

        test('null if the user searches for a test ID of `null` when the test ID is set to \'null\'', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Test()..addTestId('null'))()
          ));

          var descendant = getByTestId(renderedInstance, null);

          expect(descendant, isNull);
        });
      }

      group('(rendered component)', () {
        sharedTests(shallow: false);
      });

      group('(shallow-rendered component)', () {
        sharedTests(shallow: true);
      });

      test('returns correctly when passed a react.Component', () {
        var component = renderAndGetComponent(Wrapper()(
          (Test()
            ..addTestId('value')
            ..addProp('data-name', 'target')
          )()
        ));

        var descendant = getByTestId(component, 'value');
        expect(descendant, hasProp('data-name', 'target'));
      });
    });

    group('getAllByTestId returns', () {
      sharedTests({bool shallow}) {
        testSpecificRender(ReactElement instance) =>
            shallow ? renderShallow(instance) : render(instance);

        group('a list containing the single descendant that have the appropriate value for the `data-test-id` prop key when it is a', () {
          const String targetFlagProp = 'data-name';

          const Map testProps = {
            'data-test-id': 'value',
            'data-name': 'target',
          };

          test('DOM component', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()..addProps(testProps))(),
            ));

            var descendants = getAllByTestId(renderedInstance, 'value');
            expect(descendants, [hasProp(targetFlagProp, 'target')]);
          });

          test('Dart component', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Test()..addProps(testProps))(),
            ));

            var descendants = getAllByTestId(renderedInstance, 'value');
            expect(descendants, [hasProp(targetFlagProp, 'target')]);
          });

          test('JS composite component', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              testJsComponentFactory(testProps),
            ));

            var descendants = getAllByTestId(renderedInstance, 'value');
            expect(descendants, [hasProp(targetFlagProp, 'target')]);
          });
        });

        test('all descendants that have the appropriate value for the `data-test-id` prop key', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Dom.div()
              ..addTestId('value')
              ..addProp('data-name', 'First Descendant')
            )(),
            Dom.div()(
              (Dom.div()
                ..addTestId('value')
                ..addProp('data-name', 'Nested Descendant')
              )(),
            ),
          ));

          var descendants = getAllByTestId(renderedInstance, 'value');
          expect(descendants, [
            hasProp('data-name', 'First Descendant'),
            hasProp('data-name', 'Nested Descendant'),
          ]);
        });

        test('all descendants that has the appropriate value for the custom prop key', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Dom.div()
              ..addTestId('value', key: 'data-custom-id')
              ..addProp('data-name', 'First Descendant')
            )(),
            Dom.div()(
              (Dom.div()
                ..addTestId('value', key: 'data-custom-id')
                ..addProp('data-name', 'Nested Descendant')
              )(),
            ),
          ));

          var descendants = getAllByTestId(renderedInstance, 'value', key: 'data-custom-id');
          expect(descendants, [
            hasProp('data-name', 'First Descendant'),
            hasProp('data-name', 'Nested Descendant'),
          ]);
        });

        test('the topmost descendant that has the `data-test-id` prop set to \'null\' when the user searches for \'null\'', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Dom.div()
              ..addTestId('null')
              ..addProp('data-name', 'First Descendant')
            )(),
            Dom.div()(
              (Dom.div()
                ..addTestId('null')
                ..addProp('data-name', 'Nested Descendant')
              )(),
            ),
          ));

          var descendants = getAllByTestId(renderedInstance, 'null');
          expect(descendants, [
            hasProp('data-name', 'First Descendant'),
            hasProp('data-name', 'Nested Descendant'),
          ]);
        });

        group('the topmost descendant that has the appropriate value for the `data-test-id` prop key, an additional testId is added, and then', () {
          test('the first testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1')
                ..addTestId('testId2')
                ..addProp('data-name', 'Nested Descendant')
              )(
                Dom.div()('Nested Descendant 2'),
              ),
            ));

            var descendants = getAllByTestId(renderedInstance, 'testId1');
            expect(descendants, [hasProp('data-name', 'Nested Descendant')]);
          });

          test('the new testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1')
                ..addTestId('testId2')
                ..addProp('data-name', 'Nested Descendant')
              )(
                Dom.div()('Nested Descendant 2'),
              ),
            ));

            var descendants = getAllByTestId(renderedInstance, 'testId2');
            expect(descendants, [hasProp('data-name', 'Nested Descendant')]);
          });
        });

        group('the topmost descendant that has the appropriate value for a custom prop key and', () {
          test('the first testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1', key: 'data-custom-id')
                ..addTestId('testId2', key: 'data-custom-id')
                ..addProp('data-name', 'Nested Descendant')
              )(),
              Dom.div()('Nested Descendant 2'),
            ));

            var descendants = getAllByTestId(renderedInstance, 'testId1', key: 'data-custom-id');
            expect(descendants, [hasProp('data-name', 'Nested Descendant')]);
          });

          test('the new testId is passed in', () {
            var renderedInstance = testSpecificRender(Wrapper()(
              (Dom.div()
                ..addTestId('testId1', key: 'data-custom-id')
                ..addTestId('testId2', key: 'data-custom-id')
                ..addProp('data-name', 'Nested Descendant')
              )(),
              Dom.div()('Nested Descendant 2'),
            ));

            var descendants = getAllByTestId(renderedInstance, 'testId2', key: 'data-custom-id');
            expect(descendants, [hasProp('data-name', 'Nested Descendant')]);
          });
        });

        test('an empty list if no descendant has the appropriate value for the `data-test-id` prop key', () {
          var renderedInstance = testSpecificRender(Wrapper()());

          var descendants = getAllByTestId(renderedInstance, 'value');
          expect(descendants, isEmpty);
        });

        test('an empty list if the user searches for a test ID of \'null\' when no test ID is set', () {
          var renderedInstance = testSpecificRender(Wrapper()());

          var descendants = getAllByTestId(renderedInstance, 'null');
          expect(descendants, isEmpty);
        });

        test('an empty list if the user searches for a test ID of `null` when the test ID is set to \'null\'', () {
          var renderedInstance = testSpecificRender(Wrapper()(
            (Test()..addTestId('null'))(),
          ));

          var descendants = getAllByTestId(renderedInstance, null);
          expect(descendants, isEmpty);
        });

        test('without throwing when text nodes are present in the tree', () {
          var renderedInstance = render(Wrapper()(
            Dom.div()(),
            'I will become a text node',
          ));

          expect(() => getAllByTestId(renderedInstance, 'data-null'), returnsNormally);
        });
      }

      group('(rendered component)', () {
        sharedTests(shallow: false);
      });

      group('(shallow-rendered component)', () {
        sharedTests(shallow: true);
      });

      test('returns correctly when passed a react.Component', () {
        var component = renderAndGetComponent(Wrapper()(
          (Test()
            ..addTestId('value')
            ..addProp('data-name', 'target')
          )(),
        ));

        var descendants = getAllByTestId(component, 'value');
        expect(descendants, [hasProp('data-name', 'target')]);
      });
    });

    group('getAllComponentsByTestId returns only the Dart components with the matching test ID', () {
      void sharedExpectations(
        List<dynamic> allByTestId,
        List<WrapperComponent> allComponentsByTestId,
      ) {
        final isCompositeCOmponentMatcher = predicate(rtu.isCompositeComponent, 'is composite component');

        expect(allByTestId, [
          allOf(hasProp('data-name', 'Wrapper'), isCompositeCOmponentMatcher),
          // The Wrapper should render a div with the same test ID
          allOf(hasProp('data-name', 'Wrapper'), isA<Element>()),
          allOf(hasProp('data-name', 'div'), isA<Element>()),
          allOf(hasProp('data-name', 'js'), isCompositeCOmponentMatcher),
        ], reason: 'test setup sanity check');

        expect(allComponentsByTestId, [
          isA<WrapperComponent>()
        ]);
      }

      test('', () {
        var renderedInstance = render((Wrapper()
          ..addTestId('foo')
          ..addProp('data-name', 'Wrapper')
        )(
          (Dom.div()
            ..addTestId('foo')
            ..addProp('data-name', 'div')
          )(),
          testJsComponentFactory(domProps()
            ..addTestId('foo')
            ..addProp('data-name', 'js')
          ),
        ));

        sharedExpectations(
          getAllByTestId(renderedInstance, 'foo'),
          getAllComponentsByTestId<WrapperComponent>(renderedInstance, 'foo'),
        );
      });

      test('when a custom test ID is provided', () {
        const customTestIdKey = 'data-custom-test-id';

        var renderedInstance = render((Wrapper()
          ..addTestId('foo', key: customTestIdKey)
          ..addProp('data-name', 'Wrapper')
        )(
          (Dom.div()
            ..addTestId('foo', key: customTestIdKey)
            ..addProp('data-name', 'div')
          )(),
          testJsComponentFactory(domProps()
            ..addTestId('foo', key: customTestIdKey)
            ..addProp('data-name', 'js')
          ),
        ));

        sharedExpectations(
          getAllByTestId(renderedInstance, 'foo', key: customTestIdKey),
          getAllComponentsByTestId<WrapperComponent>(renderedInstance, 'foo', key: customTestIdKey),
        );
      });
    });

    group('queryByTestId returns the topmost Element', () {
      group('that has the appropriate value for the', () {
        group('`data-test-id` html attribute key', () {
          test('', () {
            var renderedInstance = render((Nested()..addTestId('value'))());
            var innerNode = findDomNode(renderedInstance).querySelector('[data-test-id~="inner"]');

            expect(queryByTestId(renderedInstance, 'value'), innerNode);
          });

          test('expect when no matching element exists', () {
            var renderedInstance = render(Dom.div()());

            expect(queryByTestId(renderedInstance, 'value'), isNull);
          });
        });

        test('custom html attribute key', () {
          var renderedInstance = render((Nested()..addTestId('value', key: 'data-custom-id'))());
          var innerNode = findDomNode(renderedInstance).querySelector('[data-test-id~="inner"]');

          expect(queryByTestId(renderedInstance, 'value', key: 'data-custom-id'), innerNode);
        });

        test('`data-test-id` html attribute, expect when no matching element exists', () {
          var renderedInstance = render(Dom.div()());

          expect(queryByTestId(renderedInstance, 'value'), isNull);
        });
      });

      group('from within a ShadowRoot when `searchInShadowDom` is `true`', () {
        test('', () async {
          final searchId = 'inner';
          final shadowHostRef = createRef<DivElement>();
          var jacket = mount((ShadowNested()
              ..shadowRootFirstChildTestId = searchId
              ..shadowRootHostRef = shadowHostRef
            )());

          // Let the shadow dom mount (the test components kinda slow since it does it after adding it to the dom.)
          await pumpEventQueue();

          var innerNode = shadowHostRef.current.shadowRoot.querySelector('[data-test-id~="$searchId"]');

          expect(queryByTestId(jacket.mountNode, searchId, searchInShadowDom: true), innerNode);
        });
      });

      group('excluding when within a ShadowRoot when `searchInShadowDom` is `false`', () {
        test('', () async {
          final searchId = 'inner';
          final shadowHostRef = createRef<DivElement>();
          var jacket = mount((ShadowNested()
              ..shadowRootFirstChildTestId = searchId
              ..shadowRootHostRef = shadowHostRef
            )());

          // Let the shadow dom mount (the test components kinda slow since it does it after adding it to the dom.)
          await pumpEventQueue();

          expect(queryByTestId(jacket.mountNode, searchId, searchInShadowDom: false), isNull);
        });
      });

    });

    group('queryAllByTestId returns all Elements', () {
      group('that have the appropriate value for the', () {
        group('`data-test-id` html attribute key', () {
          test('', () {
            var renderedInstance = render(Wrapper()(
              (Nested()..addTestId('value'))(),
              (Nested()..addTestId('value'))(),
            ));
            var innerNodes = findDomNode(renderedInstance).querySelectorAll('[data-test-id~="inner"]');

            expect(queryAllByTestId(renderedInstance, 'value'), innerNodes);
          });

          test('expect when no matching element exists', () {
            var renderedInstance = render(Dom.div()());

            expect(queryAllByTestId(renderedInstance, 'value'), isEmpty);
          });
        });

        test('custom html attribute key', () {
          var renderedInstance = render(Wrapper()(
            (Nested()..addTestId('value'))(),
            (Nested()..addTestId('value'))(),
          ));
          var innerNodes = findDomNode(renderedInstance).querySelectorAll('[data-test-id~="inner"]');

          expect(queryAllByTestId(renderedInstance, 'value'), innerNodes);
        });
      });

      group('from multiple layers within nested ShadowRoots when `searchInShadowDom` is `true`', () {
        test('', () async {
          var shadow1Ref = createRef<DivElement>();
          var shadow2Ref = createRef<DivElement>();
          var shadow3Ref = createRef<DivElement>();
          var jacket = mount(
            (ShadowNested()
              ..shadowRootHostTestId = 'shadow1'
              ..shadowRootHostRef = shadow1Ref
            )(
              (Dom.div()
                ..addTestId('findMe')
                ..className = 'div1'
              )(),
              (ShadowNested()
                ..shadowRootHostTestId = 'shadow2'
                ..shadowRootHostRef = shadow2Ref
              )(
                (Dom.div()
                  ..addTestId('findMe')
                  ..className = 'div2'
                )(),
                (ShadowNested()
                  ..shadowRootHostTestId = 'shadow3'
                  ..shadowRootHostRef = shadow3Ref
                )(
                  (Dom.div()
                    ..addTestId('findMe')
                    ..className = 'div3'
                  )(),
                ),
              ),
            ),
          );

          // Let the shadow dom mount (the test components kinda slow since it does it after adding it to the dom.)
          await pumpEventQueue();

          var level1 = shadow1Ref.current.shadowRoot.querySelector('.div1');
          var level2 = shadow2Ref.current.shadowRoot.querySelector('.div2');
          var level3 = shadow3Ref.current.shadowRoot.querySelector('.div3');

          expect(queryAllByTestId(jacket.mountNode, 'findMe', searchInShadowDom: true), [level1, level2, level3]);
        });

        test('and will stop looking at the `shadowDepth` specified', () async {
          var shadow1Ref = createRef<DivElement>();
          var shadow2Ref = createRef<DivElement>();
          var shadow3Ref = createRef<DivElement>();
          var jacket = mount(
            (ShadowNested()
              ..shadowRootHostRef = shadow1Ref
            )(
              (Dom.div()
                  ..addTestId('findMe')
                  ..className = 'div1'
                )(),
              (ShadowNested()
                ..shadowRootHostRef = shadow2Ref
              )(
                (Dom.div()
                  ..addTestId('findMe')
                  ..className = 'div2'
                )(),
                (ShadowNested()
                  ..shadowRootHostRef = shadow3Ref
                )(
                  (Dom.div()
                    ..addTestId('findMe')
                    ..className = 'div2'
                  )(),
                ),
              ),
            ),
          );

          // Let the shadow dom mount (the test components kinda slow since it does it after adding it to the dom.)
          await pumpEventQueue();

          var level1 = shadow1Ref.current.shadowRoot.querySelector('.div1');

          expect(queryAllByTestId(jacket.mountNode, 'findMe', searchInShadowDom: true, shadowDepth: 1), [level1]);
        });
      });
    });

    group('getComponentByTestId returns', () {
      test('the topmost react.Component that has the appropriate value for the `data-test-id` prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('value'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('value'))('Nested Descendant')
          )
        ));

        var descendant = getComponentByTestId(renderedInstance, 'value');

        expect(descendant, getDartComponent(getByTestId(renderedInstance, 'value')));
      });

      test('the topmost react.Component that has the appropriate value for the custom prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('value'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('value', key: 'data-custom-id'))('Nested Descendant')
          )
        ));

        var descendant = getComponentByTestId(renderedInstance, 'value', key: 'data-custom-id');

        expect(descendant, getDartComponent(getByTestId(renderedInstance, 'value', key: 'data-custom-id')));
      });

      test('the topmost react.Component that has the value \'null\' for the `data-test-id` prop key when the user searches for \'null\'', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('null'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('null'))('Nested Descendant')
          )
        ));

        var descendant = getComponentByTestId(renderedInstance, 'null');

        expect(descendant, getDartComponent(getByTestId(renderedInstance, 'null')));
      });

      group('the topmost react.Component that has the appropriate value for the `data-test-id` prop key, an additional testId is added, and', () {
        test('the first testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1')
            ..addTestId('testId2')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId1');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId1')));
        });

        test('the new testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1')
            ..addTestId('testId2')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId2');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId2')));
        });
      });

      group('the topmost react.Component that has the appropriate value for a custom prop key and', () {
        test('the first testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1', key: 'data-custom-id')
            ..addTestId('testId2', key: 'data-custom-id')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId1', key: 'data-custom-id');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId1', key: 'data-custom-id')));
        });

        test('the first testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1', key: 'data-custom-id')
            ..addTestId('testId2', key: 'data-custom-id')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId2', key: 'data-custom-id');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId2', key: 'data-custom-id')));
        });
      });

      test('null if no descendant has the appropriate value for the `data-test-id` prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('otherValue'))()
        ));

        var descendant = getComponentByTestId(renderedInstance, 'value');

        expect(descendant, isNull);
      });

      test('null if the user searches for \'null\' when no test ID is set', () {
        var renderedInstance = render(Wrapper()(
          Test()()
        ));

        var descendant = getComponentByTestId(renderedInstance, 'null');

        expect(descendant, isNull);
      });

      test('null if the user searches for `null` when a test ID is set to \'null\'', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('null'))()
        ));

        var descendant = getComponentByTestId(renderedInstance, null);

        expect(descendant, isNull);
      });
    });

    group('getComponentByTestId returns', () {
      test('the topmost react.Component that has the appropriate value for the `data-test-id` prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('value'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('value'))('Nested Descendant')
          )
        ));

        var descendant = getComponentByTestId(renderedInstance, 'value');

        expect(descendant, getDartComponent(getByTestId(renderedInstance, 'value')));
      });

      test('the topmost react.Component that has the appropriate value for the custom prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('value'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('value', key: 'data-custom-id'))('Nested Descendant')
          )
        ));

        var descendant = getComponentByTestId(renderedInstance, 'value', key: 'data-custom-id');

        expect(descendant, getDartComponent(getByTestId(renderedInstance, 'value', key: 'data-custom-id')));
      });

      test('the topmost react.Component that has the value \'null\' for the `data-test-id` prop key when the user searches for \'null\'', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('null'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('null'))('Nested Descendant')
          )
        ));

        var descendant = getComponentByTestId(renderedInstance, 'null');

        expect(descendant, getDartComponent(getByTestId(renderedInstance, 'null')));
      });

      group('the topmost react.Component that has the appropriate value for the `data-test-id` prop key, an additional testId is added, and', () {
        test('the first testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1')
            ..addTestId('testId2')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId1');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId1')));
        });

        test('the new testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1')
            ..addTestId('testId2')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId2');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId2')));
        });
      });

      group('the topmost react.Component that has the appropriate value for a custom prop key and', () {
        test('the first testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1', key: 'data-custom-id')
            ..addTestId('testId2', key: 'data-custom-id')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId1', key: 'data-custom-id');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId1', key: 'data-custom-id')));
        });

        test('the first testId is passed in', () {
          var renderedInstance = render((Test()
            ..addTestId('testId1', key: 'data-custom-id')
            ..addTestId('testId2', key: 'data-custom-id')
          )());

          var descendant = getComponentByTestId(renderedInstance, 'testId2', key: 'data-custom-id');
          expect(descendant, getDartComponent(getByTestId(renderedInstance, 'testId2', key: 'data-custom-id')));
        });
      });

      test('null if no descendant has the appropriate value for the `data-test-id` prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('otherValue'))()
        ));

        var descendant = getComponentByTestId(renderedInstance, 'value');

        expect(descendant, isNull);
      });

      test('null if the user searches for \'null\' when no test ID is set', () {
        var renderedInstance = render(Wrapper()(
          Test()()
        ));

        var descendant = getComponentByTestId(renderedInstance, 'null');

        expect(descendant, isNull);
      });

      test('null if the user searches for `null` when a test ID is set to \'null\'', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('null'))()
        ));

        var descendant = getComponentByTestId(renderedInstance, null);

        expect(descendant, isNull);
      });
    });

    group('getPropsByTestId returns', () {
      test('the props map of the topmost descendant that has the appropriate value for the `data-test-id` prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()
            ..id = 'test_id'
            ..addTestId('value')
          )('First Descendant'),
          Dom.div()(
            (Test()..addTestId('value'))('Nested Descendant')
          )
        ));

        var props = getPropsByTestId(renderedInstance, 'value');

        expect(props, equals(getProps(getByTestId(renderedInstance, 'value'))));
      });

      test('the props map of the topmost descendant that has the appropriate value for the custom prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('value'))('First Descendant'),
          Dom.div()(
            (Test()
              ..id = 'test_id'
              ..addTestId('value', key: 'data-custom-id')
            )('Nested Descendant')
          )
        ));

        var props = getPropsByTestId(renderedInstance, 'value', key: 'data-custom-id');

        expect(props, equals(getProps(getByTestId(renderedInstance, 'value', key: 'data-custom-id'))));
      });

      test('the props map of the topmost descendant that has the value \'null\' for the `data-test-id` prop key when the user searches for \'null\'', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('null'))('First Descendant'),
          Dom.div()(
            (Test()..addTestId('null'))('Nested Descendant')
          )
        ));

        var props = getPropsByTestId(renderedInstance, 'null');

        expect(props, equals(getProps(getByTestId(renderedInstance, 'null'))));
      });

      group('the props map of the topmost descendant that has the appropriate value for the `data-test-id` prop key, an additional testId is added, and', () {
        test('the first testId is passed in', () {
          var renderedInstance = ((Test()
            ..addTestId('testId1')
            ..addTestId('testId2')
          )());

          var props = getPropsByTestId(renderedInstance, 'testId1');
          expect(props, equals(getProps(getByTestId(renderedInstance, 'testId1'))));
        });

        test('the new testId is passed in', () {
          var renderedInstance = ((Test()
            ..addTestId('testId1')
            ..addTestId('testId2')
          )());

          var props = getPropsByTestId(renderedInstance, 'testId2');
          expect(props, equals(getProps(getByTestId(renderedInstance, 'testId2'))));
        });
      });

      group('the props map of the topmost descendant that has the appropriate value for a custom prop key and', () {
        test('the first testId is passed in', () {
          var renderedInstance = ((Test()
            ..addTestId('testId1', key: 'data-custom-id')
            ..addTestId('testId2', key: 'data-custom-id')
          )());

          var props = getPropsByTestId(renderedInstance, 'testId1', key: 'data-custom-id');
          expect(props, equals(getProps(getByTestId(renderedInstance, 'testId1', key: 'data-custom-id'))));
        });

        test('the props map of the topmost descendant that has the appropriate value for a custom prop key and the new testId is passed in', () {
          var renderedInstance = ((Test()
            ..addTestId('testId1', key: 'data-custom-id')
            ..addTestId('testId2', key: 'data-custom-id')
          )());

          var props = getPropsByTestId(renderedInstance, 'testId2', key: 'data-custom-id');
          expect(props, equals(getProps(getByTestId(renderedInstance, 'testId2', key: 'data-custom-id'))));
        });
      });

      test('null if no descendant has the appropriate value for the `data-test-id` prop key', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('otherValue'))()
        ));

        var props = getPropsByTestId(renderedInstance, 'value');

        expect(props, isNull);
      });

      test('null if the user searches for \'null\' when no test ID is set', () {
        var renderedInstance = render(Wrapper()(
          Test()()
        ));

        var props = getPropsByTestId(renderedInstance, 'null');

        expect(props, isNull);
      });

      test('null if the user searches for `null` when a test ID is set to \'null\'', () {
        var renderedInstance = render(Wrapper()(
          (Test()..addTestId('null'))()
        ));

        var props = getPropsByTestId(renderedInstance, null);

        expect(props, isNull);
      });
    });

    group('findDescendantsWithProp', () {
      test('returns the descendants with the specified propKey', () {
        var renderedInstance = render(Wrapper()([
          (Dom.div()..addProp('data-name', 'top-level DOM'))(),
          (Test()..addProp('data-name', 'top-level Dart'))(),
          testJsComponentFactory({'data-name': 'top-level JS composite'}),

          Dom.div()([
            (Dom.div()..addProp('data-name', 'nested DOM'))(),
            (Test()..addProp('data-name', 'nested Dart'))(),
            testJsComponentFactory({'data-name': 'nested JS composite'}),
          ])
        ]));

        var descendants = findDescendantsWithProp(renderedInstance, 'data-name');
        expect(descendants, [
          hasProp('data-name', 'top-level DOM'),
          hasProp('data-name', 'top-level Dart'),
          hasProp('data-name', 'top-level JS composite'),
          hasProp('data-name', 'nested DOM'),
          hasProp('data-name', 'nested Dart'),
          hasProp('data-name', 'nested JS composite'),
        ]);
      });

      test('does not throw when text nodes are present in the tree', () {
        var renderedInstance = render(Wrapper()(
          Dom.div()(),
          'I will become a text node',
        ));

        expect(() => findDescendantsWithProp(renderedInstance, 'data-null'), returnsNormally);
      });
    });

    group('unmount:', () {
      group('unmounts a React instance specified', () {
        test('by its rendered instance', () {
          var mountNode = DivElement();
          react_dom.render(Wrapper()(), mountNode);
          expect(react_dom.unmountComponentAtNode(mountNode), isTrue);
        });

        test('by its mount node', () {
          var mountNode = DivElement();
          var ref;
          react_dom.render((Dom.div()
            ..ref = ((instance) => ref = instance)
          )(), mountNode);
          expect(ref, isNotNull);

          unmount(mountNode);
          expect(ref, isNull);
        });
      });

      group('gracefully handles', () {
        test('`null`', () {
          expect(() {
            unmount(null);
          }, returnsNormally);
        });

        test('a non-mounted React instance', () {
          var mountNode = DivElement();
          var ref;
          var instance = react_dom.render((Dom.div()
            ..ref = ((instance) => ref = instance)
          )(), mountNode);
          react_dom.unmountComponentAtNode(mountNode);

          expect(ref, isNull);

          expect(() {
            unmount(instance);
          }, returnsNormally);
        });
      });

      test('throws when an invalid value is passed in', () {
        expect(() {
          unmount(Object());
        }, throwsArgumentError);
      });
    });
  });
}

@Factory()
UiFactory<TestProps> Test = _$Test; // ignore: undefined_identifier

@Props()
class _$TestProps extends UiProps {}

@Component()
class TestComponent extends UiComponent<TestProps> {
  @override
  render() => (Dom.div()..addProp('isRenderResult', true))();
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class TestProps extends _$TestProps with _$TestPropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForTestProps;
}

UiFactory<Test2Props> Test2 = castUiFactory(_$Test2); // ignore: undefined_identifier

mixin Test2Props on UiProps {}

class Test2Component extends UiComponent2<Test2Props> {
  @override
  render() => (Dom.div()..addProp('isRenderResult', true))();
}
