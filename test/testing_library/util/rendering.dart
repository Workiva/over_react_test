import 'dart:async';

import 'package:over_react/over_react.dart';

import 'constants.dart';

part 'rendering.over_react.g.dart';

const validRoleInDom = 'button';
const validRoleNotInDom = 'tablist';

ReactElement elementsForQuerying(String uniqueName, {bool renderMultipleElsMatchingQuery}) {
  ReactElement renderEls(String _uniqueName) {
    _uniqueName ??= uniqueName;
    return (Dom.div()
      ..addTestId(_uniqueName)
      ..title = _uniqueName
      ..role = Role.presentation)(
      _uniqueName,
      (Dom.button()..type = 'button')(_uniqueName),
      (Dom.img()..alt = _uniqueName)(),
      (Dom.label()..htmlFor = '${_uniqueName}Input')(_uniqueName),
      (Dom.input()
        ..type = 'text'
        ..id = '${_uniqueName}Input'
        ..value = _uniqueName
        ..onChange = (_) {}
        ..placeholder = _uniqueName)(),
      Dom.div()(
        Dom.div()('bar 1'),
        '$_uniqueName foo',
      ),
      Dom.div()(
        Dom.div()('bar 2'),
        '$_uniqueName baz',
      ),
      Dom.p()(
        '$_uniqueName single byText match',
      ),
    );
  }

  renderMultipleElsMatchingQuery ??= false;

  if (renderMultipleElsMatchingQuery) {
    return Dom.div()(renderEls(uniqueName), renderEls('2$uniqueName'));
  }

  return renderEls(uniqueName);
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
