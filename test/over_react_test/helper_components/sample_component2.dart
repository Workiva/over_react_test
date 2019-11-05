import 'dart:html';

import 'package:react/react_client/react_interop.dart';
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
  bool foo;

  bool shouldAlwaysBeFalse;

  bool shouldError;

  bool shouldRenderChild;

  bool shouldRenderSecondChild;

  String shouldNeverBeNullString;
}

@Component2()
class SampleComponent2 extends UiComponent2<Sample2Props> {
  @override
  Map get defaultProps => (newProps()
    ..shouldAlwaysBeFalse = false
    ..shouldError = false
    ..shouldRenderChild = false
    ..shouldNeverBeNullString = ''
    ..shouldRenderSecondChild = false);

  @override
  get propTypes => {
    getPropKey((props) => props.foo, typedPropsFactory):
        (props, propName, _, __, ___) {

      if (props.foo == null) {
        return new PropError.required(propName);
      }

      return null;
    },
    getPropKey((props) => props.shouldNeverBeNullString, typedPropsFactory):
        (props, propName, _, __, ___) {
      print('never be null string');
      print(props.shouldNeverBeNullString);
      if (props.shouldNeverBeNullString == null) {
        return new PropError.value(props.shouldNeverBeNullString, propName);
      }

      return null;
    },
    getPropKey((props) => props.shouldAlwaysBeFalse, typedPropsFactory):
        (props, propName, _, __, ___) {

      if (props.shouldAlwaysBeFalse) {
        return new PropError.value(props.shouldAlwaysBeFalse, propName);
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

    print('should render child: ${props.shouldRenderChild}');
    window.console.warn('A second warning');
    if (props.shouldError) {
      throw Error();
    } else {
      window.console.log('Logging a standard log');
      window.console.warn('And a third');
      return Dom.div()(props.children);
    }
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class Sample2Props extends _$Sample2Props with _$Sample2PropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForSample2Props;
}
