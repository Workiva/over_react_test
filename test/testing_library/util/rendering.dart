import 'dart:async';

import 'package:over_react/over_react.dart';

import 'constants.dart';

part 'rendering.over_react.g.dart';

const validRoleInDom = 'button';
const validRoleNotInDom = 'tablist';

ReactElement elementsForQuerying(String uniqueName) {
  return (Dom.div()
    ..addTestId(uniqueName)
    ..title = uniqueName
    ..role = Role.presentation)(
    uniqueName,
    (Dom.button()..type = 'button')(uniqueName),
    (Dom.img()..alt = uniqueName)(),
    (Dom.label()..htmlFor = '${uniqueName}Input')(uniqueName),
    (Dom.input()
      ..type = 'text'
      ..id = '${uniqueName}Input'
      ..value = uniqueName
      ..onChange = (_) {}
      ..placeholder = uniqueName)(),
    Dom.div()(
      Dom.div()('bar 1'),
      '$uniqueName foo',
    ),
    Dom.div()(
      Dom.div()('bar 2'),
      '$uniqueName baz',
    ),
  );
}

mixin DelayedRenderOfProps on UiProps {
  Duration delay;
  Function() onDidRenderAfterDelay;
}

/// Used to test findBy* queries and `waitFor`.
UiFactory<DelayedRenderOfProps> DelayedRenderOf = uiFunction(
  (props) {
    final delay = props.delay ?? asyncQueryTimeout;
    final shouldRenderChildren = useState(delay.inMilliseconds == 0 ? true : false);

    useEffect(() {
      final timer = Timer(delay, () {
        shouldRenderChildren.set(true);
      });

      return timer.cancel;
    }, const []);

    useEffect(() {
      if (shouldRenderChildren.value) {
        props.onDidRenderAfterDelay?.call();
      }
    }, [shouldRenderChildren.value]);

    dynamic _renderChildren() {
      if (!shouldRenderChildren.value) return null;

      return props.children;
    }

    return (Dom.div()
      ..addTestId('delayed-render-of-root')
      ..addUnconsumedDomProps(props, const []))(
      _renderChildren(),
    );
  },
  _$DelayedRenderOfConfig, // ignore: undefined_identifier
);
