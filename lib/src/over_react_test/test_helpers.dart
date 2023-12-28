import 'dart:async';

import 'package:test/test.dart';

typedef TestFunction = void Function(String, FutureOr Function() callback);

TestFunction testFunction = test;
