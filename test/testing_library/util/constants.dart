// @dart = 2.7

import 'package:test/test.dart' show Timeout;

const asyncQueryTimeout = Duration(milliseconds: 200);
final asyncQueryTestTimeout = Timeout(asyncQueryTimeout * 2);
