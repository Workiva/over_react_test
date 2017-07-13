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

import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

import './utils/test_validation_util_component.dart';

/// Main entry point for `validation_util.dart` testing.
main() {
  group('ValidationUtil:', () {
    DivElement mountNode;

    setUp(() {
      startRecordingValidationWarnings();

      mountNode = new DivElement();
      document.body.append(mountNode);
    });

    tearDown(() {
      stopRecordingValidationWarnings();

      tearDownAttachedNodes();
      unmount(mountNode);
      mountNode.remove();

      mountNode = null;
    });

    group('startRecordingValidationWarnings()', () {
      test('begins recording validation warnings, appending them to `_validationWarnings` as expected', () {
        react_dom.render(TestValidationWarnings()(), mountNode);

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message1');

        react_dom.render((TestValidationWarnings()..emitSecondWarning = true)(), mountNode);

        expect(getValidationWarnings(), hasLength(2));
        expect(getValidationWarnings(), equals(['message1', 'message2']));
      });
    });

    group('stopRecordingValidationWarnings()', () {
      test('halts the recording of validation warnings and clears the list of warnings as expected', () {
        react_dom.render(TestValidationWarnings()(), mountNode);

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message1');

        stopRecordingValidationWarnings();

        react_dom.render((TestValidationWarnings()..emitSecondWarning = true)(), mountNode);

        expect(getValidationWarnings(), isNull);
      });
    });

    group('verifyValidationWarning() works as expected', () {
      test('when a single warning has been emitted', () {
        react_dom.render(TestValidationWarnings()(), mountNode);

        verifyValidationWarning('message1');
      });

      test('when multiple warnings have been emitted', () {
        react_dom.render((TestValidationWarnings()..emitSecondWarning = true)(), mountNode);

        verifyValidationWarning('message1');
        verifyValidationWarning(contains('message2'));
      });
    });

    group('rejectValidationWarning() works as expected', () {
      test('when a single warning has been emitted', () {
        react_dom.render(TestValidationWarnings()(), mountNode);

        rejectValidationWarning('nope');
      });

      test('when multiple warnings have been emitted', () {
        react_dom.render((TestValidationWarnings()..emitSecondWarning = true)(), mountNode);

        rejectValidationWarning(contains('non-existent warning message'));
      });
    });

    group('clearValidationWarnings()', () {
      test('clears the list of warnings as expected', () {
        react_dom.render(TestValidationWarnings()(), mountNode);

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message1');

        clearValidationWarnings();

        expect(getValidationWarnings(), isEmpty);

        react_dom.render((TestValidationWarnings()..emitSecondWarning = true)(), mountNode);

        expect(getValidationWarnings(), hasLength(1));
        expect(getValidationWarnings().single, 'message2');
      });
    });
  }, testOn: '!js');
}
