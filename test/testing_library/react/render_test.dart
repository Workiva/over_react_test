@TestOn('browser')
library over_react_test.testing_library_test.react.render_test;

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

import '../dom/queries/shared/scoped_queries_tests.dart';
import '../util/rendering.dart';

main() {
  group('render', () {
    List<String> calls = [];

    group('returns a RenderResult', () {
      test('', () {
        final elementToRender = (Dom.div()..id = 'root')('oh hai');
        final renderedResult = rtl.render(elementToRender);
        expect(renderedResult.container, isA<Element>());
        expect(renderedResult.baseElement, isA<Element>());
        expect(renderedResult.rerender, isA<Function>());
        expect(renderedResult.unmount, isA<Function>());
        expect(renderedResult.asFragment, isA<Function>());
        expect(renderedResult.renderedElement, same(elementToRender));
      });

      group('that contains queries scoped to', () {
        hasQueriesScopedTo('RenderResult.container', (scopeName, {bool testAsyncQuery = false}) {
          final els =
              testAsyncQuery ? DelayedRenderOf()(elementsForQuerying(scopeName)) : elementsForQuerying(scopeName);
          return rtl.render(els);
        });
      });
    });

    group('renders the provided element in a default container', () {
      test('', () {
        final renderedResult = rtl.render((Dom.div()..id = 'root')('oh hai'), autoTearDownCallback: () {
          calls.add('autoTearDownCallback');
        });
        expect(document.body.contains(renderedResult.container), isTrue);
        expect(renderedResult.container.children, hasLength(1));
        expect(renderedResult.container.children.single.text, 'oh hai');
      });

      test('wrapped in a wrapper when specified', () {
        rtl.render((Dom.div()..id = 'root')('oh hai'), wrapper: Dom.aside);
        final wrapperElement = querySelector('aside');
        expect(wrapperElement, isNotNull);
        expect(wrapperElement.querySelector('#root'), isNotNull);
      });

      test('and then updates the DOM when rerender is called', () {
        final renderedResult = rtl.render((Dom.div()..id = 'root')('oh hai'));
        final elementForRerender = (Dom.div()..id = 'root')('different');
        renderedResult.rerender(elementForRerender);
        expect(renderedResult.container.children, hasLength(1));
        expect(renderedResult.container.children.single.text, 'different');
        expect(renderedResult.renderedElement, same(elementForRerender));
      });

      group('and then unmounts / removes it by default, also calling the provided autoTearDownCallback', () {
        test('', () {
          expect(document.body.children, isEmpty);
          expect(calls, ['autoTearDownCallback']);
          calls.clear();
        });

        group('unless autoTearDown is false', () {
          rtl.RenderResult renderedResult;

          tearDownAll(() {
            renderedResult.unmount();
            renderedResult.container.remove();
          });

          test('', () {
            renderedResult = rtl.render((Dom.div()..id = 'root')('oh hai'), autoTearDown: false);
          });

          test('', () {
            expect(document.body.children.contains(renderedResult.container), isTrue);
          });
        });
      });
    });

    group('renders the provided element in the provided container', () {
      Element customContainer;

      test('', () {
        customContainer = document.body.append(DivElement()..id = 'custom-container');
        final renderedResult = rtl.render((Dom.div()..id = 'root')('oh hai'), container: customContainer);
        expect(renderedResult.container, same(customContainer));
        expect(document.body.contains(renderedResult.container), isTrue);
        expect(renderedResult.container.children, hasLength(1));
        expect(renderedResult.container.children.single.text, 'oh hai');
      });

      group('and then unmounts / removes it by default', () {
        test('', () {
          expect(document.body.children, isEmpty);
        });

        group('unless autoTearDown is false', () {
          rtl.RenderResult renderedResult;

          tearDownAll(() {
            renderedResult.unmount();
            renderedResult.container.remove();
            customContainer = null;
          });

          test('', () {
            customContainer = document.body.append(DivElement()..id = 'custom-container');
            renderedResult =
                rtl.render((Dom.div()..id = 'root')('oh hai'), container: customContainer, autoTearDown: false);
          });

          test('', () {
            expect(document.body.children.contains(renderedResult.container), isTrue);
          });
        });
      });
    });
  });
}
