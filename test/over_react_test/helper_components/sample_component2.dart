// @dart = 2.14
import 'dart:html';

import 'package:over_react/over_react.dart';

part 'sample_component2.over_react.g.dart';

UiFactory<Sample2Props> Sample2 = castUiFactory(_$Sample2); // ignore: undefined_identifier

mixin Sample2Props on UiProps {
  late bool shouldNeverBeNull;
}

class SampleComponent2 extends UiComponent2<Sample2Props> {
  @override
  get propTypes => {
        keyForProp((p) => p.shouldNeverBeNull): (props, info) {
          if (props.shouldNeverBeNull == null) {
            return PropError.required(info.propName);
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
