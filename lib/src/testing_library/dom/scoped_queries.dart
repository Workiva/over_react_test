import 'dart:html' show Element;

import 'package:meta/meta.dart';
import 'package:over_react_test/src/testing_library/dom/queries/by_alt_text.dart' show ByAltTextQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_display_value.dart' show ByDisplayValueQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_label_text.dart' show ByLabelTextQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_placeholder_text.dart' show ByPlaceholderTextQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_role.dart' show ByRoleQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_testid.dart' show ByTestIdQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_text.dart' show ByTextQueries;
import 'package:over_react_test/src/testing_library/dom/queries/by_title.dart' show ByTitleQueries;
import 'package:over_react_test/src/testing_library/dom/queries/interface.dart' show IQueries;

/// PRIVATE. DO NOT EXPORT.
///
/// Only visible for the purposes of extension by specific
/// querying objects like `RenderResult` and `_WithinQueries`.
abstract class ScopedQueries
    with
        IQueries,
        ByAltTextQueries,
        ByDisplayValueQueries,
        ByLabelTextQueries,
        ByPlaceholderTextQueries,
        ByRoleQueries,
        ByTestIdQueries,
        ByTextQueries,
        ByTitleQueries {
  ScopedQueries(this.getContainerForScope);

  @protected
  @override
  final Element Function() getContainerForScope;
}
