// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jacket_test.dart';

// **************************************************************************
// OverReactBuilder (package:over_react/src/builder.dart)
// **************************************************************************

// React component factory implementation.
//
// Registers component implementation and links type meta to builder factory.
final $SampleComponentFactory = registerComponent(() => new _$SampleComponent(),
    builderFactory: Sample,
    componentClass: SampleComponent,
    isWrapper: false,
    parentType: null,
    displayName: 'Sample');

abstract class _$SamplePropsAccessorsMixin implements _$SampleProps {
  @override
  Map get props;

  /// <!-- Generated from [_$SampleProps.foo] -->
  @override
  bool get foo =>
      props[_$key__foo___$SampleProps] ??
      null; // Add ` ?? null` to workaround DDC bug: <https://github.com/dart-lang/sdk/issues/36052>;
  /// <!-- Generated from [_$SampleProps.foo] -->
  @override
  set foo(bool value) => props[_$key__foo___$SampleProps] = value;
  /* GENERATED CONSTANTS */
  static const PropDescriptor _$prop__foo___$SampleProps =
      const PropDescriptor(_$key__foo___$SampleProps);
  static const String _$key__foo___$SampleProps = 'SampleProps.foo';

  static const List<PropDescriptor> $props = const [_$prop__foo___$SampleProps];
  static const List<String> $propKeys = const [_$key__foo___$SampleProps];
}

const PropsMeta _$metaForSampleProps = const PropsMeta(
  fields: _$SamplePropsAccessorsMixin.$props,
  keys: _$SamplePropsAccessorsMixin.$propKeys,
);

_$$SampleProps _$Sample([Map backingProps]) => new _$$SampleProps(backingProps);

// Concrete props implementation.
//
// Implements constructor and backing map, and links up to generated component factory.
class _$$SampleProps extends _$SampleProps
    with _$SamplePropsAccessorsMixin
    implements SampleProps {
  // This initializer of `_props` to an empty map, as well as the reassignment
  // of `_props` in the constructor body is necessary to work around an unknown ddc issue.
  // See <https://jira.atl.workiva.net/browse/CPLAT-4673> for more details
  _$$SampleProps(Map backingMap) : this._props = {} {
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
  ReactComponentFactoryProxy get componentFactory => $SampleComponentFactory;

  /// The default namespace for the prop getters/setters generated for this class.
  @override
  String get propKeyNamespace => 'SampleProps.';
}

abstract class _$SampleStateAccessorsMixin implements _$SampleState {
  @override
  Map get state;

  /// <!-- Generated from [_$SampleState.bar] -->
  @override
  bool get bar =>
      state[_$key__bar___$SampleState] ??
      null; // Add ` ?? null` to workaround DDC bug: <https://github.com/dart-lang/sdk/issues/36052>;
  /// <!-- Generated from [_$SampleState.bar] -->
  @override
  set bar(bool value) => state[_$key__bar___$SampleState] = value;
  /* GENERATED CONSTANTS */
  static const StateDescriptor _$prop__bar___$SampleState =
      const StateDescriptor(_$key__bar___$SampleState);
  static const String _$key__bar___$SampleState = 'SampleState.bar';

  static const List<StateDescriptor> $state = const [
    _$prop__bar___$SampleState
  ];
  static const List<String> $stateKeys = const [_$key__bar___$SampleState];
}

const StateMeta _$metaForSampleState = const StateMeta(
  fields: _$SampleStateAccessorsMixin.$state,
  keys: _$SampleStateAccessorsMixin.$stateKeys,
);

// Concrete state implementation.
//
// Implements constructor and backing map.
class _$$SampleState extends _$SampleState
    with _$SampleStateAccessorsMixin
    implements SampleState {
  // This initializer of `_state` to an empty map, as well as the reassignment
  // of `_state` in the constructor body is necessary to work around an unknown ddc issue.
  // See <https://jira.atl.workiva.net/browse/CPLAT-4673> for more details
  _$$SampleState(Map backingMap) : this._state = {} {
    this._state = backingMap ?? {};
  }

  /// The backing state map proxied by this class.
  @override
  Map get state => _state;
  Map _state;

  /// Let [UiState] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;
}

// Concrete component implementation mixin.
//
// Implements typed props/state factories, defaults `consumedPropKeys` to the keys
// generated for the associated props class.
class _$SampleComponent extends SampleComponent {
  @override
  _$$SampleProps typedPropsFactory(Map backingMap) =>
      new _$$SampleProps(backingMap);

  @override
  _$$SampleState typedStateFactory(Map backingMap) =>
      new _$$SampleState(backingMap);

  /// Let [UiComponent] internals know that this class has been generated.
  @override
  bool get $isClassGenerated => true;

  /// The default consumed props, taken from _$SampleProps.
  /// Used in [UiProps.consumedProps] if [consumedProps] is not overridden.
  @override
  final List<ConsumedProps> $defaultConsumedProps = const [
    _$metaForSampleProps
  ];
}
