@JS()
library over_react_test.src.testing_library.dom.matches.types;

import 'package:js/js.dart';

import 'package:over_react_test/src/testing_library/dom/matches/types.dart';

/// The default "normalizer" used to normalize the string query value provided
/// to a query by [trim]ming whitespace from the start and end of text, and collapsing
/// multiple adjacent whitespace characters into a single space ([collapseWhitespace]).
///
/// > See: <https://testing-library.com/docs/queries/about#normalization>
NormalizerFn getDefaultNormalizer({bool trim = true, collapseWhitespace = true}) {
  return _jsGetDefaultNormalizer(NormalizerOptions()
    ..trim = trim
    ..collapseWhitespace = collapseWhitespace);
}

@JS('rtl.getDefaultNormalizer')
external NormalizerFn _jsGetDefaultNormalizer(NormalizerOptions options);
