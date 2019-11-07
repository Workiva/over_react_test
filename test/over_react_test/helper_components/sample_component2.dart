import 'dart:html';

import 'package:over_react/over_react.dart';

// ignore: uri_has_not_been_generated
part 'sample_component2.over_react.g.dart';


@Factory()
// ignore: undefined_identifier
UiFactory<Sample2Props> Sample2 =
// ignore: undefined_identifier
_$Sample2;

@Props()
class _$Sample2Props extends UiProps {
  bool shouldNeverBeNull;
}

@Component2()
class SampleComponent2 extends UiComponent2<Sample2Props> {
  @override
  get propTypes => {
    getPropKey((props) => props.shouldNeverBeNull, typedPropsFactory):
        (props, propName, _, __, ___) {

      if (props.shouldNeverBeNull == null) {
        return new PropError.required(propName);
      }

      return null;
    },
  };

  @override
  void componentDidMount() {
    window.console.warn('Just a lil warning');
  }

  @override
  render() {
    window.console.warn('A second warning');

    window.console.log('Logging a standard log');
    window.console.warn('And a third');
    return Dom.div()(props.children);
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class Sample2Props extends _$Sample2Props with _$Sample2PropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForSample2Props;
}
