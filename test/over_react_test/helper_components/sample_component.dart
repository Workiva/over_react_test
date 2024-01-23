import 'dart:html';

import 'package:over_react/over_react.dart';

part 'sample_component.over_react.g.dart';

UiFactory<SampleProps> Sample = castUiFactory(_$Sample); // ignore: undefined_identifier

mixin SampleProps on UiProps {
  bool? shouldNeverBeNull;

  bool? shouldAlwaysBeFalse;

  bool? shouldErrorInRender;

  bool? shouldErrorInMount;

  bool? shouldErrorInUnmount;

  bool? addExtraLogAndWarn;

  Function()? onComponentDidMount;

  bool? shouldLog;
}

class SampleComponent extends UiComponent2<SampleProps> {
  // Prop defaults
  bool get shouldAlwaysBeFalse => props.shouldAlwaysBeFalse ?? false;
  bool get shouldErrorInRender => props.shouldErrorInRender ?? false;
  bool get shouldErrorInMount => props.shouldErrorInMount ?? false;
  bool get shouldErrorInUnmount => props.shouldErrorInUnmount ?? false;
  bool get addExtraLogAndWarn => props.addExtraLogAndWarn ?? false;
  bool get shouldLog => props.shouldLog ?? true;

  @override
  get propTypes => {
        keyForProp((p) => p.shouldNeverBeNull): (props, info) {
          if (props.shouldNeverBeNull == null) {
            return PropError.required(info.propName, 'shouldNeverBeNull is necessary');
          }

          if (props.shouldLog == false && (props.shouldAlwaysBeFalse ?? false) == false) {
            return PropError.combination('shouldLog', 'shouldAlwaysBeFalse', 'logging is required');
          }

          if (props.shouldNeverBeNull == false) {
            return PropError('shouldNeverBeNull', 'should not be false');
          }

          return null;
        },
        keyForProp((p) => p.shouldAlwaysBeFalse): (props, info) {
          if (props.shouldAlwaysBeFalse ?? false) {
            return PropError.value(props.shouldAlwaysBeFalse, info.propName, 'shouldAlwaysBeFalse should never equal true.');
          }

          return null;
        },
      };

  @override
  componentDidMount() {
    window.console.warn('Just a lil warning');
    if (shouldErrorInMount) throw Error();
    props.onComponentDidMount?.call();
  }

  @override
  render() {
    window.console.warn('A second warning');
    if (shouldErrorInRender) {
      throw Error();
    } else {
      if (addExtraLogAndWarn) {
        window.console.log('Extra Log');
        window.console.warn('Extra Warn');
      }

      if (shouldLog) window.console.log('Logging a standard log');
      window.console.warn('And a third');
      return Dom.div()(
          (Dom.button()
            ..onClick = _handleOnClick
            ..addTestId('ort_sample_component_button'))(),
          props.children);
    }
  }

  void _handleOnClick(_) {
    window.console.log('Clicking');
    window.console.warn('I have been clicked');
  }

  @override
  void componentWillUnmount() {
    super.componentWillUnmount();

    if (shouldErrorInUnmount) throw Error();
  }
}
