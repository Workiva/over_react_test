@TestOn('browser')
library react_testing_library_test;

import 'dart:async';

import 'package:over_react/over_react.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import 'testing_library/dom/configure_test.dart' as configure_test;
import 'testing_library/dom/wait_for_test.dart' as wait_for_test;
import 'testing_library/react/render_test.dart' as render_test;

part 'react_testing_library_test.over_react.g.dart';

main() {
  enableTestMode();

  group('Testing Library', () {
    configure_test.main();
    wait_for_test.main();
    render_test.main();
  });
}

mixin DelayedDomNodeAppearanceProps on UiProps {
  @requiredProp
  Duration delayHiddenNodeRenderFor;
  Function() onHiddenNodeIsVisible;
}

UiFactory<DelayedDomNodeAppearanceProps> DelayedDomNodeAppearance = uiFunction(
  (props) {
    final shouldRenderHiddenNode = useState(false);

    useEffect(() {
      final timer = Timer(props.delayHiddenNodeRenderFor, () {
        shouldRenderHiddenNode.set(true);
      });

      return timer.cancel;
    }, const []);

    useEffect(() {
      if (shouldRenderHiddenNode.value) {
        props.onHiddenNodeIsVisible?.call();
      }
    }, [shouldRenderHiddenNode.value]);

    ReactElement _renderHiddenNode() {
      if (!shouldRenderHiddenNode.value) return null;

      return Dom.div()('hidden');
    }

    return Dom.div()(
      Dom.div()('visible'),
      _renderHiddenNode(),
    );
  },
  _$DelayedDomNodeAppearanceConfig, // ignore: undefined_identifier
);

mixin ControlledDomNodeAppearanceProps on UiProps {
  @requiredProp
  Duration delayHiddenNodeRenderFor;
  @requiredProp
  bool shouldRenderHiddenNode;
}

UiFactory<ControlledDomNodeAppearanceProps> ControlledDomNodeAppearance = uiFunction(
  (props) {
    final shouldRenderHiddenNode = useState(props.shouldRenderHiddenNode);

    useEffect(() {
      Timer timer;
      if (props.shouldRenderHiddenNode != shouldRenderHiddenNode.value) {
        timer = Timer(props.delayHiddenNodeRenderFor, () {
          shouldRenderHiddenNode.set(props.shouldRenderHiddenNode);
        });
      }

      return timer?.cancel;
    }, [props.shouldRenderHiddenNode, shouldRenderHiddenNode.value]);

    ReactElement _renderHiddenNode() {
      if (!shouldRenderHiddenNode.value) return null;

      return Dom.div()('willBeRemoved');
    }

    return Dom.div()(
      Dom.div()('visible'),
      _renderHiddenNode(),
    );
  },
  _$ControlledDomNodeAppearanceConfig, // ignore: undefined_identifier
);

mixin TestWrapperProps on UiProps {}

UiFactory<TestWrapperProps> TestWrapper = uiFunction(
  (props) {
    return props.children;
  },
  _$TestWrapperConfig, // ignore: undefined_identifier
);
