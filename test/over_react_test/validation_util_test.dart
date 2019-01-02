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
import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

/// Main entry point for `validation_util.dart` testing.
main() {
  group('ValidationUtil:', () {
    // ignore: unnecessary_lambdas
    setUp(() {
      startRecordingValidationWarnings();
    });

    // ignore: unnecessary_lambdas
    tearDown(() {
      stopRecordingValidationWarnings();
    });

    group('startRecordingValidationWarnings()', () {
      test('begins recording validation warnings, appending them to `_validationWarnings` as expected', () {
        assert(ValidationUtil.warn('message1'));

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message1');

        assert(ValidationUtil.warn('message2'));

        expect(getValidationWarnings(), hasLength(2));
        expect(getValidationWarnings(), equals(['message1', 'message2']));
      });
    });

    group('stopRecordingValidationWarnings()', () {
      test('halts the recording of validation warnings and clears the list of warnings as expected', () {
        assert(ValidationUtil.warn('message1'));

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message1');

        stopRecordingValidationWarnings();

        assert(ValidationUtil.warn('message2'));

        expect(getValidationWarnings(), isNull);
      });
    });

    group('verifyValidationWarning() works as expected', () {
      test('when a single warning has been emitted', () {
        assert(ValidationUtil.warn('message1'));

        verifyValidationWarning('message1');
      });

      test('when multiple warnings have been emitted', () {
        assert(ValidationUtil.warn('message1'));
        assert(ValidationUtil.warn('message2'));

        verifyValidationWarning('message1');
        verifyValidationWarning(contains('message2'));
      });
    });

    group('rejectValidationWarning() works as expected', () {
      test('when a single warning has been emitted', () {
        assert(ValidationUtil.warn('message1'));

        rejectValidationWarning('nope');
      });

      test('when multiple warnings have been emitted', () {
        assert(ValidationUtil.warn('message1'));
        assert(ValidationUtil.warn('message2'));

        rejectValidationWarning(contains('non-existent warning message'));
      });
    });

    group('clearValidationWarnings()', () {
      test('clears the list of warnings as expected', () {
        assert(ValidationUtil.warn('message1'));

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message1');

        clearValidationWarnings();

        expect(getValidationWarnings(), isEmpty);

        assert(ValidationUtil.warn('message2'));

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message2');
      });
    });
  }, testOn: '!js');
}
