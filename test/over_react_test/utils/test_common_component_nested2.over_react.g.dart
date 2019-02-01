// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_common_component_nested2.dart';

// **************************************************************************
// OverReactGenerator
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $TestCommonNested2ComponentFactory = registerComponent(
    () => new _$TestCommonNested2Component(),
    builderFactory: TestCommonNested2,
    componentClass: TestCommonNested2Component,
    isWrapper: false,
    parentType: null,
    displayName: 'TestCommonNested2');

abstract class _$TestCommonNested2PropsAccessorsMixin
    implements _$TestCommonNested2Props {
  @override
  Map get props;

  /* GENERATED CONSTANTS */

  static const List<PropDescriptor> $props = const [];
  static const List<String> $propKeys = const [];
}

const PropsMeta _$metaForTestCommonNested2Props = const PropsMeta(
  fields: _$TestCommonNested2PropsAccessorsMixin.$props,
  keys: _$TestCommonNested2PropsAccessorsMixin.$propKeys,
);

_$$TestCommonNested2Props _$TestCommonNested2([Map backingProps]) =>
    new _$$TestCommonNested2Props(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$TestCommonNested2Props extends _$TestCommonNested2Props
    with _$TestCommonNested2PropsAccessorsMixin
    implements TestCommonNested2Props {
  _$$TestCommonNested2Props(Map backingMap) : this._props = backingMap ?? {};

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
      $TestCommonNested2ComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'TestCommonNested2Props.';
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$TestCommonNested2Component extends TestCommonNested2Component {
  @override
  typedPropsFactory(Map backingMap) =>
      new _$$TestCommonNested2Props(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$TestCommonNested2Props.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForTestCommonNested2Props
  ];
}
