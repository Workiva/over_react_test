// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@TestOn('browser')
library test_util_test;

import 'package:over_react/over_react.dart';
import 'package:react/react_client.dart';
import 'package:test/test.dart';

import 'over_react_test/common_component_util_test.dart' as common_component_util_test;
import 'over_react_test/custom_matchers_test.dart' as custom_matchers_test;
import 'over_react_test/dom_util_test.dart' as test_util_dom_util_test;
import 'over_react_test/jacket_test.dart' as jacket_test;
import 'over_react_test/prop_type_utils_test.dart' as prop_type_utils_test;
import 'over_react_test/react_util_test.dart' as react_util_test;
import 'over_react_test/validation_util_test.dart' as validation_util_test;

main() {
  setClientConfiguration();

  enableTestMode();

  common_component_util_test.main();
  custom_matchers_test.main();
  test_util_dom_util_test.main();
  jacket_test.main();
  prop_type_utils_test.main();
  react_util_test.main();
  validation_util_test.main();
}
