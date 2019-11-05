// Copyright 2019 Workiva Inc.
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
import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

import './helper_components/sample_component.dart';

main() {
  group('recordConsoleLogs', () {
    test('captures errors correctly', () {
      var logs = recordConsoleLogs(() => mount(
          (Sample()..shouldAlwaysBeFalse = true)()
      ), errorConfig);

      expect(logs.length, 2);
    });

    test('captures logs correctly', () {
      var logs = recordConsoleLogs(() => mount(Sample()()), logConfig);

      expect(logs.length, 1);
    });

    test('captures warnings correctly', () {
      var logs = recordConsoleLogs(() => mount(Sample()()), warnConfig);

      expect(logs.length, 3);
    });

    test('swallows errors as expected', () {
      var logs = recordConsoleLogs(() => mount(
          (Sample()..shouldError=true)()
      ));

      expect(logs.length, 3);
    });
  });
}
