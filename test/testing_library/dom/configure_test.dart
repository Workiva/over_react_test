@TestOn('browser')
library over_react_test.testing_library_test.dom.configure_test;

import 'package:over_react/over_react.dart';
import 'package:over_react_test/react_testing_library.dart' as rtl;
import 'package:over_react_test/src/testing_library/dom/config/configure.dart';
import 'package:test/test.dart';

main() {
  enableTestMode();

  group('getConfig()', () {
    group('returns the current configuration object', () {
      test('with the expected fields exposed', () {
        final config = rtl.getConfig();
        expect(config.asyncUtilTimeout, isA<int>());
        expect(config.computedStyleSupportsPseudoElements, isA<bool>());
        expect(config.defaultHidden, isA<bool>());
        expect(config.showOriginalStackTrace, isA<bool>());
        expect(config.throwSuggestions, isA<bool>());
        expect(config.getElementError, isA<Function>());
      });

      test('with the expected testIdAttribute value', () {
        expect(rtl.getConfig().testIdAttribute, defaultTestIdKey,
            reason: 'The value of Config.testIdAttribute should default to what we use in the Workiva ecosystem, '
                'rather than the `data-testid` value that the JS testing-library uses by default.');
      });
    });
  });

  group('configure()', () {
    test('updates the underlying JS config object as expected', () {
      final initialConfig = rtl.getConfig();
      rtl.configure(
          testIdAttribute: 'not-$defaultTestIdKey',
          asyncUtilTimeout: initialConfig.asyncUtilTimeout + 100,
          computedStyleSupportsPseudoElements: !initialConfig.computedStyleSupportsPseudoElements,
          defaultHidden: !initialConfig.defaultHidden,
          showOriginalStackTrace: !initialConfig.showOriginalStackTrace,
          throwSuggestions: !initialConfig.throwSuggestions,
          getElementError: (message, container) {
            final customMessage = [message, 'something custom'].join('\n\n');
            return TestFailure(customMessage);
          });

      final newConfig = rtl.getConfig();
      expect(newConfig.testIdAttribute, 'not-$defaultTestIdKey');
      expect(newConfig.asyncUtilTimeout, initialConfig.asyncUtilTimeout + 100);
      expect(newConfig.computedStyleSupportsPseudoElements, !initialConfig.computedStyleSupportsPseudoElements);
      expect(newConfig.defaultHidden, !initialConfig.defaultHidden);
      expect(newConfig.showOriginalStackTrace, !initialConfig.showOriginalStackTrace);
      expect(newConfig.throwSuggestions, !initialConfig.throwSuggestions);

      // TODO: Uncomment this test once the interop for getElementError is working
      // String failureMessage;
      // expect(() {
      //   try {
      //     rtl.screen.getByTestId('does-not-exist');
      //   } catch (err) {
      //     failureMessage = (err as TestFailure).message;
      //     rethrow;
      //   }
      // }, throwsA(TestFailure));
      // expect(failureMessage, endsWith('something custom'));

      // Set things back to the initial value
      jsConfigure(initialConfig);
    });
  });
}
