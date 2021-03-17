// @dart = 2.7

@TestOn('browser')
library over_react_test.testing_library_test.dom.top_level_queries_test;

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:over_react_test/src/testing_library/dom/config/configure.dart';
import 'package:test/test.dart';

import '../util/constants.dart';
import '../util/matchers.dart';
import '../util/rendering.dart';
import 'queries/shared/text_match_type_parsing_tests.dart';

main() {
  group('top level API', () {
    test('exposes all the expected queries', () {
      expect(rtl.getByAltText, isA<Function>(), reason: 'getByAltText');
      expect(rtl.getAllByAltText, isA<Function>(), reason: 'getAllByAltText');
      expect(rtl.queryByAltText, isA<Function>(), reason: 'queryByAltText');
      expect(rtl.queryAllByAltText, isA<Function>(), reason: 'queryAllByAltText');
      expect(rtl.findByAltText, isA<Function>(), reason: 'findByAltText');
      expect(rtl.findAllByAltText, isA<Function>(), reason: 'findAllByAltText');
      expect(rtl.getByDisplayValue, isA<Function>(), reason: 'getByDisplayValue');
      expect(rtl.getAllByDisplayValue, isA<Function>(), reason: 'getAllByDisplayValue');
      expect(rtl.queryByDisplayValue, isA<Function>(), reason: 'queryByDisplayValue');
      expect(rtl.queryAllByDisplayValue, isA<Function>(), reason: 'queryAllByDisplayValue');
      expect(rtl.findByDisplayValue, isA<Function>(), reason: 'findByDisplayValue');
      expect(rtl.findAllByDisplayValue, isA<Function>(), reason: 'findAllByDisplayValue');
      expect(rtl.getByLabelText, isA<Function>(), reason: 'getByLabelText');
      expect(rtl.getAllByLabelText, isA<Function>(), reason: 'getAllByLabelText');
      expect(rtl.queryByLabelText, isA<Function>(), reason: 'queryByLabelText');
      expect(rtl.queryAllByLabelText, isA<Function>(), reason: 'queryAllByLabelText');
      expect(rtl.findByLabelText, isA<Function>(), reason: 'findByLabelText');
      expect(rtl.findAllByLabelText, isA<Function>(), reason: 'findAllByLabelText');
      expect(rtl.getByPlaceholderText, isA<Function>(), reason: 'getByPlaceholderText');
      expect(rtl.getAllByPlaceholderText, isA<Function>(), reason: 'getAllByPlaceholderText');
      expect(rtl.queryByPlaceholderText, isA<Function>(), reason: 'queryByPlaceholderText');
      expect(rtl.queryAllByPlaceholderText, isA<Function>(), reason: 'queryAllByPlaceholderText');
      expect(rtl.findByPlaceholderText, isA<Function>(), reason: 'findByPlaceholderText');
      expect(rtl.findAllByPlaceholderText, isA<Function>(), reason: 'findAllByPlaceholderText');
      expect(rtl.getByRole, isA<Function>(), reason: 'getByRole');
      expect(rtl.getAllByRole, isA<Function>(), reason: 'getAllByRole');
      expect(rtl.queryByRole, isA<Function>(), reason: 'queryByRole');
      expect(rtl.queryAllByRole, isA<Function>(), reason: 'queryAllByRole');
      expect(rtl.findByRole, isA<Function>(), reason: 'findByRole');
      expect(rtl.findAllByRole, isA<Function>(), reason: 'findAllByRole');
      expect(rtl.getByTestId, isA<Function>(), reason: 'getByTestId');
      expect(rtl.getAllByTestId, isA<Function>(), reason: 'getAllByTestId');
      expect(rtl.queryByTestId, isA<Function>(), reason: 'queryByTestId');
      expect(rtl.queryAllByTestId, isA<Function>(), reason: 'queryAllByTestId');
      expect(rtl.findByTestId, isA<Function>(), reason: 'findByTestId');
      expect(rtl.findAllByTestId, isA<Function>(), reason: 'findAllByTestId');
      expect(rtl.getByText, isA<Function>(), reason: 'getByText');
      expect(rtl.getAllByText, isA<Function>(), reason: 'getAllByText');
      expect(rtl.queryByText, isA<Function>(), reason: 'queryByText');
      expect(rtl.queryAllByText, isA<Function>(), reason: 'queryAllByText');
      expect(rtl.findByText, isA<Function>(), reason: 'findByText');
      expect(rtl.findAllByText, isA<Function>(), reason: 'findAllByText');
      expect(rtl.getByTitle, isA<Function>(), reason: 'getByTitle');
      expect(rtl.getAllByTitle, isA<Function>(), reason: 'getAllByTitle');
      expect(rtl.queryByTitle, isA<Function>(), reason: 'queryByTitle');
      expect(rtl.queryAllByTitle, isA<Function>(), reason: 'queryAllByTitle');
      expect(rtl.findByTitle, isA<Function>(), reason: 'findByTitle');
      expect(rtl.findAllByTitle, isA<Function>(), reason: 'findAllByTitle');
    });

    group('contains queries that can be scoped to the specified container', () {
      const scopeName = 'top level';
      Element container;
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
        rtl.configure(
          throwSuggestions: false,
          asyncUtilTimeout: asyncQueryTimeout.inMilliseconds,
        );
        expect(document.body.children, isEmpty);
      });

      tearDown(() {
        container = null;
      });

      Function _renderForQuery(
        Function query, {
        bool testAsyncQuery = false,
        bool renderMultipleElsMatchingQuery,
      }) {
        final elsForQuerying =
            elementsForQuerying(scopeName, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery);
        final els = testAsyncQuery ? DelayedRenderOf()(elsForQuerying) : elsForQuerying;
        final renderResult = rtl.render(els);
        container = renderResult.container;
        expectedPrettyDom = rtl.prettyDOM(container);

        if (testAsyncQuery) {
          final delayedRenderOfRootNode = querySelector('[$defaultTestIdKey="delayed-render-of-root"]');
          expect(delayedRenderOfRootNode, isNotNull,
              reason:
                  'Async queries should be tested on DOM wrapped by / controlled by the DelayedRenderOf component.');
          expect(delayedRenderOfRootNode.children, isEmpty,
              reason: 'Async queries should be tested with DOM that appears only after the query is called.');

          // If we're testing an async query, we'll set expectedPrettyDom using the
          // DelayedRenderOf wrapper that async tests use, but with the `delay` hardcoded
          // to zero so we can see what DOM to expect when the future completes in the
          // actual query test.
          final tempRenderResult = rtl.render(
              cloneElement(renderResult.renderedElement, DelayedRenderOf()..delay = Duration.zero),
              autoTearDown: false);
          expectedPrettyDom = rtl.prettyDOM(tempRenderResult.container);
          tempRenderResult.unmount();
          tempRenderResult.container?.remove();
        }

        return query;
      }

      testTextMatchTypes<ImageElement>(
        'AltText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByAltText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByAltText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByAltText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByAltText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByAltText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByAltText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByAltText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByAltText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByAltText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByAltText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByAltText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByAltText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'alt text: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'DisplayValue',
        textMatchArgName: 'value',
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByDisplayValue': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByDisplayValue, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByDisplayValue': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(
              rtl.queryAllByDisplayValue,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByDisplayValue': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByDisplayValue, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByDisplayValue': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByDisplayValue, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByDisplayValue': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByDisplayValue,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByDisplayValue': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByDisplayValue,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'display value: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'LabelText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByLabelText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByLabelText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByLabelText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByLabelText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByLabelText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByLabelText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByLabelText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByLabelText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByLabelText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByLabelText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByLabelText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByLabelText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'label with the text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'PlaceholderText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByPlaceholderText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(
              rtl.queryByPlaceholderText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByPlaceholderText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(
              rtl.queryAllByPlaceholderText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByPlaceholderText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByPlaceholderText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByPlaceholderText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(
              rtl.getAllByPlaceholderText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByPlaceholderText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByPlaceholderText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByPlaceholderText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(
              rtl.findAllByPlaceholderText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery,
              testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'placeholder text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'role',
        textMatchArgSupportsFuzzyMatching: false, // exact = false is not supported by role queries
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByRole': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByRole,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByRole': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByRole,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'with the role "$valueNotFoundPlaceholder"',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'name',
        textMatchArgSupportsFuzzyMatching: false, // exact = false is not supported by role queries
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByRole': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByRole, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByRole': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByRole,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByRole': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByRole,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'with the role "$validRoleInDom" and name "$valueNotFoundPlaceholder"',
      );

      testTextMatchTypes(
        'TestId',
        textMatchArgName: 'testId',
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByTestId': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByTestId, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByTestId': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByTestId, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByTestId': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByTestId, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByTestId': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByTestId, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByTestId': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByTestId,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByTestId': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByTestId,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'an element by: [data-test-id="$valueNotFoundPlaceholder"]',
      );

      testTextMatchTypes(
        'Text',
        textMatchArgName: 'text',
        queryShouldMatchOn: '$scopeName single byText match',
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByText': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByText, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByText': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByText,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'an element with the text: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'Title',
        textMatchArgName: 'title',
        queryShouldMatchOn: scopeName,
        getContainerForTopLevelQueries: () => container,
        topLevelQueryQueriesByName: {
          'queryByTitle': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryByTitle, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'queryAllByTitle': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.queryAllByTitle, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelGetQueriesByName: {
          'getByTitle': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getByTitle, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
          'getAllByTitle': ({bool renderMultipleElsMatchingQuery}) =>
              _renderForQuery(rtl.getAllByTitle, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery),
        },
        topLevelFindQueriesByName: {
          'findByTitle': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findByTitle,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
          'findAllByTitle': ({bool renderMultipleElsMatchingQuery}) => _renderForQuery(rtl.findAllByTitle,
              renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery, testAsyncQuery: true),
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'title: $valueNotFoundPlaceholder',
      );
    });
  });
}
