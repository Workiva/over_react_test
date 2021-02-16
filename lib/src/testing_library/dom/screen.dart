import 'dart:html' show document;

import 'package:over_react_test/src/testing_library/dom/within.dart' show within;

/// Exposes all the "top-level" queries exposed by the dom-testing-library,
/// but the scope/container is defaulted to `document.body`.
///
/// > See: <https://testing-library.com/docs/queries/about/#screen>
final screen = within(document.body);
