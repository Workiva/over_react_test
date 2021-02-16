@JS()
library over_react_test.src.testing_library.dom.queries.types;

import 'dart:async';
import 'dart:html' show Element;

import 'package:js/js.dart';
import 'package:react/react_client/js_backed_map.dart' show JsMap;

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';

@JS('rtl.queries')
external JsMap get defaultRtlQueries;

typedef Query = FutureOr<Element> Function(
  Element container,
  String selector,
  bool exact,
  /*String|bool*/ dynamic ignore,
  NormalizerFn Function(NormalizerOptions) normalizer,
  Duration timeout,
  Duration interval,
  Error Function(Error error) onTimeout,
  MutationObserverInit mutationObserverOptions,
);
