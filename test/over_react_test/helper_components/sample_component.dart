// @dart = 2.14
import 'dart:html';

import 'package:over_react/over_react.dart';

part 'sample_component.over_react.g.dart';

UiFactory<SampleProps> Sample = castUiFactory(_$Sample); // ignore: undefined_identifier

mixin SampleProps on UiProps {
  late bool shouldNeverBeNull;

  late bool shouldAlwaysBeFalse;

  late bool shouldErrorInRender;

  late bool shouldErrorInMount;

  late bool shouldErrorInUnmount;

  late bool addExtraLogAndWarn;

  Function()? onComponentDidMount;

  late bool shouldLog;
}

class SampleComponent extends UiComponent2<SampleProps> {
  @override
  Map get defaultProps => (newProps()
    ..shouldAlwaysBeFalse = false
    ..shouldErrorInRender = false
    ..shouldErrorInMount = false
    ..shouldErrorInUnmount = false
    ..addExtraLogAndWarn = false
    ..shouldLog = true);

  @override
  get propTypes => {
        keyForProp((p) => p.shouldNeverBeNull): (props, info) {
          if (props.shouldNeverBeNull == null) {
            return PropError.required(info.propName, 'shouldNeverBeNull is necessary');
          }

          if (props.shouldLog == false && props.shouldAlwaysBeFalse == false) {
            return PropError.combination('shouldLog', 'shouldAlwaysBeFalse', 'logging is required');
          }

          if (props.shouldNeverBeNull == false) {
            return PropError('shouldNeverBeNull', 'should not be false');
          }

          return null;
        },
        keyForProp((p) => p.shouldAlwaysBeFalse): (props, info) {
          if (props.shouldAlwaysBeFalse) {
            return PropError.value(props.shouldAlwaysBeFalse, info.propName, 'shouldAlwaysBeFalse should never equal true.');
          }

          return null;
        },
      };

  @override
  componentDidMount() {
    window.console.warn('Just a lil warning');
    if (props.shouldErrorInMount) throw Error();
    props.onComponentDidMount?.call();
  }

  @override
  render() {
    window.console.warn('A second warning');
    if (props.shouldErrorInRender) {
      throw Error();
    } else {
      if (props.addExtraLogAndWarn) {
        window.console.log('Extra Log');
        window.console.warn('Extra Warn');
      }

      if (props.shouldLog) window.console.log('Logging a standard log');
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

    if (props.shouldErrorInUnmount) throw Error();
  }
}
