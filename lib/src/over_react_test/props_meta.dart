
import 'package:over_react/over_react.dart';
import 'package:over_react_test/jacket.dart';

/// Returns the [UiComponent2.propsMeta] obtained by rendering [el].
///
/// Returns `null` if [el] does not render a UiComponent2 or does not use the
/// new mixin syntax (determined by whether accessing propsMeta throws).
PropsMetaCollection getPropsMeta(ReactElement el) {
  // Can't auto-tear down here because we're not inside a test.
  // Use a try-finally instead
  final jacket = mount(el, autoTearDown: false);
  try {
    final instance = jacket.getDartInstance();
    if (instance is UiComponent2) {
      try {
        // ignore: invalid_use_of_protected_member
        return instance.propsMeta;
      } catch (_) {}
    }

    return null;
  } finally {
    jacket.unmount();
  }
}
