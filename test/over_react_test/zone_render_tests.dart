import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

import 'custom_matchers_test.dart';
import 'helper_components/sample_component.dart';

main() {
  group('TestJacket mount', () {
    sharedZoneRenderTests((component, {autoTeardown = true}) =>
        mount(component, autoTearDown: autoTeardown));
  });

  group('render', () {
    sharedZoneRenderTests((component, {autoTeardown = true}) =>
        render(component, autoTearDown: autoTeardown));
  });

  group('renderAttachedToDocument', () {
    sharedZoneRenderTests((component, {autoTeardown = true}) =>
        renderAttachedToDocument(component, autoTearDown: autoTeardown));
  });
}

void sharedZoneRenderTests(Function renderFunction) {
  group('sharedZoneRenderTests:', () {
    test('Failing expects work in Component2 lifecycle methods', () {
      void testCallback() {
        expect(true, isFalse);
      }

      shouldFail(
          () => renderFunction(
              (Sample()..componentDidMountCallback = testCallback)()),
          returnsNormally,
          contains('threw TestFailure'));
    });

    group('Errors thrown when unmounting fail tests', () {
      // For this group, we need to test that an error is thrown during test
      // teardown. To do that, we rely on an error being thrown during unmount,
      // failing a test that should pass. The test also mutates variables outside
      // its local scope. We can then verify that those variables show that the
      // test had to be retried.
      var unmountThrewError = false;
      var tryCount = 0;

      group('when the unmount happens automatically', () {
        tearDownAll(() {
          unmountThrewError = false;
          tryCount = 0;
        });

        test('', () {
          if (unmountThrewError) {
            tryCount++;
            expect(true, isTrue);
          } else {
            unmountThrewError = true;
            tryCount++;
            renderFunction((Sample()..shouldErrorInUnmount = true)());
            expect(true, isTrue);
          }
        }, retry: 2);

        test('verify a retry was needed to pass the last test', () {
          expect(tryCount, 2);
          expect(unmountThrewError, isTrue);
        });
      });

      group('when the unmount happens explicitly', () {
        dynamic componentInstance;

        tearDown(() {
          try {
            if (componentInstance != null) componentInstance.unmount();
          } on NoSuchMethodError {
            unmount(componentInstance);
          }
        });

        tearDownAll(() {
          unmountThrewError = false;
          tryCount = 0;
        });

        test('', () {
          if (unmountThrewError) {
            tryCount++;
            expect(true, isTrue);
          } else {
            unmountThrewError = true;
            tryCount++;
            componentInstance =
                renderFunction((Sample()..shouldErrorInUnmount = true)());
            expect(true, isTrue);
          }
        }, retry: 2);

        test('verify a retry was needed to pass the last test', () {
          expect(tryCount, 2);
          expect(unmountThrewError, isTrue);
        });
      });
    });
  });
}
