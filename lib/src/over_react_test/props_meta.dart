// Copyright 2020 Workiva Inc.
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
import 'package:over_react_test/jacket.dart';
import 'package:react/react_client/react_interop.dart';

/// Returns the [UiComponent2.propsMeta] obtained by rendering [el].
///
/// Returns `null` if [el] does not render a UiComponent2 or does not use the
/// new mixin syntax (determined by whether accessing propsMeta throws).
PropsMetaCollection? getPropsMeta(ReactElement el) {
  // ignore: invalid_use_of_protected_member
  final isComponent2 = ReactDartComponentVersion.fromType(el.type) == '2';
  if (!isComponent2) return null;

  // Can't auto-tear down here because we're not inside a test.
  // Use a try-finally instead
  final jacket = mount(el, autoTearDown: false);
  try {
    final instance = jacket.getDartInstance();
    if (instance is UiComponent2) {
      try {
        // ignore: invalid_use_of_protected_member
        return instance.propsMeta;
      } catch (_) {}
    }

    return null;
  } finally {
    jacket.unmount();
  }
}
