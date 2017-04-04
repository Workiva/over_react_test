import 'package:test/test.dart';
import 'package:ui_test_utils/ui_test_utils.dart';

/// Main entry point for string_util testing
main() {
  test('screamingSnakeToSpinal replaces all underscores with dashes and makes the string lowercase', () {
    expect(screamingSnakeToSpinal('TESTING_THE-screaming-snake_TO_spinal-method'),
        'testing-the-screaming-snake-to-spinal-method'
    );
  });
}
