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

import 'package:over_react/over_react.dart';
import 'package:test/test.dart';

/// Starts recording an OverReact [ValidationUtil.warn]ing.
///
/// For use within `setUp`:
///
///     group('emits a warning to the console', () {
///       setUp(startRecordingValidationWarnings);
///
///       tearDown(stopRecordingValidationWarnings);
///
///       test('when <describe something that should trigger a warning>', () {
///         // Do something that should trigger a warning
///
///         verifyValidationWarning(/* some Matcher or String */);
///       });
///
///       test('unless <describe something that should NOT trigger a warning>', () {
///         // Do something that should NOT trigger a warning
///
///         rejectValidationWarning(/* some Matcher or String */);
///       });
///     },
///         // Be sure to not run these tests in JS browsers
///         // like Chrome, Firefox, etc. since  the OverReact
///         // ValidationUtil.warn() method will only produce a
///         // console warning when compiled in "dev" mode.
///         testOn: '!js'
///     );
///
/// > Related: [stopRecordingValidationWarnings], [verifyValidationWarning], [rejectValidationWarning]
void startRecordingValidationWarnings() {
  _validationWarnings = [];
  ValidationUtil.onWarning = _recordValidationWarning;
}

/// Stops recording the OverReact [ValidationUtil.warn]ings that were being
/// recorded as a result of calling [startRecordingValidationWarnings].
///
/// For use within `tearDown`:
///
///     group('emits a warning to the console', () {
///       setUp(startRecordingValidationWarnings);
///
///       tearDown(stopRecordingValidationWarnings);
///
///       test('when <describe something that should trigger a warning>', () {
///         // Do something that should trigger a warning
///
///         verifyValidationWarning(/* some Matcher or String */);
///       });
///
///       test('unless <describe something that should NOT trigger a warning>', () {
///         // Do something that should NOT trigger a warning
///
///         rejectValidationWarning(/* some Matcher or String */);
///       });
///     },
///         // Be sure to not run these tests in JS browsers
///         // like Chrome, Firefox, etc. since  the OverReact
///         // ValidationUtil.warn() method will only produce a
///         // console warning when compiled in "dev" mode.
///         testOn: '!js'
///     );
///
/// > Related: [startRecordingValidationWarnings], [verifyValidationWarning], [rejectValidationWarning]
void stopRecordingValidationWarnings() {
  _validationWarnings = null;
  if (ValidationUtil.onWarning == _recordValidationWarning) {
    ValidationUtil.onWarning = null;
  }
}

/// Verify that no validation warning(s) matching [warningMatcher] were logged.
///
/// Be sure to call [startRecordingValidationWarnings] before any code that might log errors:
///
///     group('emits a warning to the console', () {
///       setUp(startRecordingValidationWarnings);
///
///       tearDown(stopRecordingValidationWarnings);
///
///       test('when <describe something that should trigger a warning>', () {
///         // Do something that should trigger a warning
///
///         verifyValidationWarning(/* some Matcher or String */);
///       });
///
///       test('unless <describe something that should NOT trigger a warning>', () {
///         // Do something that should NOT trigger a warning
///
///         rejectValidationWarning(/* some Matcher or String */);
///       });
///     },
///         // Be sure to not run these tests in JS browsers
///         // like Chrome, Firefox, etc. since  the OverReact
///         // ValidationUtil.warn() method will only produce a
///         // console warning when compiled in "dev" mode.
///         testOn: '!js'
///     );
///
/// > Related: [verifyValidationWarning], [startRecordingValidationWarnings], [stopRecordingValidationWarnings]
void rejectValidationWarning(dynamic warningMatcher) {
  expect(_validationWarnings, everyElement(isNot(warningMatcher)),
      reason: 'Expected no recorded warnings to match: $warningMatcher'
  );
}

/// Verify that a validation warning(s) matching [warningMatcher] were logged.
///
/// Be sure to call [startRecordingValidationWarnings] before any code that might log errors:
///
///     group('emits a warning to the console', () {
///       setUp(startRecordingValidationWarnings);
///
///       tearDown(stopRecordingValidationWarnings);
///
///       test('when <describe something that should trigger a warning>', () {
///         // Do something that should trigger a warning
///
///         verifyValidationWarning(/* some Matcher or String */);
///       });
///
///       test('unless <describe something that should NOT trigger a warning>', () {
///         // Do something that should NOT trigger a warning
///
///         rejectValidationWarning(/* some Matcher or String */);
///       });
///     },
///         // Be sure to not run these tests in JS browsers
///         // like Chrome, Firefox, etc. since  the OverReact
///         // ValidationUtil.warn() method will only produce a
///         // console warning when compiled in "dev" mode.
///         testOn: '!js'
///     );
///
/// > Related: [rejectValidationWarning], [startRecordingValidationWarnings], [stopRecordingValidationWarnings]
void verifyValidationWarning(dynamic warningMatcher) {
  expect(_validationWarnings, anyElement(warningMatcher),
      reason: 'Expected some recorded warning to match: $warningMatcher'
  );
}

/// Returns the list of [ValidationUtil.warn]ings that have been recorded since
/// [startRecordingValidationWarnings] was first called.
///
/// > Related: [clearValidationWarnings]
List<String> getValidationWarnings() => _validationWarnings?.toList();

/// Clears the list of [ValidationUtil.warn]ings that have been recorded since
/// [startRecordingValidationWarnings] was first called.
///
/// > Related: [getValidationWarnings]
void clearValidationWarnings() {
  _validationWarnings.clear();
}

List<String> _validationWarnings;
void _recordValidationWarning(String warningMessage) {
  _validationWarnings.add(warningMessage);
}
