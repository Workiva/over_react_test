// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_common_component_required_props.dart';

// **************************************************************************
// OverReactGenerator
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $TestCommonRequiredComponentFactory = registerComponent(
    () => new _$TestCommonRequiredComponent(),
    builderFactory: TestCommonRequired,
    componentClass: TestCommonRequiredComponent,
    isWrapper: false,
    parentType: null,
    displayName: 'TestCommonRequired');

abstract class _$TestCommonRequiredPropsAccessorsMixin
    implements _$TestCommonRequiredProps {
  @override
  Map get props;

  /// Go to [_$TestCommonRequiredProps.bar] to see the source code for this prop
  @override
  @requiredProp
  bool get bar => props[_$key__bar___$TestCommonRequiredProps];

  /// Go to [_$TestCommonRequiredProps.bar] to see the source code for this prop
  @override
  @requiredProp
  set bar(bool value) => props[_$key__bar___$TestCommonRequiredProps] = value;
  /* GENERATED CONSTANTS */
  static const PropDescriptor _$prop__bar___$TestCommonRequiredProps =
      const PropDescriptor(_$key__bar___$TestCommonRequiredProps,
          isRequired: true);
  static const String _$key__bar___$TestCommonRequiredProps =
      'TestCommonRequiredProps.bar';

  static const List<PropDescriptor> $props = const [
    _$prop__bar___$TestCommonRequiredProps
  ];
  static const List<String> $propKeys = const [
    _$key__bar___$TestCommonRequiredProps
  ];
}

const PropsMeta _$metaForTestCommonRequiredProps = const PropsMeta(
  fields: _$TestCommonRequiredPropsAccessorsMixin.$props,
  keys: _$TestCommonRequiredPropsAccessorsMixin.$propKeys,
);

_$$TestCommonRequiredProps _$TestCommonRequired([Map backingProps]) =>
    new _$$TestCommonRequiredProps(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$TestCommonRequiredProps extends _$TestCommonRequiredProps
    with _$TestCommonRequiredPropsAccessorsMixin
    implements TestCommonRequiredProps {
  _$$TestCommonRequiredProps(Map backingMap) : this._props = backingMap ?? {};

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
      $TestCommonRequiredComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'TestCommonRequiredProps.';
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$TestCommonRequiredComponent extends TestCommonRequiredComponent {
  @override
  typedPropsFactory(Map backingMap) =>
      new _$$TestCommonRequiredProps(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$TestCommonRequiredProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForTestCommonRequiredProps
  ];
}
