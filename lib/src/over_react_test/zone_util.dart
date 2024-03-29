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

import 'dart:async';

import 'package:react/react_client.dart';
import 'package:test/test.dart';

Zone? _zone;

/// Validates that [storeZone] was called before [zonedExpect] was.
void validateZone() {
  if (_zone == null) {
    throw StateError('Need to call storeZone() first.');
  }
}

/// Store the specified _(or current if none is specified)_ [zone]
/// for use within [zonedExpect].
void storeZone([Zone? zone]) {
  _zone = zone ?? Zone.current;
}

/// Calls [expect] in package:test/test.dart in the zone stored in [storeZone].
///
/// Useful for expectations in blocks called in other zones.
void zonedExpect(actual, matcher, {String? reason}) {
  validateZone();

  return _zone!.run(() {
    expect(actual, matcher, reason: reason);
  });
}

/// Sets the zone that React components are run in.
///
/// By default, tests and React run in differing zones. This can be used to force
/// tests and components to be run in the same zone.
///
/// __NOTE:__ This is not needed when using `render` (or any function that
/// utilizes it) or `mount` because it is built in to those utilities.
///
/// __EXAMPLE:__
///
///     test('test that requires zones to be the same', () {
///       // Reset the zone back to the default after the test is run.
///       addTearDown(() => setComponentZone(Zone.root));
///
///       void shouldFailTest() => expect(true, isFalse);
///       void shouldPassTest() => expect(true, isTrue);
///
///       renderIntoDocument((
///           TestComponent()..onComponentDidMount = shouldFailTest)()); // Throws bad state error
///
///       setComponentZone();
///
///       renderIntoDocument((
///           TestComponent()..onComponentDidMount = shouldFailTest)()); // Fails
///       renderIntoDocument((
///           TestComponent()..onComponentDidMount = shouldPassTest)()); // Passes
///     });
void setComponentZone([Zone? zone]) {
  componentZone = zone ?? Zone.current;
}
