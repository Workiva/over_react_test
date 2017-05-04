@TestOn('browser')
library test_util_test;

import 'package:over_react/over_react.dart';
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'over_react_test/custom_matchers_test.dart' as custom_matchers_test;
import 'over_react_test/dom_util_test.dart' as test_util_dom_util_test;
import 'over_react_test/jacket_test.dart' as jacket_test;
import 'over_react_test/react_util_test.dart' as react_util_test;

main() {
  setClientConfiguration();

  enableTestMode();

  custom_matchers_test.main();
  test_util_dom_util_test.main();
  jacket_test.main();
  react_util_test.main();
}
