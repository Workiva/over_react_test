@JS()
library over_react_test.src.testing_library.dom.matches.types;

import 'package:js/js.dart';

@JS()
@anonymous
class MatcherOptions {
  external bool get exact;
  external set exact(bool value);

  external NormalizerFn Function(NormalizerOptions) get normalizer;
  external set normalizer(NormalizerFn Function(NormalizerOptions) value);
}

@JS()
@anonymous
class SelectorMatcherOptions extends MatcherOptions {
  external String get selector;
  external set selector(String value);
}

@JS()
@anonymous
class NormalizerOptions {
  external bool get trim;
  external set trim(bool value);

  external bool get collapseWhitespace;
  external set collapseWhitespace(bool value);
}

typedef NormalizerFn = String Function(String);
