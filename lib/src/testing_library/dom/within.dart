// @dart = 2.7

import 'dart:html' show document, Element;

import 'package:over_react/over_react.dart';
import 'package:over_react_test/src/testing_library/dom/scoped_queries.dart' show ScopedQueries;
import 'package:test/test.dart' show addTearDown, expect, isNotNull, isTrue;

/// Queries scoped to the provided [container].
class _WithinQueries extends ScopedQueries {
  _WithinQueries(this.container) : super(() => container);

  final Element container;
}

/// Takes a DOM [element] and binds it to the raw query functions.
///
/// > See: <https://testing-library.com/docs/dom-testing-library/api-within>
_WithinQueries within(Element element) {
  expect(element, isNotNull, reason: 'You must provide a non-null element as the single argument to within().');
  expect(isOrContains(document.body, element), isTrue,
      reason:
          'The element you provide as the single argument to within() must exist in the DOM. Did you forget to append the element to the body?');

  var withinQueriesInstance = _WithinQueries(element);
  addTearDown(() {
    withinQueriesInstance = null;
  });

  return withinQueriesInstance;
}
