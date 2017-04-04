@TestOn('browser')
library test_util_test;

import 'package:over_react/over_react.dart';
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'test_util_tests/custom_matchers_test.dart' as custom_matchers_test;
import 'test_util_tests/dom_util_test.dart' as test_util_dom_util_test;
import 'test_util_tests/react_util_test.dart' as react_util_test;
import 'test_util_tests/string_util_test.dart' as string_util_test;

main() {
  setClientConfiguration();

  enableTestMode();

  custom_matchers_test.main();
  test_util_dom_util_test.main();
  react_util_test.main();
  string_util_test.main();
}
