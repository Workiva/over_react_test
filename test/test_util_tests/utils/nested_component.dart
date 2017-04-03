import 'package:over_react/over_react.dart';

@Factory()
UiFactory<NestedProps> Nested;

@Props()
class NestedProps extends UiProps {}

@Component()
class NestedComponent extends UiComponent<NestedProps> {
  @override
  render()  {
    return (Dom.div()..addTestId('outer'))(
      (Dom.div()
        ..addProps(copyUnconsumedProps())
        ..addTestId('inner')
      )()
    );
  }
}
