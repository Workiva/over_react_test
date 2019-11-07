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

import 'dart:async';

import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

import './helper_components/sample_component.dart';
import './helper_components/sample_component2.dart';

main() {
  group('recordConsoleLogs', () {
    group('captures errors correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(
            (Sample()..shouldAlwaysBeFalse = true)()
        ));

        expect(logs.length, 2);
        expect(logs.firstWhere((log) => log.contains('shouldAlwaysBeFalse')), contains('set to true'));
      });

      test('when re-rendering', () {
        // Will cause one error
        var jacket = mount((Sample()..shouldAlwaysBeFalse = true)());

        // Should clear the error from mounting and not create any more
        var logs = recordConsoleLogs(() => jacket.rerender((Sample()..shouldNeverBeNull = true)()));

        expect(logs.length, 0);
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())));

        expect(logs.length, 2);
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())));

        expect(logs.length, 1, reason: 'React will only show a particular props error once');
      });
    });

    group('captures logs correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(Sample()()), logConfig);

        expect(logs.length, 1);
      });

      test('when re-rendering', () {
        // Will cause one log
        var jacket = mount(Sample()());

        // Should clear the previous log and result in there being two
        var logs = recordConsoleLogs(() => jacket.rerender((Sample()..addExtraLogAndWarn = true)()), logConfig);

        expect(logs.length, 2);
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())), logConfig);

        expect(logs.length, 2);
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())), logConfig);

        expect(logs.length, 2);
      });
    });

    group('captures warnings correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(Sample()()), warnConfig);

        expect(logs.length, 3);
      });

      test('when re-rendering', () {
        // Will three warnings
        var jacket = mount(Sample()());

        // Should clear the previous warnings and result in there being 3
        var logs = recordConsoleLogs(() => jacket.rerender((Sample()..addExtraLogAndWarn = true)()), warnConfig);

        expect(logs.length, 3);
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())), warnConfig);

        expect(logs.length, 6);
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())), warnConfig);

        expect(logs.length, 6);
      });
    });

    group('handles errors as expected', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(
            (Sample()..shouldError = true)()
        ));

        expect(logs.length, 2);
      });
    });
  });

  group('recordConsoleLogsAsync', () {
    test('handles document events', () async {
      var jacket = mount(Sample()(), attachedToDocument: true);
      var logs = await recordConsoleLogsAsync(() async {
        var button = queryByTestId(jacket.getInstance(), 'ort_sample_component_button');
        await Future.delayed(Duration(milliseconds: 5));

        triggerDocumentClick(button);
      }, warnConfig);

      expect(logs.length, 1);
      expect(logs.first.contains('I have been clicked'), isTrue);
    });

    test('handles errors caused when rendering', () async {
      var logs = await recordConsoleLogsAsync(() async {
        await Future.delayed(Duration(milliseconds: 5));

        mount((Sample()
          ..shouldAlwaysBeFalse = true
          ..shouldError = true
        )(), attachedToDocument: true);
      });

      expect(logs.length, 3);
    });

    test('handles errors caused when re-rendering', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample()..shouldAlwaysBeFalse = true)(), attachedToDocument: true);

        await Future.delayed(Duration(milliseconds: 5));

        jacket.rerender((Sample()
          ..shouldError = true
          ..shouldAlwaysBeFalse = true
        )());
      });

      expect(logs.length, 3);
    });

    test('handles re-renders when the mount is outside of the function', () async {
      var jacket = mount((Sample())(), attachedToDocument: true);

      var logs = await recordConsoleLogsAsync(() async {
        await Future.delayed(Duration(milliseconds: 5));

        jacket.rerender((Sample()
          ..shouldAlwaysBeFalse = true
        )());
      });

      expect(logs.length, 2);
    });

    test('handles re-renders when the mount is inside of the function', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample())(), attachedToDocument: true);

        await Future.delayed(Duration(milliseconds: 5));

        jacket.rerender((Sample()
          ..shouldAlwaysBeFalse = true
          ..shouldNeverBeNull = false
        )());
      });

      expect(logs.length, 2);
    });

    test('captures logs', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample()..addExtraLogAndWarn = true)(), attachedToDocument: true);
        var button = queryByTestId(jacket.getInstance(), 'ort_sample_component_button');
        await Future.delayed(Duration(milliseconds: 5));

        triggerDocumentClick(button);
      }, logConfig);

      expect(logs.length, 3);
    });

    test('captures warns', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample()..addExtraLogAndWarn = true)(), attachedToDocument: true);
        var button = queryByTestId(jacket.getInstance(), 'ort_sample_component_button');
        await Future.delayed(Duration(milliseconds: 5));

        triggerDocumentClick(button);
      }, warnConfig);

      expect(logs.length, 5);
    });
  });
}
