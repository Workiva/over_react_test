// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show JsConfig, jsConfigure;
import 'package:over_react_test/src/testing_library/dom/matches/types.dart' show TextMatch;
import 'package:over_react_test/src/testing_library/dom/scoped_queries.dart' show ScopedQueries;

import '../../util/matchers.dart';

part 'shared_scoped_queries_tests.over_react.g.dart';

const asyncQueryTimeout = Duration(milliseconds: 100);

@isTestGroup
void hasQueriesScopedTo(String scopeName, ScopedQueries Function(String scopeName, {bool testAsyncQuery}) getQueries, {
  // Optional because in the case of RenderResult, calling `getQueries` will render AND return the ScopedQueries object.
  rtl.RenderResult Function({bool testAsyncQuery}) render,
}) {
  group('$scopeName:', () {
    ScopedQueries queries;
    JsConfig initialConfig;

    setUpAll(() {
      initialConfig = rtl.getConfig();
    });

    tearDownAll(() {
      jsConfigure(initialConfig);
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
      if (queries != null) return queries;

      queries = getQueries(scopeName, testAsyncQuery: testAsyncQuery);
      if (queries is! rtl.RenderResult) {
        if (render == null) {
          throw ArgumentError('When getQueries() does not return a RenderResult, the render argument must do so.');
        }

        render(testAsyncQuery: testAsyncQuery);
      }

      if (testAsyncQuery) {
        final delayedRenderOfRootNode = querySelector('[$defaultTestIdKey="delayed-render-of-root"]');
        expect(delayedRenderOfRootNode, isNotNull,
            reason: 'Async queries should be tested on DOM wrapped by / controlled by the DelayedRenderOf component.');
        expect(delayedRenderOfRootNode.children, isEmpty,
            reason: 'Async queries should be tested with DOM that appears only after the query is called.');
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
        failureSnapshotPattern: 'alt text: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'DisplayValue',
        textMatchArgName: 'value',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByDisplayValue,
        getGetByQuery: () => initQueries().getByDisplayValue,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByDisplayValue,
        failureSnapshotPattern: 'display value: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'LabelText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByLabelText,
        getGetByQuery: () => initQueries().getByLabelText,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByLabelText,
        failureSnapshotPattern: 'label with the text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'PlaceholderText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getQueryByQuery: () => initQueries().queryByPlaceholderText,
        getGetByQuery: () => initQueries().getByPlaceholderText,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByPlaceholderText,
        failureSnapshotPattern: 'placeholder text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'role',
        queryShouldMatchOn: 'button',
        getQueryByQuery: () => initQueries().queryByRole,
        getGetByQuery: () => initQueries().getByRole,
        getFindByQuery: () => initQueries(testAsyncQuery: true).findByRole,
        failureSnapshotPattern: 'accessible element with role="$valueNotFoundPlaceholder"',
        fuzzyFailureSnapshotPattern: 'accessible element with the role $valueNotFoundPlaceholder',
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
  String failureSnapshotPattern,
      String fuzzyFailureSnapshotPattern,
}) {
  fuzzyFailureSnapshotPattern ??= failureSnapshotPattern;

  Matcher toThrowErrorMatchingInlineSnapshotPattern(String valueExpectedButNotFound, {bool fuzzyMatch = false}) {
    Matcher containsMatcher;
    if (failureSnapshotPattern != null) {
      containsMatcher = buildContainsPatternUsing(fuzzyMatch ? fuzzyFailureSnapshotPattern : failureSnapshotPattern, valueExpectedButNotFound);
    } else {
      containsMatcher = contains(valueExpectedButNotFound);
    }

    return toThrowErrorMatchingInlineSnapshot(containsMatcher);
  }

  group('when the $textMatchArgName argument is a', () {
    group('String (TextMatch.parse)', () {
      String fuzzyText = getStringThatFuzzyMatches(queryShouldMatchOn);

      group('and exact = true (default),', () {
        group('and a failure/null return value is expected for the', () {
          test('queryBy$queryName query', () {
            expect(getQueryByQuery()(fuzzyText), isNull);
          });

          test('getBy$queryName query', () {
            expect(() => getGetByQuery()(fuzzyText), toThrowErrorMatchingInlineSnapshotPattern(fuzzyText, fuzzyMatch: true));
          });

          test('findBy$queryName query', () async {
            expect(() async => await getFindByQuery()(fuzzyText), toThrowErrorMatchingInlineSnapshotPattern(fuzzyText, fuzzyMatch: true));
          });
        });

        group('returning the matching element from the', () {
          test('queryBy$queryName query', () {
            expect(getQueryByQuery()(queryShouldMatchOn), isA<Element>());
          });

          test('getBy$queryName query', () {
            expect(getGetByQuery()(queryShouldMatchOn), isA<Element>());
          });

          test('findBy$queryName query', () async {
            final findByQueryReturnValue = await getFindByQuery()(queryShouldMatchOn);
            expect(findByQueryReturnValue, isA<Element>());
          });
        });
      });

      group('and exact = false,', () {
        group('and a failure/null return value is expected when calling the', () {
          test('queryBy$queryName query', () {
            expect(getQueryByQuery()('somethingDifferentThatDoesNotMatch', exact: false), isNull);
          });

          test('getBy$queryName query', () {
            expect(() => getGetByQuery()('somethingDifferentThatDoesNotMatch', exact: false),
                toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch', fuzzyMatch: true));
          });

          test('findBy$queryName query', () {
            expect(() async => await getFindByQuery()('somethingDifferentThatDoesNotMatch', exact: false),
                toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch', fuzzyMatch: true));
          });
        });

        group('and a match is found when calling the', () {
          test('queryBy$queryName query', () {
            expect(getQueryByQuery()(fuzzyText, exact: false), isA<Element>());
          });

          test('getBy$queryName query', () {
            expect(getGetByQuery()(fuzzyText, exact: false), isA<Element>());
          });

          test('findBy$queryName query', () async {
            final findByQueryReturnValue = await getFindByQuery()(fuzzyText, exact: false);
            expect(findByQueryReturnValue, isA<Element>());
          });
        });
      });

      group('and normalizer is customized', () {
        // TODO
      });
    });

    group('RegExp (TextMatch.parse),', () {
      const regExPattern = "^somethingDifferentThatDoesNotMatch\$";

      group('and a failure/null return value is expected for the', () {
        test('queryBy$queryName query', () {
          expect(getQueryByQuery()(RegExp(regExPattern)), isNull);
        });

        test('getBy$queryName query', () {
          expect(() => getGetByQuery()(RegExp(regExPattern)),
              toThrowErrorMatchingInlineSnapshotPattern('RegExp/$regExPattern/'));
        });

        test('findBy$queryName query', () async {
          // TODO: Something is making the custom error message for async queries get duplicate "prettyDOM" appended. Seems like a race condition.
          expect(() async => await getFindByQuery()(RegExp(regExPattern)),
              toThrowErrorMatchingInlineSnapshotPattern('RegExp/$regExPattern/'));
        });
      });

      group('returning the matching element from the', () {
        test('queryBy$queryName query', () {
          expect(getQueryByQuery()(RegExp("^$queryShouldMatchOn\$")), isA<Element>());
        });

        test('getBy$queryName query', () {
          expect(getGetByQuery()(RegExp("^$queryShouldMatchOn\$")), isA<Element>());
        });

        test('findBy$queryName query', () async {
          final findByQueryReturnValue = await getFindByQuery()(RegExp("^$queryShouldMatchOn\$"));
          expect(findByQueryReturnValue, isA<Element>());
        });
      });
    });

    group('Function (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        test('queryBy$queryName query', () {
          expect(getQueryByQuery()((content, el) => content != queryShouldMatchOn), isNull);
        });

        test('getBy$queryName query', () {
          expect(() => getGetByQuery()((content, el) => content != queryShouldMatchOn),
              toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
        });

        test('findBy$queryName query', () async {
          expect(() async => await getFindByQuery()((content, el) => content != queryShouldMatchOn),
              toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
        });
      });

      group('returning the matching element from the', () {
        test('queryBy$queryName query', () {
          expect(getQueryByQuery()((content, el) => content == queryShouldMatchOn), isA<Element>());
        });

        test('getBy$queryName query', () {
          expect(getGetByQuery()((content, el) => content == queryShouldMatchOn), isA<Element>());
        });

        test('findBy$queryName query', () async {
          final findByQueryReturnValue = await getFindByQuery()((content, el) => content == queryShouldMatchOn);
          expect(findByQueryReturnValue, isA<Element>());
        });
      });
    });
  });
}

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
