// ignore_for_file: invalid_use_of_protected_member
import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/scoped_queries.dart';

part 'shared_scoped_queries_tests.over_react.g.dart';

@isTestGroup
void hasQueriesScopedTo(String scopeName, ScopedQueries Function(String scopeName) getQueries) {
  group('$scopeName:', () {
    ScopedQueries queries;

    setUp(() {
      rtl.configure(throwSuggestions: false);
      queries = getQueries(scopeName);

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

    group('getBy/queryByAltText', () {
      testTextMatchTypesForArg('text', scopeName, () => getQueries(scopeName).getByAltText);
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
    //       rtl.render((DelayedDomNodeAppearance()..delayHiddenNodeRenderFor = testDelay)());
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

    test('', () {
      final outOfScopeElement = DivElement()..text = 'out-of-scope';
      document.body.append(outOfScopeElement);

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

@isTestGroup
void testTextMatchTypesForArg(String argName, String expectedText, Function Function() getQuery) {
  group('when $argName is a', () {
    String fuzzyText = expectedText.substring(2);

    group('String (TextMatch.parse)', () {
      group('and exact = true (default)', () {
        test('[failure]', () {
          // TODO: Assert the test failure message
          expect(() => getQuery()(fuzzyText), throwsA(anything));
        });

        test('[success]', () {
          getQuery()(expectedText);
        });
      });

      group('and exact = false', () {
        test('[failure]', () {
          // TODO: Assert the test failure message
          expect(() => getQuery()('somethingDifferentThatDoesNotMatch'), throwsA(anything));
        });

        test('[success]', () {
          getQuery()(expectedText, exact: false);
        });
      });
    });

    group('RegExp (TextMatch.parse)', () {
      test('[failure]', () {
        // TODO: Assert the test failure message
        expect(() => getQuery()(RegExp("^somethingDifferentThatDoesNotMatch\$")), throwsA(anything));
      });

      test('[success]', () {
        getQuery()(RegExp("^$expectedText\$"));
      });
    });

    group('Function (TextMatch.parse)', () {
      test('[failure]', () {
        // TODO: Assert the test failure message
        expect(() => getQuery()((content, el) => content != expectedText), throwsA(anything));
      });

      test('[success]', () {
        getQuery()((content, el) => content == expectedText);
      });
    });
  });
}

ReactElement renderElementsForQuerying(String uniqueName) {
  return (Dom.div()
    ..['data-testid'] = uniqueName
    ..title = uniqueName
    ..role = Role.presentation)(
    uniqueName,
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
