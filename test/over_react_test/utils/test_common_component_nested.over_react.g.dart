// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_common_component_nested.dart';

// **************************************************************************
// OverReactGenerator
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $TestCommonNestedComponentFactory = registerComponent(
    () => new _$TestCommonNestedComponent(),
    builderFactory: TestCommonNested,
    componentClass: TestCommonNestedComponent,
    isWrapper: false,
    parentType: null,
    displayName: 'TestCommonNested');

abstract class _$TestCommonNestedPropsAccessorsMixin
    implements _$TestCommonNestedProps {
  @override
  Map get props;

  /* GENERATED CONSTANTS */

  static const List<PropDescriptor> $props = const [];
  static const List<String> $propKeys = const [];
}

const PropsMeta _$metaForTestCommonNestedProps = const PropsMeta(
  fields: _$TestCommonNestedPropsAccessorsMixin.$props,
  keys: _$TestCommonNestedPropsAccessorsMixin.$propKeys,
);

_$$TestCommonNestedProps _$TestCommonNested([Map backingProps]) =>
    new _$$TestCommonNestedProps(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$TestCommonNestedProps extends _$TestCommonNestedProps
    with _$TestCommonNestedPropsAccessorsMixin
    implements TestCommonNestedProps {
  _$$TestCommonNestedProps(Map backingMap) : this._props = backingMap ?? {};

  /// The backing props map proxied by this class.
  @override
  Map get props => _props;
  final Map _props;

  /// Let [UiProps] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The [ReactComponentFactory] associated with the component built by this class.
  @override
  ReactComponentFactoryProxy get componentFactory =>
      $TestCommonNestedComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'TestCommonNestedProps.';
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$TestCommonNestedComponent extends TestCommonNestedComponent {
  @override
  typedPropsFactory(Map backingMap) => new _$$TestCommonNestedProps(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$TestCommonNestedProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForTestCommonNestedProps
  ];
}
