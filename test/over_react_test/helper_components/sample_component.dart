import 'dart:html';

import 'package:react/react_client/react_interop.dart';
import 'package:over_react/over_react.dart';

// ignore: uri_has_not_been_generated
part 'sample_component.over_react.g.dart';


@Factory()
// ignore: undefined_identifier
UiFactory<SampleProps> Sample =
// ignore: undefined_identifier
_$Sample;

@Props()
class _$SampleProps extends UiProps {
  bool foo;

  bool shouldAlwaysBeFalse;

  bool shouldError;

  bool shouldRenderChild;

  bool shouldRenderSecondChild;

  bool addExtraLogAndWarn;

  String shouldNeverBeNullString;
}

@Component2()
class SampleComponent extends UiComponent2<SampleProps> {
  @override
  Map get defaultProps => (newProps()
    ..shouldAlwaysBeFalse = false
    ..shouldError = false
    ..shouldRenderChild = false
    ..shouldNeverBeNullString = ''
    ..shouldRenderSecondChild = false
    ..addExtraLogAndWarn = false
  );

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
  componentDidMount() {
    window.console.warn('Just a lil warning');
  }

  @override
  render() {
    window.console.warn('A second warning');
    if (props.shouldError) {
      throw Error();
    } else {
      if (props.addExtraLogAndWarn) {
        window.console.log('Extra Log');
        window.console.warn('Extra Warn');
      }

      window.console.log('Logging a standard log');
      window.console.warn('And a third');
      return Dom.div()(
          (Dom.button()
            ..onClick = _handleOnClick
            ..addTestId('ort_sample_component_button')
          )(),
          props.children
      );
    }
  }

  void _handleOnClick(_) {
    window.console.log('Clicking');
    window.console.warn('I have been clicked');
  }
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class SampleProps extends _$SampleProps with _$SamplePropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForSampleProps;
}
