// @dart = 2.14
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
/// config class ([logConfig], [warnConfig], [errorConfig], [allConfig]).
///
/// By default, the function assumes that any `propType` warnings that occur during
/// the function runtime should be captured. Consequently, the `PropType` cache
/// is reset prior to calling the provided callback. If you wish to ignore the
/// `propType` warnings that have occurred outside the scope of the callback,
/// set [shouldResetPropTypesWarningCache] to `false`.
///
/// If any errors are thrown during the callback, e.g. during a render that expects
/// props that are not valid, the errors will be caught to allow the test to complete.
///
/// To handle asynchronous behavior, see [recordConsoleLogsAsync].
List<String?> recordConsoleLogs(
  Function() callback, {
  ConsoleConfiguration configuration = allConfig,
  bool shouldResetPropTypesWarningCache = true,
}) {
  final consoleLogs = <String?>[];
  final logTypeToCapture = configuration.logType == 'all'
      ? ConsoleConfiguration.types
      : [configuration.logType];
  Map<String, JsFunction?> consoleRefs = {};

  if (shouldResetPropTypesWarningCache) _resetPropTypeWarningCache();

  for (var config in logTypeToCapture) {
    consoleRefs[config] = context['console'][config];
    context['console'][config] =
        JsFunction.withThis((self, [message, arg1, arg2, arg3, arg4, arg5]) {
      // NOTE: Using console.log or print within this function will cause an infinite
      // loop when the logType is set to `log`.
      consoleLogs.add(message);
      consoleRefs[config]!
          .apply([message, arg1, arg2, arg3, arg4, arg5], thisArg: self);
    });
  }

  try {
    callback();
  } catch (_) {
    // No error handling is necessary. This catch is meant to catch errors that
    // may occur if a render fails due to invalid props. It also ensures that the
    // console is reset correctly, even if the callback is broken.
  } finally {
    for (var config in logTypeToCapture) {
      context['console'][config] = consoleRefs[config];
    }
  }

  return consoleLogs;
}

/// Captures console logs created during the runtime of a provided asynchronous
/// callback.
///
/// The core logic and parameters are the same as those for [recordConsoleLogs],
/// with the exception being the provided callback should be asynchronous.
///
/// Related: [recordConsoleLogs]
FutureOr<List<String?>> recordConsoleLogsAsync(
  Future Function() asyncCallback, {
  ConsoleConfiguration configuration = allConfig,
  bool shouldResetPropTypesWarningCache = true,
}) async {
  var consoleLogs = <String?>[];
  final logTypeToCapture = configuration.logType == 'all'
      ? ConsoleConfiguration.types
      : [configuration.logType];
  Map<String, JsFunction?> consoleRefs = {};

  if (shouldResetPropTypesWarningCache) _resetPropTypeWarningCache();

  for (var config in logTypeToCapture) {
    consoleRefs[config] = context['console'][config];
    context['console'][config] =
        JsFunction.withThis((self, [message, arg1, arg2, arg3, arg4, arg5]) {
      // NOTE: Using console.log or print within this function will cause an infinite
      // loop when the logType is set to `log`.
      consoleLogs.add(message);
      consoleRefs[config]!
          .apply([message, arg1, arg2, arg3, arg4, arg5], thisArg: self);
    });
  }

  try {
    await asyncCallback();
  } catch (_) {
    // No error handling is necessary. This catch is meant to catch errors that
    // may occur if a render fails due to invalid props. It also ensures that the
    // console is reset correctly, even if the callback is broken.
  } finally {
    for (var config in logTypeToCapture) {
      context['console'][config] = consoleRefs[config];
    }
  }

  return consoleLogs;
}

/// Utility method that resets the `PropTypes` warning cache safely.
void _resetPropTypeWarningCache() {
  try {
    PropTypes.resetWarningCache();
  } catch(_){}
}

/// Configuration class that sets options within [recordConsoleLogs] and
/// [recordConsoleLogsAsync].
class ConsoleConfiguration {
  const ConsoleConfiguration._warn() : logType = 'warn';

  const ConsoleConfiguration._error() : logType = 'error';

  const ConsoleConfiguration._log() : logType = 'log';

  const ConsoleConfiguration._all() : logType = 'all';

  /// The type of log to capture while running the callbacks within
  /// [recordConsoleLogs] and [recordConsoleLogsAsync].
  ///
  /// Must be `'warn'`, `'error'`, `'log'` or `'all'`.
  final String logType;

  /// The possible console types that have different log contexts.
  static const Set<String> types = {'error', 'log', 'warn'};
}

/// The configuration needed to capture logs while running [recordConsoleLogs].
const ConsoleConfiguration logConfig = ConsoleConfiguration._log();

/// The configuration needed to capture warnings while running [recordConsoleLogs].
const ConsoleConfiguration warnConfig = ConsoleConfiguration._warn();

/// The configuration needed to capture errors while running [recordConsoleLogs].
const ConsoleConfiguration errorConfig = ConsoleConfiguration._error();

/// The configuration that will capture all logs, whether they be logs, warnings,
/// or errors.
const ConsoleConfiguration allConfig = ConsoleConfiguration._all();
