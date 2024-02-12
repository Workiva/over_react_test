// @dart=2.11

import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

main() {
  group('ReactUtil (unsound null safety)', () {
    group(
        'utilities with non-nullable arguments throw'
        ' when passed null in unsound null safety:', () {
      test('queryByTestId', () {
        expect(() => queryByTestId(null, 'unusedTestId'), throwsArgumentError);
      });

      test('queryAllByTestId', () {
        expect(
            () => queryAllByTestId(null, 'unusedTestId'), throwsArgumentError);
      });
    });
  });
}
