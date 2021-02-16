@TestOn('browser')

library react_testing_library_test;

import 'dart:async';
import 'dart:developer';
import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

part 'react_testing_library_test.over_react.g.dart';

main() {
  enableTestMode();

  group('React Testing Library', () {
    group('render', () {
      List<String> calls = [];

      group('renders the provided element in a default container', () {
        test('', () {
          final renderedResult = rtl.render((Dom.div()..id = 'root')('oh hai'), autoTearDownCallback: () {
            calls.add('autoTearDownCallback');
          });
          expect(document.body.contains(renderedResult.container), isTrue);
          expect(renderedResult.container.children, hasLength(1));
          expect(renderedResult.container.children.single.text, 'oh hai');
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

    group('queries', () {
      rtl.RenderResult renderResultForDefaultQueries;
      rtl.RenderResult renderResultForScreenQueries;
      Element containerForScreenQueries;
      // Iterator necessary to ensure that the value of `htmlFor` / `id` will be unique for the input.
      int distinctRenderScopes;

      ReactElement renderElementsForQuerying(String testingLoc) {
        distinctRenderScopes++;
        return (Dom.div()
          ..['data-testid'] = testingLoc
          ..title = testingLoc
          ..role = Role.presentation)(
          testingLoc,
          (Dom.img()..alt = testingLoc)(),
          (Dom.label()..htmlFor = '${testingLoc}Input$distinctRenderScopes')(testingLoc),
          (Dom.input()
            ..type = 'text'
            ..id = '${testingLoc}Input$distinctRenderScopes'
            ..value = testingLoc
            ..onChange = (_) {}
            ..placeholder = testingLoc)(),
          Dom.div()(
            Dom.div()('bar 1'),
            '$testingLoc foo',
          ),
          Dom.div()(
            Dom.div()('bar 2'),
            '$testingLoc baz',
          ),
        );
      }

      setUp(() {
        distinctRenderScopes = 0;
        containerForScreenQueries =
            document.body.append(DivElement()..attributes = {'data-testid': 'for-screen-queries'});
        renderResultForScreenQueries = rtl.render(
          renderElementsForQuerying('screen'),
          container: containerForScreenQueries,
          autoTearDown: false,
        );
      });

      tearDown(() {
        renderResultForDefaultQueries?.unmount();
        renderResultForScreenQueries.unmount();
        containerForScreenQueries.remove();
      });

      group('[RenderResult]', () {
        setUp(() {
          renderResultForDefaultQueries = rtl.render(renderElementsForQuerying('default'));
        });

        group('queryBy / getBy', () {
          group('[success]', () {
            test('altText', () {
              renderResultForDefaultQueries.getByAltText('default');
            });

            test('displayValue', () {
              renderResultForDefaultQueries.getByDisplayValue('default');
            });

            test('labelText', () {
              renderResultForDefaultQueries.getByLabelText('default');
            });

            test('placeholderText', () {
              renderResultForDefaultQueries.getByPlaceholderText('default');
            });

            test('testId', () {
              renderResultForDefaultQueries.getByTestId('default');
            });

            test('text', () {
              renderResultForDefaultQueries.getByText('bar',
                  exact: false, container: renderResultForDefaultQueries.queryByText('default foo'));
              renderResultForDefaultQueries.getByText('bar',
                  exact: false, container: renderResultForDefaultQueries.queryByText('default baz'));
              final bars = renderResultForDefaultQueries.getAllByText('bar', exact: false);
              expect(bars, hasLength(2));
            });

            test('title', () {
              renderResultForDefaultQueries.getByTitle('default');
            });
          });

          // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
          group('[failure]', () {
            test('altText', () {
              expect(() => renderResultForDefaultQueries.getByAltText('screen'), throwsA(anything));
            });

            test('displayValue', () {
              expect(() => renderResultForDefaultQueries.getByDisplayValue('screen'), throwsA(anything));
            });

            test('labelText', () {
              expect(() => renderResultForDefaultQueries.getByLabelText('screen'), throwsA(anything));
            });

            test('placeholderText', () {
              expect(() => renderResultForDefaultQueries.getByPlaceholderText('screen'), throwsA(anything));
            });

            test('testId', () {
              expect(() => renderResultForDefaultQueries.getByTestId('screen'), throwsA(anything));
            });

            test('text', () {
              expect(() => renderResultForDefaultQueries.getByText('screen'), throwsA(anything));
            });

            test('title', () {
              expect(() => renderResultForDefaultQueries.getByTitle('screen'), throwsA(anything));
            });
          });
        });

        group('findBy', () {
          group('[success]', () {
            test('altText', () async {
              await renderResultForDefaultQueries.findByAltText('default');
            });

            test('displayValue', () async {
              await renderResultForDefaultQueries.findByDisplayValue('default');
            });

            test('labelText', () async {
              await renderResultForDefaultQueries.findByLabelText('default');
            });

            test('placeholderText', () async {
              await renderResultForDefaultQueries.findByPlaceholderText('default');
            });

            test('testId', () async {
              await renderResultForDefaultQueries.findByTestId('default');
            });

            test('text', () async {
              final testDelay = const Duration(milliseconds: 2000);
              rtl.render((DelayedDomNodeAppearance()..delayHiddenNodeRenderFor = testDelay)());
              expect(renderResultForDefaultQueries.queryByText('visible'), isNotNull);
              expect(renderResultForDefaultQueries.queryByText('hidden'), isNull, reason: 'test setup sanity check');
              final hiddenNode = await renderResultForDefaultQueries.findByText('hidden', timeout: testDelay);
              expect(renderResultForDefaultQueries.queryByText('hidden'), isNotNull, reason: 'findBy sanity check');

              expect(hiddenNode, isNotNull);
            });

            test('title', () async {
              await renderResultForDefaultQueries.findByTitle('default');
            });
          });

          // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
          group('[failure]', () {
            const shortTimeout = Duration(milliseconds: 50);
            test('altText', () async {
              expect(() async => await renderResultForDefaultQueries.findByAltText('screen', timeout: shortTimeout),
                  throwsA(anything));
            });

            test('displayValue', () async {
              expect(
                  () async => await renderResultForDefaultQueries.findByDisplayValue('screen', timeout: shortTimeout),
                  throwsA(anything));
            });

            test('labelText', () async {
              expect(() async => await renderResultForDefaultQueries.findByLabelText('screen', timeout: shortTimeout),
                  throwsA(anything));
            });

            test('placeholderText', () async {
              expect(
                  () async =>
                      await renderResultForDefaultQueries.findByPlaceholderText('screen', timeout: shortTimeout),
                  throwsA(anything));
            });

            test('testId', () async {
              expect(() async => await renderResultForDefaultQueries.findByTestId('screen', timeout: shortTimeout),
                  throwsA(anything));
            });

            test('text', () async {
              expect(() async => await renderResultForDefaultQueries.findByText('screen', timeout: shortTimeout),
                  throwsA(anything));
            });

            test('title', () async {
              expect(() async => await renderResultForDefaultQueries.findByTitle('screen', timeout: shortTimeout),
                  throwsA(anything));
            });
          });
        });
      });

      group('[screen]', () {
        setUp(() {
          renderResultForDefaultQueries = rtl.render(renderElementsForQuerying('default'));
        });

        group('queryBy / getBy', () {
          group('[success]', () {
            test('altText', () {
              rtl.screen.getByAltText('screen');
              rtl.screen.getByAltText('default');
            });

            test('displayValue', () {
              rtl.screen.getByDisplayValue('screen');
              rtl.screen.getByDisplayValue('default');
            });

            test('labelText', () {
              rtl.screen.getByLabelText('screen');
              rtl.screen.getByLabelText('default');
            });

            test('placeholderText', () {
              rtl.screen.getByPlaceholderText('screen');
              rtl.screen.getByPlaceholderText('default');
            });

            test('testId', () {
              rtl.screen.getByTestId('screen');
              rtl.screen.getByTestId('default');
            });

            test('text', () {
              rtl.screen.getByText('bar', exact: false, container: rtl.screen.queryByText('screen foo'));
              rtl.screen.getByText('bar', exact: false, container: rtl.screen.queryByText('screen baz'));
              final bars = rtl.screen.getAllByText('bar', exact: false);
              expect(bars, hasLength(4));
            });

            test('title', () {
              rtl.screen.getByTitle('screen');
              rtl.screen.getByTitle('default');
            });
          });

          // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
          group('[failure]', () {
            test('altText', () {
              expect(() => rtl.screen.getByAltText('doesNotExist'), throwsA(anything));
            });

            test('displayValue', () {
              expect(() => rtl.screen.getByDisplayValue('doesNotExist'), throwsA(anything));
            });

            test('labelText', () {
              expect(() => rtl.screen.getByLabelText('doesNotExist'), throwsA(anything));
            });

            test('placeholderText', () {
              expect(() => rtl.screen.getByPlaceholderText('doesNotExist'), throwsA(anything));
            });

            test('testId', () {
              expect(() => rtl.screen.getByTestId('doesNotExist'), throwsA(anything));
            });

            test('text', () {
              expect(() => rtl.screen.getByText('doesNotExist'), throwsA(anything));
            });

            test('title', () {
              expect(() => rtl.screen.getByTitle('doesNotExist'), throwsA(anything));
            });
          });
        });

        group('findBy', () {
          group('[success]', () {
            test('altText', () async {});

            test('displayValue', () async {});

            test('labelText', () async {});

            test('placeholderText', () async {});

            test('testId', () async {});

            test('text', () async {});

            test('title', () async {});
          });

          // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
          group('[failure]', () {
            test('altText', () async {});

            test('displayValue', () async {});

            test('labelText', () async {});

            test('placeholderText', () async {});

            test('testId', () async {});

            test('text', () async {});

            test('title', () async {});
          });
        });
      });

      group('[within()]', () {
        rtl.RenderResult renderResultForWithinQueries;
        Element containerForWithinQueries;

        setUp(() {
          containerForWithinQueries =
              document.body.append(DivElement()..attributes = {'data-testid': 'for-within-queries'});
          renderResultForWithinQueries = rtl.render(
            renderElementsForQuerying('default'),
            container: containerForWithinQueries,
            autoTearDown: false,
          );
          renderResultForDefaultQueries = rtl.render(renderElementsForQuerying('default'));
        });

        tearDown(() {
          renderResultForWithinQueries.unmount();
          containerForWithinQueries.remove();
        });

        group('queryBy / getBy', () {
          group('[success]', () {
            test('altText', () {
              rtl.within(containerForWithinQueries).getByAltText('default');
              final allMatches = rtl.screen.queryAllByAltText('default');
              expect(allMatches, hasLength(greaterThan(1)));
            });

            test('displayValue', () {
              rtl.within(containerForWithinQueries).getByDisplayValue('default');
              final allMatches = rtl.screen.queryAllByDisplayValue('default');
              expect(allMatches, hasLength(greaterThan(1)));
            });

            test('labelText', () {
              rtl.within(containerForWithinQueries).getByLabelText('default');
              final allMatches = rtl.screen.queryAllByLabelText('default');
              expect(allMatches, hasLength(greaterThan(1)));
            });

            test('placeholderText', () {
              rtl.within(containerForWithinQueries).getByPlaceholderText('default');
              final allMatches = rtl.screen.queryAllByPlaceholderText('default');
              expect(allMatches, hasLength(greaterThan(1)));
            });

            test('testId', () {
              rtl.within(containerForWithinQueries).getByTestId('default');
              final allMatches = rtl.screen.queryAllByTestId('default');
              expect(allMatches, hasLength(greaterThan(1)));
            });

            test('text', () {
              rtl.within(containerForWithinQueries).getByText('bar',
                  exact: false, container: rtl.within(containerForWithinQueries).queryByText('default foo'));
              rtl.within(containerForWithinQueries).getByText('bar',
                  exact: false, container: rtl.within(containerForWithinQueries).queryByText('default baz'));
              final nestedBars = rtl.within(containerForWithinQueries).getAllByText('bar', exact: false);
              expect(nestedBars, hasLength(2));
              final allBars = rtl.screen.getAllByText('bar', exact: false);
              expect(allBars, hasLength(greaterThan(nestedBars.length)));
            });

            test('title', () {
              rtl.within(containerForWithinQueries).getByTitle('default');
              final allMatches = rtl.screen.queryAllByTitle('default');
              expect(allMatches, hasLength(greaterThan(1)));
            });
          });

          // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
          group('[failure]', () {
            test('altText', () {
              expect(() => rtl.within(containerForWithinQueries).getByAltText('screen'), throwsA(anything));
            });

            test('displayValue', () {
              expect(() => rtl.within(containerForWithinQueries).getByDisplayValue('screen'), throwsA(anything));
            });

            test('labelText', () {
              expect(() => rtl.within(containerForWithinQueries).getByLabelText('screen'), throwsA(anything));
            });

            test('placeholderText', () {
              expect(() => rtl.within(containerForWithinQueries).getByPlaceholderText('screen'), throwsA(anything));
            });

            test('testId', () {
              expect(() => rtl.within(containerForWithinQueries).getByTestId('screen'), throwsA(anything));
            });

            test('text', () {
              expect(() => rtl.within(containerForWithinQueries).getByText('screen'), throwsA(anything));
            });

            test('title', () {
              expect(() => rtl.within(containerForWithinQueries).getByTitle('screen'), throwsA(anything));
            });
          });
        });

        group('findBy', () {
          group('[success]', () {
            test('altText', () async {});

            test('displayValue', () async {});

            test('labelText', () async {});

            test('placeholderText', () async {});

            test('testId', () async {});

            test('text', () async {});

            test('title', () async {});
          });

          // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
          group('[failure]', () {
            test('altText', () async {});

            test('displayValue', () async {});

            test('labelText', () async {});

            test('placeholderText', () async {});

            test('testId', () async {});

            test('text', () async {});

            test('title', () async {});
          });
        });
      });

      group('waitFor', () {
        test('[success]', () async {
          bool hiddenNodeIsVisible = false;
          final testDelay = const Duration(milliseconds: 2000);
          final result = rtl.render((DelayedDomNodeAppearance()
            ..delayHiddenNodeRenderFor = testDelay
            ..onHiddenNodeIsVisible = () {
              debugger();
              hiddenNodeIsVisible = true;
            })());
          expect(result.queryByText('visible'), isNotNull);
          expect(result.queryByText('hidden'), isNull, reason: 'test setup sanity check');
          await rtl.waitFor(() => expect(hiddenNodeIsVisible, isTrue),
              timeout: Duration(milliseconds: testDelay.inMilliseconds + 100));
          expect(result.queryByText('hidden'), isNotNull);
        });

        test('[failure]', () async {
          bool hiddenNodeIsVisible = false;
          final testDelay = const Duration(milliseconds: 1000);
          // Intentionally omit the callback that would otherwise set hiddenNodeIsVisible to true
          final result = rtl.render((DelayedDomNodeAppearance()..delayHiddenNodeRenderFor = testDelay)());
          expect(result.queryByText('visible'), isNotNull);
          expect(result.queryByText('hidden'), isNull, reason: 'test setup sanity check');

          expect(
              () async => await rtl.waitFor(() => expect(hiddenNodeIsVisible, isTrue),
                  timeout: Duration(milliseconds: testDelay.inMilliseconds + 100)),
              throwsA(isA<TestFailure>()));
          expect(result.queryByText('hidden'), isNull);
        });
      });

      group('waitForElementToBeRemoved', () {
        test('[success]', () async {
          final testDelay = const Duration(milliseconds: 2000);
          final result = rtl.render((ControlledDomNodeAppearance()
            ..delayHiddenNodeRenderFor = testDelay
            ..shouldRenderHiddenNode = true)());
          expect(result.queryByText('visible'), isNotNull, reason: 'test setup sanity check');
          expect(result.queryByText('willBeRemoved'), isNotNull, reason: 'test setup sanity check');

          result.rerender((ControlledDomNodeAppearance()
            ..delayHiddenNodeRenderFor = testDelay
            ..shouldRenderHiddenNode = false)());
          await rtl.waitForElementToBeRemoved(() => result.queryByText('willBeRemoved'),
              timeout: Duration(milliseconds: testDelay.inMilliseconds + 100), onTimeout: (error) {
            return TestFailure(
                'The element with text "willBeRemoved" is still present in the DOM after ${testDelay.inMilliseconds + 100}ms.');
          });
          expect(result.queryByText('willBeRemoved'), isNull);
        });

        test('[failure]', () async {
          final testDelay = const Duration(milliseconds: 2000);
          final result = rtl.render((ControlledDomNodeAppearance()
            ..delayHiddenNodeRenderFor = testDelay
            ..shouldRenderHiddenNode = true)());
          expect(result.queryByText('visible'), isNotNull, reason: 'test setup sanity check');
          expect(result.queryByText('willBeRemoved'), isNotNull, reason: 'test setup sanity check');

          expect(
              () async => await rtl.waitForElementToBeRemoved(() => result.queryByText('willBeRemoved'),
                      timeout: Duration(milliseconds: testDelay.inMilliseconds + 100), onTimeout: (error) {
                    return TestFailure(
                        'The element with text "willBeRemoved" is still present in the DOM after ${testDelay.inMilliseconds + 100}ms.');
                  }),
              throwsA(isA<TestFailure>()));
          expect(result.queryByText('willBeRemoved'), isNotNull);
        });
      });
    });
  });
}

mixin DelayedDomNodeAppearanceProps on UiProps {
  @requiredProp
  Duration delayHiddenNodeRenderFor;
  Function() onHiddenNodeIsVisible;
}

UiFactory<DelayedDomNodeAppearanceProps> DelayedDomNodeAppearance = uiFunction(
  (props) {
    final shouldRenderHiddenNode = useState(false);

    useEffect(() {
      final timer = Timer(props.delayHiddenNodeRenderFor, () {
        shouldRenderHiddenNode.set(true);
      });

      return timer.cancel;
    }, const []);

    useEffect(() {
      if (shouldRenderHiddenNode.value) {
        props.onHiddenNodeIsVisible?.call();
      }
    }, [shouldRenderHiddenNode.value]);

    ReactElement _renderHiddenNode() {
      if (!shouldRenderHiddenNode.value) return null;

      return Dom.div()('hidden');
    }

    return Dom.div()(
      Dom.div()('visible'),
      _renderHiddenNode(),
    );
  },
  _$DelayedDomNodeAppearanceConfig, // ignore: undefined_identifier
);

mixin ControlledDomNodeAppearanceProps on UiProps {
  @requiredProp
  Duration delayHiddenNodeRenderFor;
  @requiredProp
  bool shouldRenderHiddenNode;
}

UiFactory<ControlledDomNodeAppearanceProps> ControlledDomNodeAppearance = uiFunction(
  (props) {
    final shouldRenderHiddenNode = useState(props.shouldRenderHiddenNode);

    useEffect(() {
      Timer timer;
      if (props.shouldRenderHiddenNode != shouldRenderHiddenNode.value) {
        timer = Timer(props.delayHiddenNodeRenderFor, () {
          shouldRenderHiddenNode.set(props.shouldRenderHiddenNode);
        });
      }

      return timer?.cancel;
    }, [props.shouldRenderHiddenNode, shouldRenderHiddenNode.value]);

    ReactElement _renderHiddenNode() {
      if (!shouldRenderHiddenNode.value) return null;

      return Dom.div()('willBeRemoved');
    }

    return Dom.div()(
      Dom.div()('visible'),
      _renderHiddenNode(),
    );
  },
  _$ControlledDomNodeAppearanceConfig, // ignore: undefined_identifier
);

mixin TestWrapperProps on UiProps {}

UiFactory<TestWrapperProps> TestWrapper = uiFunction(
  (props) {
    return props.children;
  },
  _$TestWrapperConfig, // ignore: undefined_identifier
);
