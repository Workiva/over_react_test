// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapper_component.dart';

// **************************************************************************
// OverReactBuilder (package:over_react/src/builder.dart)
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $WrapperComponentFactory = registerComponent(
    () => new _$WrapperComponent(),
    builderFactory: Wrapper,
    componentClass: WrapperComponent,
    isWrapper: false,
    parentType: null,
    displayName: 'Wrapper');

abstract class _$WrapperPropsAccessorsMixin implements _$WrapperProps {
  @override
  Map get props;

  /* GENERATED CONSTANTS */

  static const List<PropDescriptor> $props = const [];
  static const List<String> $propKeys = const [];
}

const PropsMeta _$metaForWrapperProps = const PropsMeta(
  fields: _$WrapperPropsAccessorsMixin.$props,
  keys: _$WrapperPropsAccessorsMixin.$propKeys,
);

_$$WrapperProps _$Wrapper([Map backingProps]) =>
    new _$$WrapperProps(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$WrapperProps extends _$WrapperProps
    with _$WrapperPropsAccessorsMixin
    implements WrapperProps {
  // This initializer of `_props` to an empty map, as well as the reassignment
  // of `_props` in the constructor body is necessary to work around an unknown ddc issue.
  // See <https://jira.atl.workiva.net/browse/CPLAT-4673> for more details
  _$$WrapperProps(Map backingMap) : this._props = {} {
    this._props = backingMap ?? {};
  }

  /// The backing props map proxied by this class.
  @override
  Map get props => _props;
  Map _props;

  /// Let [UiProps] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The [ReactComponentFactory] associated with the component built by this class.
  @override
  ReactComponentFactoryProxy get componentFactory => $WrapperComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'WrapperProps.';
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$WrapperComponent extends WrapperComponent {
  @override
  _$$WrapperProps typedPropsFactory(Map backingMap) =>
      new _$$WrapperProps(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$WrapperProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForWrapperProps
  ];
}
