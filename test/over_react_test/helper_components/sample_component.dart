import 'dart:html';

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
  bool shouldNeverBeNull;

  bool shouldAlwaysBeFalse;

  bool shouldError;

  bool addExtraLogAndWarn;

  bool shouldLog;
}

@Component2()
class SampleComponent extends UiComponent2<SampleProps> {
  @override
  Map get defaultProps => (newProps()
    ..shouldAlwaysBeFalse = false
    ..shouldError = false
    ..addExtraLogAndWarn = false
    ..shouldLog = true);

  @override
  get propTypes => {
        keyForProp((p) => p.shouldNeverBeNull): (props, info) {
          if (props.shouldNeverBeNull == null) {
            return PropError.required(info.propName, 'shouldNeverBeNull is necessary');
          }

          if (props.shouldLog == false && props.shouldAlwaysBeFalse == false) {
            return PropError.combination('shoudLog', 'shouldAlwaysBeFalse', 'logging is required');
          }

          if (props.shouldNeverBeNull == false) {
            return PropError('shouldNeverBeNull should not be false');
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
}

// AF-3369 This will be removed once the transition to Dart 2 is complete.
// ignore: mixin_of_non_class, undefined_class
class SampleProps extends _$SampleProps with _$SamplePropsAccessorsMixin {
  // ignore: undefined_identifier, undefined_class, const_initialized_with_non_constant_value
  static const PropsMeta meta = _$metaForSampleProps;
}
