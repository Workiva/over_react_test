// @dart=2.7
// ^ Do not remove until migrated to null safety. More info at https://wiki.atl.workiva.net/pages/viewpage.action?pageId=189370832
import 'dart:async';

import 'package:over_react_test/over_react_test.dart';
import 'package:react/react_client/react_interop.dart';
import 'package:test/test.dart';

import 'custom_matchers_test.dart';
import 'helper_components/sample_component.dart';

main() {
  group('TestJacket mount', () {
    sharedZoneRenderTests(mount);
  });

  group('render', () {
    sharedZoneRenderTests(render);
  });

  group('renderAttachedToDocument', () {
    sharedZoneRenderTests(renderAttachedToDocument);
  });
}

void sharedZoneRenderTests(Function(ReactElement element, {bool autoTearDown}) renderFunction) {
  group('sharedZoneRenderTests:', () {
    setUp(() {
      setComponentZone(Zone.root);
    });

    test(
        'Component lifecycle methods can call `expect` statements passed in within a callback',
        () {
      void testCallback() {
        expect(true, isFalse);
      }

      shouldFail(
          () => renderFunction(
              (Sample()..onComponentDidMount = testCallback)()),
          returnsNormally,
          contains('threw TestFailure'));
    });

    group('Errors thrown when unmounting fails tests', () {
      // For this group, we need to test that an error is thrown during test
      // teardown. To do that, we rely on an error being thrown during unmount,
      // failing a test that should pass. The test also mutates variables outside
      // its local scope. We can then verify that those variables show that the
      // test had to be retried.
      var shouldError = true;
      var tryCount = 0;

      group('when the unmount happens automatically', () {
        tearDownAll(() {
          shouldError = true;
          tryCount = 0;
        });

        test('', () {
          if (!shouldError) {
            tryCount++;
          } else {
            shouldError = false;
            tryCount++;
            renderFunction((Sample()..shouldErrorInUnmount = true)());
          }
        }, retry: 2);

        test('verify a retry was needed to pass the last test', () {
          expect(tryCount, 2);
        });
      });

      group('when the unmount happens explicitly', () {
        dynamic componentInstance;

        group('in the test', () {
          tearDownAll(() {
            shouldError = true;
            tryCount = 0;
          });

          test('', () {
            if (!shouldError) {
              tryCount++;
            } else {
              shouldError = false;
              tryCount++;
              componentInstance =
                  renderFunction((Sample()..shouldErrorInUnmount = true)(), autoTearDown: false);
            }

            componentInstance is TestJacket
                ? componentInstance.unmount()
                : unmount(componentInstance);
          }, retry: 2);

          test('verify a retry was needed to pass the last test', () {
            expect(tryCount, 2);
          });
        });

        group('in a tear down', () {
          tearDown(() {
            componentInstance is TestJacket
                ? componentInstance.unmount()
                : unmount(componentInstance);
          });

          tearDownAll(() {
            shouldError = true;
            tryCount = 0;
          });

          test('', () {
            if (!shouldError) {
              tryCount++;
            } else {
              shouldError = false;
              tryCount++;
              componentInstance =
                  renderFunction((Sample()..shouldErrorInUnmount = true)(), autoTearDown: false);
            }
          }, retry: 2);

          test('verify a retry was needed to pass the last test', () {
            expect(tryCount, 2);
          });
        });
      });
    });
  });
}
