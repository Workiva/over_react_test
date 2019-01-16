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

// ignore: uri_has_not_been_generated
part 'wrapper_component.over_react.g.dart';

/// A helper component for use in tests where a component needs to be
/// rendered inside a wrapper, but a composite component must be used
/// for compatability with `getByTestId()`.
@Factory()
// ignore: undefined_identifier
UiFactory<UiProps> Wrapper =
    // ignore: undefined_identifier
    _$Wrapper;

@Props()
class _$WrapperProps extends UiProps {}

@Component()
class WrapperComponent extends UiComponent<WrapperProps> {
  @override
  render() => (Dom.div()..addAll(props))(props.children);
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class WrapperProps extends _$WrapperProps with _$WrapperPropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = $metaForWrapperProps;
}
