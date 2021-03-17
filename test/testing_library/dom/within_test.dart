// @dart = 2.7

@TestOn('browser')
library over_react_test.testing_library_test.dom.within_test;

import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:test/test.dart';

import '../dom/queries/shared/scoped_queries_tests.dart';
import '../util/rendering.dart';

main() {
  group('within(<container>)', () {
    group('returns an object with queries scoped to', () {
      hasQueriesScopedTo('<container>', (
        scopeName, {
        bool testAsyncQuery = false,
        bool renderMultipleElsMatchingQuery,
      }) {
        final elsForQuerying =
            elementsForQuerying(scopeName, renderMultipleElsMatchingQuery: renderMultipleElsMatchingQuery);
        final els = testAsyncQuery ? DelayedRenderOf()(elsForQuerying) : elsForQuerying;
        final _renderResult = rtl.render(els);
        final queries = rtl.within(_renderResult.container);
        return ScopedQueriesTestWrapper(queries, _renderResult);
      });
    });
  });
}
