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
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import './helper_components/sample_component.dart';
import './helper_components/sample_component2.dart';

main() {
  group('recordConsoleLogs', () {
    group('captures all logs correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(Sample()()));
        expect(
            logs,
            unorderedEquals([
              contains('SampleProps.shouldNeverBeNull is required.'),
              contains('Logging a standard log'),
              contains('A second warning'),
              contains('And a third'),
              contains('Just a lil warning'),
            ]));
      });

      test('when re-rendering', () {
        var jacket = mount((Sample()..shouldAlwaysBeFalse = true)());

        var logs = recordConsoleLogs(() => jacket.rerender(Sample()()));

        expect(
            logs,
            unorderedEquals([
              contains('SampleProps.shouldNeverBeNull is required.'),
              contains('Logging a standard log'),
              contains('A second warning'),
              contains('And a third'),
            ]));
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())));
        expect(logs, hasLength(10));
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())));
        expect(logs, hasLength(9));
      });
    });

    group('captures errors correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(
            () => mount((Sample()..shouldAlwaysBeFalse = true)()),
            configuration: errorConfig);

        expect(logs, hasLength(2));
        expect(logs.firstWhere((log) => log.contains('shouldAlwaysBeFalse')),
            contains('set to true'));
      });

      test('when re-rendering', () {
        // Will cause one error
        var jacket = mount((Sample()..shouldAlwaysBeFalse = true)());

        // Should clear the error from mounting and not create any more
        var logs = recordConsoleLogs(
            () => jacket.rerender((Sample()..shouldNeverBeNull = true)()),
            configuration: errorConfig);

        expect(logs, hasLength(0));
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())),
            configuration: errorConfig);

        expect(logs, hasLength(2));
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())),
            configuration: errorConfig);

        expect(logs, hasLength(1),
            reason: 'React will only show a particular props error once');
      });
    });

    group('captures logs correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(Sample()()),
            configuration: logConfig);

        expect(logs, hasLength(1));
      });

      test('when re-rendering', () {
        // Will cause one log
        var jacket = mount(Sample()());

        // Should clear the previous log and result in there being two
        var logs = recordConsoleLogs(
            () => jacket.rerender((Sample()..addExtraLogAndWarn = true)()),
            configuration: logConfig);

        expect(logs, hasLength(2));
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())),
            configuration: logConfig);

        expect(logs, hasLength(2));
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())),
            configuration: logConfig);

        expect(logs, hasLength(2));
      });
    });

    group('captures warnings correctly', () {
      test('when mounting', () {
        var logs = recordConsoleLogs(() => mount(Sample()()),
            configuration: warnConfig);

        expect(logs, hasLength(3));
      });

      test('when re-rendering', () {
        // Will three warnings
        var jacket = mount(Sample()());

        // Should clear the previous warnings and result in there being 3
        var logs = recordConsoleLogs(
            () => jacket.rerender((Sample()..addExtraLogAndWarn = true)()),
            configuration: warnConfig);

        expect(logs, hasLength(3));
      });

      test('with nested components', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample2()())),
            configuration: warnConfig);

        expect(logs, hasLength(6));
      });

      test('with nested components that are the same', () {
        var logs = recordConsoleLogs(() => mount(Sample()(Sample()())),
            configuration: warnConfig);

        expect(logs, hasLength(6));
      });
    });

    test('handles errors as expected when mounting', () {
      var logs = recordConsoleLogs(
          () => mount((Sample()..shouldError = true)()),
          configuration: errorConfig);

      expect(logs, hasLength(2));
    });

    group('handles propType warnings as expected with shouldResetWarningCache',
        () {
      test('left as true', () {
        var logs = recordConsoleLogs(() => mount(Sample()()),
            configuration: errorConfig);

        expect(logs, hasLength(1));
      });

      test('set to false', () {
        var logs = recordConsoleLogs(() => mount(Sample()()),
            configuration: errorConfig);

        expect(logs, hasLength(1));

        logs = recordConsoleLogs(() => mount(Sample()()),
            configuration: errorConfig,
            shouldResetPropTypesWarningCache: false);
        expect(logs, hasLength(0),
            reason:
                'Because the last test triggered the same propType warning, '
                'without resetting the cache the warning will not be logged.');

        PropTypes.resetWarningCache();

        logs = recordConsoleLogs(() => mount(Sample()()),
            configuration: errorConfig,
            shouldResetPropTypesWarningCache: false);
        expect(logs, hasLength(1));
      });
    });
  });

  group('recordConsoleLogsAsync', () {
    test('handles document events', () async {
      var jacket = mount(Sample()(), attachedToDocument: true);
      var logs = await recordConsoleLogsAsync(() async {
        var button =
            queryByTestId(jacket.getInstance(), 'ort_sample_component_button');
        await Future.delayed(Duration(milliseconds: 5));

        triggerDocumentClick(button);
      }, configuration: warnConfig);

      expect(logs, hasLength(1));
      expect(logs.first.contains('I have been clicked'), isTrue);
    });

    test('handles errors caused when rendering', () async {
      var logs = await recordConsoleLogsAsync(() async {
        await Future.delayed(Duration(milliseconds: 5));

        mount(
            (Sample()
              ..shouldAlwaysBeFalse = true
              ..shouldError = true)(),
            attachedToDocument: true);
      }, configuration: errorConfig);

      expect(logs, hasLength(3));
    });

    test('handles errors caused when re-rendering', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample()..shouldAlwaysBeFalse = true)(),
            attachedToDocument: true);

        await Future.delayed(Duration(milliseconds: 5));

        jacket.rerender((Sample()
          ..shouldError = true
          ..shouldAlwaysBeFalse = true)());
      }, configuration: errorConfig);

      expect(logs, hasLength(3));
    });

    test('handles re-renders when the mount is outside of the function',
        () async {
      var jacket = mount(Sample()(), attachedToDocument: true);

      var logs = await recordConsoleLogsAsync(() async {
        await Future.delayed(Duration(milliseconds: 5));

        jacket.rerender((Sample()..shouldAlwaysBeFalse = true)());
      }, configuration: errorConfig);

      expect(logs, hasLength(2));
    });

    test('handles re-renders when the mount is inside of the function',
        () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount(Sample()(), attachedToDocument: true);

        await Future.delayed(Duration(milliseconds: 5));

        jacket.rerender((Sample()
          ..shouldAlwaysBeFalse = true
          ..shouldNeverBeNull = false)());
      }, configuration: errorConfig);

      expect(logs, hasLength(3));
    });

    test('captures logs', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample()..addExtraLogAndWarn = true)(),
            attachedToDocument: true);
        var button =
            queryByTestId(jacket.getInstance(), 'ort_sample_component_button');
        await Future.delayed(Duration(milliseconds: 5));

        triggerDocumentClick(button);
      }, configuration: logConfig);

      expect(logs, hasLength(3));
    });

    test('captures warns', () async {
      var logs = await recordConsoleLogsAsync(() async {
        var jacket = mount((Sample()..addExtraLogAndWarn = true)(),
            attachedToDocument: true);
        var button =
            queryByTestId(jacket.getInstance(), 'ort_sample_component_button');
        await Future.delayed(Duration(milliseconds: 5));

        triggerDocumentClick(button);
      }, configuration: warnConfig);

      expect(logs, hasLength(5));
    });

    group('handles propType warnings as expected with shouldResetWarningCache',
            () {
          test('left as true', () async {
            var jacket = mount(Sample()(), attachedToDocument: true);

            var logs = await recordConsoleLogsAsync(() async {
              await Future.delayed(Duration(milliseconds: 5));

              jacket.rerender(Sample()());
            }, configuration: errorConfig);

            expect(logs, hasLength(1));
          });

          test('set to false', () async {
            var jacket = mount(Sample()(), attachedToDocument: true);

            var logs = await recordConsoleLogsAsync(() async {
              await Future.delayed(Duration(milliseconds: 5));

              jacket.rerender(Sample()());
            }, configuration: errorConfig);

            expect(logs, hasLength(1));

            logs = await recordConsoleLogsAsync(() async {
              await Future.delayed(Duration(milliseconds: 5));

              jacket.rerender(Sample()());
            }, configuration: errorConfig, shouldResetPropTypesWarningCache: false);

            expect(logs, hasLength(0),
                reason:
                'Because the last test triggered the same propType warning, '
                    'without resetting the cache the warning will not be logged.');

            PropTypes.resetWarningCache();

            logs = await recordConsoleLogsAsync(() async {
              await Future.delayed(Duration(milliseconds: 5));

              jacket.rerender(Sample()());
            }, configuration: errorConfig, shouldResetPropTypesWarningCache: false);

            expect(logs, hasLength(1));
          });
        });
  });
}
