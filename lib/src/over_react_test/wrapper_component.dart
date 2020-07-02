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

part 'wrapper_component.over_react.g.dart';

/// A helper component for use in tests where a component needs to be
/// rendered inside a wrapper, but a composite component must be used
/// for compatability with `getByTestId()`.
// ignore: undefined_identifier
UiFactory<_WrapperProps> Wrapper =
    _$Wrapper; // ignore: undefined_identifier

mixin WrapperPropsMixin on UiProps {}

@Deprecated(
    'Use WrapperPropsMixin instead; this class exists solely to support'
        ' existing components with legacy syntax that extend from it,'
        ' and will be removed in the next major release')
abstract class WrapperProps extends UiProps
    with
        WrapperPropsMixin,
    // ignore: mixin_of_non_class, undefined_class
        $WrapperPropsMixin {
  @Deprecated(
      'Convert to new boilerplate and use `propsMeta.forMixins({WrapperPropsMixin})` instead.')
  // ignore: const_initialized_with_non_constant_value, undefined_class, undefined_identifier
  static const PropsMeta meta = _$metaForWrapperPropsMixin;
}

// ignore: deprecated_member_use_from_same_package
class _WrapperProps = UiProps with WrapperPropsMixin implements WrapperProps;

class WrapperComponent extends UiComponent2<_WrapperProps> {
  @override
  render() => (Dom.div()..addAll(props))(props.children);
}
