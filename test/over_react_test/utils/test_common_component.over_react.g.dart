// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_common_component.dart';

// **************************************************************************
// OverReactGenerator
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $TestCommonComponentFactory =
    registerComponent(() => new _$TestCommonComponent(),
        builderFactory: TestCommon,
        componentClass: TestCommonComponent,
        isWrapper: false,
        parentType: $TestCommonNestedComponentFactory,
        /* from `subtypeOf: TestCommonNestedComponent` */
        displayName: 'TestCommon');

abstract class _$TestCommonPropsAccessorsMixin implements _$TestCommonProps {
  @override
  Map get props;

  /* GENERATED CONSTANTS */

  static const List<PropDescriptor> $props = const [];
  static const List<String> $propKeys = const [];
}

const PropsMeta _$metaForTestCommonProps = const PropsMeta(
  fields: _$TestCommonPropsAccessorsMixin.$props,
  keys: _$TestCommonPropsAccessorsMixin.$propKeys,
);

_$$TestCommonProps _$TestCommon([Map backingProps]) =>
    new _$$TestCommonProps(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$TestCommonProps extends _$TestCommonProps
    with _$TestCommonPropsAccessorsMixin
    implements TestCommonProps {
  _$$TestCommonProps(Map backingMap) : this._props = backingMap ?? {};

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
      $TestCommonComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'TestCommonProps.';
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$TestCommonComponent extends TestCommonComponent {
  @override
  typedPropsFactory(Map backingMap) => new _$$TestCommonProps(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$TestCommonProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForTestCommonProps
  ];
}

abstract class $PropsThatShouldBeForwarded
    implements PropsThatShouldBeForwarded {
  @override
  Map get props;

  /// Go to [PropsThatShouldBeForwarded.foo] to see the source code for this prop
  @override
  bool get foo => props[_$key__foo__PropsThatShouldBeForwarded];

  /// Go to [PropsThatShouldBeForwarded.foo] to see the source code for this prop
  @override
  set foo(bool value) => props[_$key__foo__PropsThatShouldBeForwarded] = value;
  /* GENERATED CONSTANTS */
  static const PropDescriptor _$prop__foo__PropsThatShouldBeForwarded =
      const PropDescriptor(_$key__foo__PropsThatShouldBeForwarded);
  static const String _$key__foo__PropsThatShouldBeForwarded =
      'PropsThatShouldBeForwarded.foo';

  static const List<PropDescriptor> $props = const [
    _$prop__foo__PropsThatShouldBeForwarded
  ];
  static const List<String> $propKeys = const [
    _$key__foo__PropsThatShouldBeForwarded
  ];
}

const PropsMeta _$metaForPropsThatShouldBeForwarded = const PropsMeta(
  fields: $PropsThatShouldBeForwarded.$props,
  keys: $PropsThatShouldBeForwarded.$propKeys,
);

abstract class $PropsThatShouldNotBeForwarded
    implements PropsThatShouldNotBeForwarded {
  @override
  Map get props;

  /// Go to [PropsThatShouldNotBeForwarded.bar] to see the source code for this prop
  @override
  bool get bar => props[_$key__bar__PropsThatShouldNotBeForwarded];

  /// Go to [PropsThatShouldNotBeForwarded.bar] to see the source code for this prop
  @override
  set bar(bool value) =>
      props[_$key__bar__PropsThatShouldNotBeForwarded] = value;
  /* GENERATED CONSTANTS */
  static const PropDescriptor _$prop__bar__PropsThatShouldNotBeForwarded =
      const PropDescriptor(_$key__bar__PropsThatShouldNotBeForwarded);
  static const String _$key__bar__PropsThatShouldNotBeForwarded =
      'PropsThatShouldNotBeForwarded.bar';

  static const List<PropDescriptor> $props = const [
    _$prop__bar__PropsThatShouldNotBeForwarded
  ];
  static const List<String> $propKeys = const [
    _$key__bar__PropsThatShouldNotBeForwarded
  ];
}

const PropsMeta _$metaForPropsThatShouldNotBeForwarded = const PropsMeta(
  fields: $PropsThatShouldNotBeForwarded.$props,
  keys: $PropsThatShouldNotBeForwarded.$propKeys,
);
