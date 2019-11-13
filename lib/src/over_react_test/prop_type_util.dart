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
import 'dart:js';

import 'package:react/react_client/react_interop.dart';

/// Runs a provided callback and returns the logs that occur during the runtime
/// of that function.
///
/// Can be used to capture logs, warnings, or errors as specified by setting
/// the [configuration]. To set the [configuration], pass in the corresponding
/// config class (logConfig, warnConfig, errorConfig, any).
///
/// To handle asynchronous behavior, see [recordConsoleLogsAsync].
List<String> recordConsoleLogs(Function() callback,
    [ConsoleConfiguration configuration = const ConsoleConfiguration.all()]) {
  final consoleLogs = <String>[];
  final logTypeToCapture = configuration.logType == 'all'
      ? ConsoleConfiguration.types
      : [configuration.logType];

  PropTypes.resetWarningCache();

  for (var config in logTypeToCapture) {
    JsFunction originalConsole = context['console'][config];
    context['console'][config] =
        JsFunction.withThis((self, [message, arg1, arg2, arg3, arg4, arg5]) {
      // NOTE: Using console.log or print within this function will cause an infinite
      // loop when the logType is set to `log`.
      consoleLogs.add(message);
      originalConsole
          .apply([message, arg1, arg2, arg3, arg4, arg5], thisArg: self);
    });

    try {
      callback();
    } catch (_) {
      // No error handling is necessary. This catch is meant to catch errors that
      // may occur if a render fails due to invalid props. It also ensures that the
      // console is reset correctly, even if the callback is broken.
    } finally {
      context['console'][config] = originalConsole;
    }
  }

  return consoleLogs;
}

/// Captures console logs created during the runtime of a provided asynchronous
/// callback.
///
/// Related: [recordConsoleLogs]
FutureOr<List<String>> recordConsoleLogsAsync(Future Function() asyncCallback,
    [ConsoleConfiguration configuration =
        const ConsoleConfiguration.error()]) async {
  var consoleLogs = <String>[];
  final logTypeToCapture = configuration.logType == 'all'
      ? ConsoleConfiguration.types
      : [configuration.logType];

  PropTypes.resetWarningCache();

  for (var config in logTypeToCapture) {
    JsFunction originalConsole = context['console'][config];
    context['console'][config] =
        JsFunction.withThis((self, [message, arg1, arg2, arg3, arg4, arg5]) {
      // NOTE: Using console.log or print within this function will cause an infinite
      // loop when the logType is set to `log`.
      consoleLogs.add(message);
      originalConsole
          .apply([message, arg1, arg2, arg3, arg4, arg5], thisArg: self);
    });

    try {
      await asyncCallback();
    } catch (_) {
      // No error handling is necessary. This catch is meant to catch errors that
      // may occur if a render fails due to invalid props. It also ensures that the
      // console is reset correctly, even if the callback is broken.
    } finally {
      context['console'][config] = originalConsole;
    }
  }

  return consoleLogs;
}

/// Configuration class that sets options within [recordConsoleLogs] and
/// [recordConsoleLogsAsync].
class ConsoleConfiguration {
  const ConsoleConfiguration.warn() : logType = 'warn';

  const ConsoleConfiguration.error() : logType = 'error';

  const ConsoleConfiguration.log() : logType = 'log';

  const ConsoleConfiguration.all() : logType = 'all';

  /// The type of log to capture while running the callbacks within
  /// [recordConsoleLogs] and [recordConsoleLogsAsync].
  ///
  /// Must be `'warn'`, `'error'`, `'log'` or `'all'`.
  final logType;

  /// The possible console types that have different log contexts.
  static const types = ['error', 'log', 'warn'];
}

/// The configuration needed to capture logs while running [recordConsoleLogs].
ConsoleConfiguration logConfig = const ConsoleConfiguration.log();

/// The configuration needed to capture warnings while running [recordConsoleLogs].
ConsoleConfiguration warnConfig = const ConsoleConfiguration.warn();

/// The configuration needed to capture errors while running [recordConsoleLogs].
ConsoleConfiguration errorConfig = const ConsoleConfiguration.error();

/// The configuration that will capture all logs, whether they be logs, warnings,
/// or errors.
ConsoleConfiguration allConfig = const ConsoleConfiguration.all();
