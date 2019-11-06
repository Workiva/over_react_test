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

import 'dart:js';

import 'package:react/react_client/react_interop.dart';

List<String> recordConsoleLogs(Function() collback, [_ConsoleConfiguration configuration = const _ConsoleConfiguration.error()]) {
  var consoleLogs = <String>[];

  PropTypes.resetWarningCache();

  JsFunction originalConsole = context['console'][configuration.logType];
  context['console'][configuration.logType] = new JsFunction.withThis((self, [message, arg1, arg2, arg3, arg4, arg5]) {
    // NOTE: Using console.log or print within this function will cause an infinite
    // loop the the logType is set to `log`.
    consoleLogs.add(message);
    originalConsole.apply([message, arg1, arg2, arg3, arg4, arg5], thisArg: self);
  });

  try {
    collback();
  } catch (_) {
    // No error handling is necessary. This catch is meant to catch errors that
    // may occur if a render fails due to invalid props. It also ensures that the
    // console is reset correctly, even if the callback is broken.
  } finally {
    context['console'][configuration.logType] = originalConsole;
  }

  return consoleLogs;
}

class _ConsoleConfiguration {
  final logType;

  const _ConsoleConfiguration.warn() : logType = 'warn';

  const _ConsoleConfiguration.error() : logType = 'error';

  const _ConsoleConfiguration.log() : logType = 'log';
}

_ConsoleConfiguration logConfig = const _ConsoleConfiguration.log();
_ConsoleConfiguration warnConfig = const _ConsoleConfiguration.warn();
_ConsoleConfiguration errorConfig = const _ConsoleConfiguration.error();
