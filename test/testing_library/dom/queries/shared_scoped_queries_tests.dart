// ignore_for_file: invalid_use_of_protected_member, await_only_futures
import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:over_react_test/src/testing_library/dom/pretty_dom.dart';
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show JsConfig, jsConfigure;
import 'package:over_react_test/src/testing_library/dom/matches/types.dart' show TextMatch;
import 'package:over_react_test/src/testing_library/dom/scoped_queries.dart' show ScopedQueries;

import '../../util/matchers.dart';

part 'shared_scoped_queries_tests.over_react.g.dart';

const asyncQueryTimeout = Duration(milliseconds: 200);
final asyncQueryTestTimeout = Timeout(asyncQueryTimeout * 2);

@isTestGroup
void hasQueriesScopedTo(String scopeName, ScopedQueries Function(String scopeName, {bool testAsyncQuery}) getQueries, {
  // Optional because in the case of RenderResult, calling `getQueries` will render AND return the ScopedQueries object.
  rtl.RenderResult Function({bool testAsyncQuery}) render,
}) {
  group('$scopeName:', () {
    ScopedQueries queries;
    String expectedPrettyDom;
    JsConfig initialConfig;

    setUpAll(() {
      initialConfig = rtl.getConfig();
    });

    tearDownAll(() {
      jsConfigure(initialConfig);
      expectedPrettyDom = null;
    });

    setUp(() {
      queries = null;
      rtl.configure(
          throwSuggestions: false,
        asyncUtilTimeout: asyncQueryTimeout.inMilliseconds,
      );
      expect(document.body.children, isEmpty);
    });

    ScopedQueries initQueries({bool testAsyncQuery = false}) {
      rtl.RenderResult renderResult;

      queries ??= getQueries(scopeName, testAsyncQuery: testAsyncQuery);
      if (queries is! rtl.RenderResult) {
        if (render == null) {
          throw ArgumentError('When getQueries() does not return a RenderResult, the render argument must do so.');
        }

        renderResult = render(testAsyncQuery: testAsyncQuery);
      } else {
        renderResult = queries as rtl.RenderResult;
      }

      expectedPrettyDom = prettyDOM(renderResult.container);

      if (testAsyncQuery) {
        final delayedRenderOfRootNode = querySelector('[$defaultTestIdKey="delayed-render-of-root"]');
        expect(delayedRenderOfRootNode, isNotNull,
            reason: 'Async queries should be tested on DOM wrapped by / controlled by the DelayedRenderOf component.');
        expect(delayedRenderOfRootNode.children, isEmpty,
            reason: 'Async queries should be tested with DOM that appears only after the query is called.');

        // If we're testing an async query, we'll set expectedPrettyDom using the
        // DelayedRenderOf wrapper that async tests use, but with the `delay` hardcoded
        // to zero so we can see what DOM to expect when the future completes in the
        // actual query test.
        final tempRenderResult = rtl.render(cloneElement(renderResult.renderedElement, DelayedRenderOf()..delay = Duration.zero), autoTearDown: false);
        expectedPrettyDom = prettyDOM(tempRenderResult.container);
        tempRenderResult.unmount();
        tempRenderResult.container?.remove();
      }

      return queries;
    }

    test('all queries', () {
      queries = initQueries();

      expect(queries.getByAltText, isA<Function>(), reason: 'getByAltText');
      expect(queries.getAllByAltText, isA<Function>(), reason: 'getAllByAltText');
      expect(queries.queryByAltText, isA<Function>(), reason: 'queryByAltText');
      expect(queries.queryAllByAltText, isA<Function>(), reason: 'queryAllByAltText');
      expect(queries.findByAltText, isA<Function>(), reason: 'findByAltText');
      expect(queries.findAllByAltText, isA<Function>(), reason: 'findAllByAltText');
      expect(queries.getByDisplayValue, isA<Function>(), reason: 'getByDisplayValue');
      expect(queries.getAllByDisplayValue, isA<Function>(), reason: 'getAllByDisplayValue');
      expect(queries.queryByDisplayValue, isA<Function>(), reason: 'queryByDisplayValue');
      expect(queries.queryAllByDisplayValue, isA<Function>(), reason: 'queryAllByDisplayValue');
      expect(queries.findByDisplayValue, isA<Function>(), reason: 'findByDisplayValue');
      expect(queries.findAllByDisplayValue, isA<Function>(), reason: 'findAllByDisplayValue');
      expect(queries.getByLabelText, isA<Function>(), reason: 'getByLabelText');
      expect(queries.getAllByLabelText, isA<Function>(), reason: 'getAllByLabelText');
      expect(queries.queryByLabelText, isA<Function>(), reason: 'queryByLabelText');
      expect(queries.queryAllByLabelText, isA<Function>(), reason: 'queryAllByLabelText');
      expect(queries.findByLabelText, isA<Function>(), reason: 'findByLabelText');
      expect(queries.findAllByLabelText, isA<Function>(), reason: 'findAllByLabelText');
      expect(queries.getByPlaceholderText, isA<Function>(), reason: 'getByPlaceholderText');
      expect(queries.getAllByPlaceholderText, isA<Function>(), reason: 'getAllByPlaceholderText');
      expect(queries.queryByPlaceholderText, isA<Function>(), reason: 'queryByPlaceholderText');
      expect(queries.queryAllByPlaceholderText, isA<Function>(), reason: 'queryAllByPlaceholderText');
      expect(queries.findByPlaceholderText, isA<Function>(), reason: 'findByPlaceholderText');
      expect(queries.findAllByPlaceholderText, isA<Function>(), reason: 'findAllByPlaceholderText');
      expect(queries.getByRole, isA<Function>(), reason: 'getByRole');
      expect(queries.getAllByRole, isA<Function>(), reason: 'getAllByRole');
      expect(queries.queryByRole, isA<Function>(), reason: 'queryByRole');
      expect(queries.queryAllByRole, isA<Function>(), reason: 'queryAllByRole');
      expect(queries.findByRole, isA<Function>(), reason: 'findByRole');
      expect(queries.findAllByRole, isA<Function>(), reason: 'findAllByRole');
      expect(queries.getByTestId, isA<Function>(), reason: 'getByTestId');
      expect(queries.getAllByTestId, isA<Function>(), reason: 'getAllByTestId');
      expect(queries.queryByTestId, isA<Function>(), reason: 'queryByTestId');
      expect(queries.queryAllByTestId, isA<Function>(), reason: 'queryAllByTestId');
      expect(queries.findByTestId, isA<Function>(), reason: 'findByTestId');
      expect(queries.findAllByTestId, isA<Function>(), reason: 'findAllByTestId');
      expect(queries.getByText, isA<Function>(), reason: 'getByText');
      expect(queries.getAllByText, isA<Function>(), reason: 'getAllByText');
      expect(queries.queryByText, isA<Function>(), reason: 'queryByText');
      expect(queries.queryAllByText, isA<Function>(), reason: 'queryAllByText');
      expect(queries.findByText, isA<Function>(), reason: 'findByText');
      expect(queries.findAllByText, isA<Function>(), reason: 'findAllByText');
      expect(queries.getByTitle, isA<Function>(), reason: 'getByTitle');
      expect(queries.getAllByTitle, isA<Function>(), reason: 'getAllByTitle');
      expect(queries.queryByTitle, isA<Function>(), reason: 'queryByTitle');
      expect(queries.queryAllByTitle, isA<Function>(), reason: 'queryAllByTitle');
      expect(queries.findByTitle, isA<Function>(), reason: 'findByTitle');
      expect(queries.findAllByTitle, isA<Function>(), reason: 'findAllByTitle');
    });

    group('', () {
      testTextMatchTypes(
        'AltText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByAltText,
        getGetByQuery: () => initQueries().getByAltText,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByAltText,
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'alt text: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'DisplayValue',
        textMatchArgName: 'value',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByDisplayValue,
        getGetByQuery: () => initQueries().getByDisplayValue,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByDisplayValue,
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'display value: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'LabelText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByLabelText,
        getGetByQuery: () => initQueries().getByLabelText,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByLabelText,
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'label with the text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'PlaceholderText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByPlaceholderText,
        getGetByQuery: () => initQueries().getByPlaceholderText,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByPlaceholderText,
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'placeholder text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'role',
        textMatchArgSupportsFuzzyMatching: false, // exact = false is not supported by role queries
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByRole,
        getGetByQuery: () => initQueries().getByRole,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByRole,
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'with the role "$valueNotFoundPlaceholder"',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'name',
        textMatchArgSupportsFuzzyMatching: false, // exact = false is not supported by role queries
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByRole,
        getGetByQuery: () => initQueries().getByRole,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByRole,
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'with the role "$validRoleInDom" and name "$valueNotFoundPlaceholder"',
      );
    });

    // group('queryBy / getBy', () {
    //   group('[success]', () {
    //     test('altText', () {
    //       queries.getByAltText('default');
    //     });
    //
    //     test('displayValue', () {
    //       queries.getByDisplayValue('default');
    //     });
    //
    //     test('labelText', () {
    //       queries.getByLabelText('default');
    //     });
    //
    //     test('placeholderText', () {
    //       queries.getByPlaceholderText('default');
    //     });
    //
    //     test('testId', () {
    //       queries.getByTestId('default');
    //     });
    //
    //     test('text', () {
    //       rtl.within(queries.queryByText('default foo')).getByText('bar', exact: false);
    //       rtl.within(queries.queryByText('default baz')).getByText('bar', exact: false);
    //       final bars = queries.getAllByText('bar', exact: false);
    //       expect(bars, hasLength(2));
    //     });
    //
    //     test('title', () {
    //       queries.getByTitle('default');
    //     });
    //   });
    //
    //   // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
    //   group('[failure]', () {
    //     test('altText', () {
    //       expect(() => queries.getByAltText('screen'), throwsA(anything));
    //     });
    //
    //     test('displayValue', () {
    //       expect(() => queries.getByDisplayValue('screen'), throwsA(anything));
    //     });
    //
    //     test('labelText', () {
    //       expect(() => queries.getByLabelText('screen'), throwsA(anything));
    //     });
    //
    //     test('placeholderText', () {
    //       expect(() => queries.getByPlaceholderText('screen'), throwsA(anything));
    //     });
    //
    //     test('testId', () {
    //       expect(() => queries.getByTestId('screen'), throwsA(anything));
    //     });
    //
    //     test('text', () {
    //       expect(() => queries.getByText('screen'), throwsA(anything));
    //     });
    //
    //     test('title', () {
    //       expect(() => queries.getByTitle('screen'), throwsA(anything));
    //     });
    //   });
    // });
    //
    // group('findBy', () {
    //   group('[success]', () {
    //     test('altText', () async {
    //       await queries.findByAltText('default');
    //     });
    //
    //     test('displayValue', () async {
    //       await queries.findByDisplayValue('default');
    //     });
    //
    //     test('labelText', () async {
    //       await queries.findByLabelText('default');
    //     });
    //
    //     test('placeholderText', () async {
    //       await queries.findByPlaceholderText('default');
    //     });
    //
    //     test('testId', () async {
    //       await queries.findByTestId('default');
    //     });
    //
    //     test('text', () async {
    //       final testDelay = const Duration(milliseconds: 2000);
    //       rtl.render((DelayedRenderOf()..delayHiddenNodeRenderFor = testDelay)());
    //       expect(queries.queryByText('visible'), isNotNull);
    //       expect(queries.queryByText('hidden'), isNull, reason: 'test setup sanity check');
    //       final hiddenNode = await queries.findByText('hidden', timeout: testDelay);
    //       expect(queries.queryByText('hidden'), isNotNull, reason: 'findBy sanity check');
    //
    //       expect(hiddenNode, isNotNull);
    //     });
    //
    //     test('title', () async {
    //       await queries.findByTitle('default');
    //     });
    //   });
    //
    //   // TODO: We will want to beef up these expectations to make sure the failure is a nice one with a full stack
    //   group('[failure]', () {
    //     const shortTimeout = Duration(milliseconds: 50);
    //     test('altText', () async {
    //       expect(() async => await queries.findByAltText('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //
    //     test('displayValue', () async {
    //       expect(
    //           () async => await queries.findByDisplayValue('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //
    //     test('labelText', () async {
    //       expect(() async => await queries.findByLabelText('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //
    //     test('placeholderText', () async {
    //       expect(
    //           () async =>
    //               await queries.findByPlaceholderText('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //
    //     test('testId', () async {
    //       expect(() async => await queries.findByTestId('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //
    //     test('text', () async {
    //       expect(() async => await queries.findByText('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //
    //     test('title', () async {
    //       expect(() async => await queries.findByTitle('screen', timeout: shortTimeout),
    //           throwsA(anything));
    //     });
    //   });
    // });

    test('limiting the scope of the query as expected', () {
      final outOfScopeElement = DivElement()..text = 'out-of-scope';
      document.body.append(outOfScopeElement);

      queries = initQueries();
      if (queries.getContainerForScope() != document.body) {
        expect(queries.queryByText('out-of-scope'), isNull,
            reason: 'The scoped query should not return elements that are not found within the scoped container.');
      } else {
        expect(queries.queryByText('out-of-scope'), isNotNull,
            reason: 'The screen query should return elements that are found within the document.');
      }

      outOfScopeElement.remove();
    });
  });
}

String getStringThatFuzzyMatches(String exactValue) => exactValue.substring(2);

@isTestGroup
void testTextMatchTypes(
  String queryName, {
  @required String textMatchArgName,
  @required String queryShouldMatchOn,
  @required Function Function() getQueryByQuery,
  @required Function Function() getGetByQuery,
  @required Function Function() getFindByQuery,
      @required String Function() getExpectedPrettyDom,
      bool textMatchArgSupportsFuzzyMatching = true,
  String failureSnapshotPattern,
}) {
  Matcher toThrowErrorMatchingInlineSnapshotPattern(String valueExpectedButNotFound) {
    Matcher containsMatcher;
    if (failureSnapshotPattern != null) {
      containsMatcher = buildContainsPatternUsing(failureSnapshotPattern, valueExpectedButNotFound);
    } else {
      containsMatcher = contains(valueExpectedButNotFound);
    }

    // When running only a single test, if the query is an async one,
    // RenderResult.container will not be accurate when called - so `expectedPrettyDom` will be null.
    final expectedPrettyDom = getExpectedPrettyDom();
    final stringPrettyDomMatcher = expectedPrettyDom != null ? endsWith(expectedPrettyDom) : null;
    return toThrowErrorMatchingInlineSnapshot(containsMatcher, stringPrettyDomMatcher);
  }

  group('when the $textMatchArgName argument is a', () {
    group('String (TextMatch.parse),', () {
      String fuzzyValue = getStringThatFuzzyMatches(queryShouldMatchOn);

      group('and exact = true (default),', () {
        group('and a failure/null return value is expected for the', () {
          test('queryBy$queryName query', () {
            if (queryName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(getQueryByQuery()(validRoleNotInDom), isNull);
              } else if (textMatchArgName == 'name') {
                expect(getQueryByQuery()(validRoleInDom, name: fuzzyValue), isNull);
              }
            } else {
              expect(getQueryByQuery()(fuzzyValue), isNull);
            }
          });

          test('getBy$queryName query', () {
            if (queryName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() => getGetByQuery()(validRoleNotInDom), toThrowErrorMatchingInlineSnapshotPattern(validRoleNotInDom));
              } else if (textMatchArgName == 'name') {
                expect(() => getGetByQuery()(validRoleInDom, name: fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
              }
            } else {
              expect(() => getGetByQuery()(fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
            }
          });

          test('findBy$queryName query', () async {
            final query = getFindByQuery();
            if (queryName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() async => await query(validRoleNotInDom), toThrowErrorMatchingInlineSnapshotPattern(validRoleNotInDom));
              } else if (textMatchArgName == 'name') {
                expect(() async => await query(validRoleInDom, name: fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
              }
            } else {
              expect(() async => await query(fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
            }
          }, timeout: asyncQueryTestTimeout);
        });

        group('returning the matching element from the', () {
          test('queryBy$queryName query', () {
            if (queryName == 'Role') {
              expect(getQueryByQuery()(validRoleInDom, name: queryShouldMatchOn), isA<Element>());
            } else {
              expect(getQueryByQuery()(queryShouldMatchOn), isA<Element>());
            }
          });

          test('getBy$queryName query', () {
            if (queryName == 'Role') {
              expect(getGetByQuery()(validRoleInDom, name: queryShouldMatchOn), isA<Element>());
            } else {
              expect(getGetByQuery()(queryShouldMatchOn), isA<Element>());
            }
          });

          test('findBy$queryName query', () async {
            Element findByQueryReturnValue;

            if (queryName == 'Role') {
              findByQueryReturnValue = await getFindByQuery()(validRoleInDom, name: queryShouldMatchOn);
            } else {
              findByQueryReturnValue = await getFindByQuery()(queryShouldMatchOn);
            }

            expect(findByQueryReturnValue, isA<Element>());
          }, timeout: asyncQueryTestTimeout);
        });
      });

      if (textMatchArgSupportsFuzzyMatching) {
        group('and exact = false,', () {
          group('and a failure/null return value is expected when calling the', () {
            test('queryBy$queryName query', () {
              expect(getQueryByQuery()('somethingDifferentThatDoesNotMatch', exact: false), isNull);
            });

            test('getBy$queryName query', () {
              expect(() => getGetByQuery()('somethingDifferentThatDoesNotMatch', exact: false),
                  toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch'));
            });

            test('findBy$queryName query', () {
              final query = getFindByQuery();
              expect(() async => await query('somethingDifferentThatDoesNotMatch', exact: false),
                    toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch'));
            }, timeout: asyncQueryTestTimeout);
          });

          group('and a match is found when calling the', () {
            test('queryBy$queryName query', () {
              expect(getQueryByQuery()(fuzzyValue, exact: false), isA<Element>());
            });

            test('getBy$queryName query', () {
              expect(getGetByQuery()(fuzzyValue, exact: false), isA<Element>());
            });

            test('findBy$queryName query', () async {
              final findByQueryReturnValue = await getFindByQuery()(fuzzyValue, exact: false);
              expect(findByQueryReturnValue, isA<Element>());
            }, timeout: asyncQueryTestTimeout);
          });
        });
      }

      group('and normalizer is customized', () {
        // TODO
      });
    });

    group('RegExp (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        const badRegExPattern = "^somethingDifferentThatDoesNotMatch\$";

        test('queryBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()(RegExp(badRegExPattern)), isNull);
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: RegExp(badRegExPattern)), isNull);
            }
          } else {
            expect(getQueryByQuery()(RegExp(badRegExPattern)), isNull);
          }
        });

        test('getBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() => getGetByQuery()(RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            } else if (textMatchArgName == 'name') {
              expect(() => getGetByQuery()(validRoleInDom, name: RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            }
          } else {
            expect(() => getGetByQuery()(RegExp(badRegExPattern)),
                toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
          }
        });

        test('findBy$queryName query', () async {
          final query = getFindByQuery();
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() async => await query(RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            } else if (textMatchArgName == 'name') {
              // TODO: For some reason, the RegExp being passed to name is being seen as a function?
              expect(() async => await query(validRoleInDom, name: RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            }
          } else {
            expect(() async => await query(RegExp(badRegExPattern)),
                toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
          }
        }, timeout: asyncQueryTestTimeout);
      });

      group('returning the matching element from the', () {
        test('queryBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()(RegExp("^$validRoleInDom\$")), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$")), isA<Element>());
            }
          } else {
            expect(getQueryByQuery()(RegExp("^$queryShouldMatchOn\$")), isA<Element>());
          }
        });

        test('getBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getGetByQuery()(RegExp("^$validRoleInDom\$")), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getGetByQuery()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$")), isA<Element>());
            }
          } else {
            expect(getGetByQuery()(RegExp("^$queryShouldMatchOn\$")), isA<Element>());
          }
        });

        test('findBy$queryName query', () async {
          Element findByQueryReturnValue;

          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              findByQueryReturnValue = await getFindByQuery()(RegExp("^$validRoleInDom\$"));
            } else if (textMatchArgName == 'name') {
              findByQueryReturnValue = await getFindByQuery()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$"));
            }
          } else {
            findByQueryReturnValue = await getFindByQuery()(RegExp("^$queryShouldMatchOn\$"));
          }

          expect(findByQueryReturnValue, isA<Element>());
        }, timeout: asyncQueryTestTimeout);
      });
    });

    group('Function (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        test('queryBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()((content, el) => content == validRoleNotInDom), isNull);
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: (content, el) => content != queryShouldMatchOn), isNull);
            }
          } else {
            expect(getQueryByQuery()((content, el) => content != queryShouldMatchOn), isNull);
          }
        });

        test('getBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() => getGetByQuery()((content, el) => content == validRoleNotInDom),
                toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            } else if (textMatchArgName == 'name') {
              expect(() => getGetByQuery()(validRoleInDom, name: (content, el) => content != queryShouldMatchOn),
                toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            }
          } else {
            expect(() => getGetByQuery()((content, el) => content != queryShouldMatchOn),
                toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
          }
        });

        test('findBy$queryName query', () async {
          final query = getFindByQuery();
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() async => await query((content, el) => content == validRoleNotInDom),
                  toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            } else if (textMatchArgName == 'name') {
              expect(() async => await query(validRoleInDom, name: (content, el) => content != queryShouldMatchOn),
                  toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            }
          } else {
            expect(() async => await query((content, el) => content != queryShouldMatchOn),
                toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
          }
        }, timeout: asyncQueryTestTimeout);
      });

      group('returning the matching element from the', () {
        test('queryBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()((content, el) => content == validRoleInDom), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn), isA<Element>());
            }
          } else {
            expect(getQueryByQuery()((content, el) => content == queryShouldMatchOn), isA<Element>());
          }
        });

        test('getBy$queryName query', () {
          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getGetByQuery()((content, el) => content == validRoleInDom), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getGetByQuery()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn), isA<Element>());
            }
          } else {
            expect(getGetByQuery()((content, el) => content == queryShouldMatchOn), isA<Element>());
          }
        });

        test('findBy$queryName query', () async {
          Element findByQueryReturnValue;

          if (queryName == 'Role') {
            if (textMatchArgName == 'role') {
              findByQueryReturnValue = await getFindByQuery()((content, el) => content == validRoleInDom);
            } else if (textMatchArgName == 'name') {
              findByQueryReturnValue = await getFindByQuery()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn);
            }
          } else {
            findByQueryReturnValue = await getFindByQuery()((content, el) => content == queryShouldMatchOn);
          }

          expect(findByQueryReturnValue, isA<Element>());
        }, timeout: asyncQueryTestTimeout);
      });
    });
  });
}

const validRoleInDom = 'button';
const validRoleNotInDom = 'tablist';

ReactElement elementsForQuerying(String uniqueName) {
  return (Dom.div()
    ..addTestId(uniqueName)
    ..title = uniqueName
    ..role = Role.presentation)(
    uniqueName,
    (Dom.button()..type = 'button')(uniqueName),
    (Dom.img()..alt = uniqueName)(),
    (Dom.label()..htmlFor = '${uniqueName}Input')(uniqueName),
    (Dom.input()
      ..type = 'text'
      ..id = '${uniqueName}Input'
      ..value = uniqueName
      ..onChange = (_) {}
      ..placeholder = uniqueName)(),
    Dom.div()(
      Dom.div()('bar 1'),
      '$uniqueName foo',
    ),
    Dom.div()(
      Dom.div()('bar 2'),
      '$uniqueName baz',
    ),
  );
}

mixin DelayedRenderOfProps on UiProps {
  Duration delay;
  Function() onDidRenderAfterDelay;
}

/// Used to test findBy* queries and `waitFor`.
UiFactory<DelayedRenderOfProps> DelayedRenderOf = uiFunction(
  (props) {
    final delay = props.delay ?? asyncQueryTimeout;
    final shouldRenderChildren = useState(delay.inMilliseconds == 0 ? true : false);

    useEffect(() {
      final timer = Timer(delay, () {
        shouldRenderChildren.set(true);
      });

      return timer.cancel;
    }, const []);

    useEffect(() {
      if (shouldRenderChildren.value) {
        props.onDidRenderAfterDelay?.call();
      }
    }, [shouldRenderChildren.value]);

    dynamic _renderChildren() {
      if (!shouldRenderChildren.value) return null;

      return props.children;
    }

    return (Dom.div()
      ..addTestId('delayed-render-of-root')
      ..addUnconsumedDomProps(props, const [])
    )(
      _renderChildren(),
    );
  },
  _$DelayedRenderOfConfig, // ignore: undefined_identifier
);
