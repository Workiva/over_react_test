@JS()
library over_react_test.src.testing_library.dom.config.configure;

import 'package:js/js.dart';
import 'package:over_react_test/src/testing_library/dom/config/types.dart';

export 'package:over_react_test/src/testing_library/dom/config/types.dart' show Config;

@JS('rtl.configure')
external void configure([Config newConfig]);

@JS('rtl.getConfig')
external Config getConfig();
