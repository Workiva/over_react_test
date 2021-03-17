// @dart = 2.7
import 'package:dart_dev/dart_dev.dart';
import 'package:glob/glob.dart';

final config = {
  ...coreConfig,
  'format': FormatTool()
    ..exclude = [
      Glob('tool/dart_dev/**'),
      Glob('lib/src/over_react_test/**'),
      Glob('test/over_react_test/**'),
    ]
    ..formatterArgs = ['-l 120'],
};
