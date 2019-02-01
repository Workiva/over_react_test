// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nested_component.dart';

// **************************************************************************
// OverReactGenerator
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $NestedComponentFactory = registerComponent(() => new _$NestedComponent(),
    builderFactory: Nested,
    componentClass: NestedComponent,
    isWrapper: false,
    parentType: null,
    displayName: 'Nested');

abstract class _$NestedPropsAccessorsMixin implements _$NestedProps {
  @override
  Map get props;

  /* GENERATED CONSTANTS */

  static const List<PropDescriptor> $props = const [];
  static const List<String> $propKeys = const [];
}

const PropsMeta _$metaForNestedProps = const PropsMeta(
  fields: _$NestedPropsAccessorsMixin.$props,
  keys: _$NestedPropsAccessorsMixin.$propKeys,
);

_$$NestedProps _$Nested([Map backingProps]) => new _$$NestedProps(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$NestedProps extends _$NestedProps
    with _$NestedPropsAccessorsMixin
    implements NestedProps {
  _$$NestedProps(Map backingMap) : this._props = backingMap ?? {};

  /// The backing props map proxied by this class.
  @override
  Map get props => _props;
  final Map _props;

  /// Let [UiProps] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The [ReactComponentFactory] associated with the component built by this class.
  @override
  ReactComponentFactoryProxy get componentFactory => $NestedComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'NestedProps.';
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$NestedComponent extends NestedComponent {
  @override
  typedPropsFactory(Map backingMap) => new _$$NestedProps(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$NestedProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForNestedProps
  ];
}
