// ignore_for_file: invalid_use_of_protected_member, await_only_futures
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show JsConfig, jsConfigure;
import 'package:over_react_test/src/testing_library/dom/pretty_dom.dart' show prettyDOM;
import 'package:over_react_test/src/testing_library/dom/scoped_queries.dart' show ScopedQueries;

import '../../../util/constants.dart';
import '../../../util/matchers.dart';
import '../../../util/rendering.dart';
import 'text_match_type_parsing_tests.dart';

@isTestGroup
void hasQueriesScopedTo(
  String scopeName,
  ScopedQueries Function(String scopeName, {bool testAsyncQuery}) getQueries, {
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

    ScopedQueries renderAndGetQueries({bool testAsyncQuery = false}) {
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
        final tempRenderResult = rtl.render(
            cloneElement(renderResult.renderedElement, DelayedRenderOf()..delay = Duration.zero),
            autoTearDown: false);
        expectedPrettyDom = prettyDOM(tempRenderResult.container);
        tempRenderResult.unmount();
        tempRenderResult.container?.remove();
      }

      return queries;
    }

    test('exposes all the expected queries', () {
      queries = renderAndGetQueries();

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
      testTextMatchTypes<ImageElement>(
        'AltText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        queryQueriesByName: {
          'queryByAltText': () => renderAndGetQueries().queryByAltText,
          'queryAllByAltText': () => renderAndGetQueries().queryAllByAltText,
        },
        getQueriesByName: {
          'getByAltText': () => renderAndGetQueries().getByAltText,
          'getAllByAltText': () => renderAndGetQueries().getAllByAltText,
        },
        findQueriesByName: {
          'findByAltText': () => renderAndGetQueries(testAsyncQuery: true).findByAltText,
          'findAllByAltText': () => renderAndGetQueries(testAsyncQuery: true).findAllByAltText,
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'alt text: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'DisplayValue',
        textMatchArgName: 'value',
        queryShouldMatchOn: scopeName,
        queryQueriesByName: {
          'queryByDisplayValue': () => renderAndGetQueries().queryByDisplayValue,
          'queryAllByDisplayValue': () => renderAndGetQueries().queryAllByDisplayValue,
        },
        getQueriesByName: {
          'getByDisplayValue': () => renderAndGetQueries().getByDisplayValue,
          'getAllByDisplayValue': () => renderAndGetQueries().getAllByDisplayValue,
        },
        findQueriesByName: {
          'findByDisplayValue': () => renderAndGetQueries(testAsyncQuery: true).findByDisplayValue,
          'findAllByDisplayValue': () => renderAndGetQueries(testAsyncQuery: true).findAllByDisplayValue,
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'display value: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'LabelText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        queryQueriesByName: {
          'queryByLabelText': () => renderAndGetQueries().queryByLabelText,
          'queryAllByLabelText': () => renderAndGetQueries().queryAllByLabelText,
        },
        getQueriesByName: {
          'getByLabelText': () => renderAndGetQueries().getByLabelText,
          'getAllByLabelText': () => renderAndGetQueries().getAllByLabelText,
        },
        findQueriesByName: {
          'findByLabelText': () => renderAndGetQueries(testAsyncQuery: true).findByLabelText,
          'findAllByLabelText': () => renderAndGetQueries(testAsyncQuery: true).findAllByLabelText,
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'label with the text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'PlaceholderText',
        textMatchArgName: 'text',
        queryShouldMatchOn: scopeName,
        queryQueriesByName: {
          'queryByPlaceholderText': () => renderAndGetQueries().queryByPlaceholderText,
          'queryAllByPlaceholderText': () => renderAndGetQueries().queryAllByPlaceholderText,
        },
        getQueriesByName: {
          'getByPlaceholderText': () => renderAndGetQueries().getByPlaceholderText,
          'getAllByPlaceholderText': () => renderAndGetQueries().getAllByPlaceholderText,
        },
        findQueriesByName: {
          'findByPlaceholderText': () => renderAndGetQueries(testAsyncQuery: true).findByPlaceholderText,
          'findAllByPlaceholderText': () => renderAndGetQueries(testAsyncQuery: true).findAllByPlaceholderText,
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'placeholder text of: $valueNotFoundPlaceholder',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'role',
        textMatchArgSupportsFuzzyMatching: false, // exact = false is not supported by role queries
        queryShouldMatchOn: scopeName,
        queryQueriesByName: {
          'queryByRole': () => renderAndGetQueries().queryByRole,
          'queryAllByRole': () => renderAndGetQueries().queryAllByRole,
        },
        getQueriesByName: {
          'getByRole': () => renderAndGetQueries().getByRole,
          'getAllByRole': () => renderAndGetQueries().getAllByRole,
        },
        findQueriesByName: {
          'findByRole': () => renderAndGetQueries(testAsyncQuery: true).findByRole,
          'findAllByRole': () => renderAndGetQueries(testAsyncQuery: true).findAllByRole,
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'with the role "$valueNotFoundPlaceholder"',
      );

      testTextMatchTypes(
        'Role',
        textMatchArgName: 'name',
        textMatchArgSupportsFuzzyMatching: false, // exact = false is not supported by role queries
        queryShouldMatchOn: scopeName,
        queryQueriesByName: {
          'queryByRole': () => renderAndGetQueries().queryByRole,
          'queryAllByRole': () => renderAndGetQueries().queryAllByRole,
        },
        getQueriesByName: {
          'getByRole': () => renderAndGetQueries().getByRole,
          'getAllByRole': () => renderAndGetQueries().getAllByRole,
        },
        findQueriesByName: {
          'findByRole': () => renderAndGetQueries(testAsyncQuery: true).findByRole,
          'findAllByRole': () => renderAndGetQueries(testAsyncQuery: true).findAllByRole,
        },
        getExpectedPrettyDom: () => expectedPrettyDom,
        failureSnapshotPattern: 'with the role "$validRoleInDom" and name "$valueNotFoundPlaceholder"',
      );
    });

    test('limiting the scope of the query as expected', () {
      final outOfScopeElement = DivElement()..text = 'out-of-scope';
      document.body.append(outOfScopeElement);

      queries = renderAndGetQueries();
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
