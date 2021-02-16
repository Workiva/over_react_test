@JS()
library over_react_test.src.testing_library.dom.pretty_dom;

import 'dart:html' show Element;

import 'package:js/js.dart';

String prettyDOM(
  Element dom,
  int maxLength, {
  bool callToJSON,
  bool escapeRegex,
  bool escapeString,
  bool highlight,
  int indent,
  int maxDepth,
  bool min,
  /*Plugins*/ plugins,
  bool printFunctionName,
  /*ThemeReceived*/ themeReceived,
}) {
  final options = OptionsReceived();
  if (callToJSON != null) options.callToJSON = callToJSON;
  if (escapeRegex != null) options.escapeRegex = escapeRegex;
  if (escapeString != null) options.escapeString = escapeString;
  if (highlight != null) options.highlight = highlight;
  if (indent != null) options.indent = indent;
  if (maxDepth != null) options.maxDepth = maxDepth;
  if (min != null) options.min = min;
  if (plugins != null) options.plugins = plugins;
  if (printFunctionName != null) options.printFunctionName = printFunctionName;
  if (themeReceived != null) options.themeReceived = themeReceived;

  return _prettyDOM(dom, maxLength, OptionsReceived());
}

@JS('rtl.prettyDOM')
external String _prettyDOM([
  dom,
  maxLength,
  OptionsReceived options,
]);

@JS()
@anonymous
class OptionsReceived {
  external bool get callToJSON;
  external set callToJSON(bool value);

  external bool get escapeRegex;
  external set escapeRegex(bool value);

  external bool get escapeString;
  external set escapeString(bool value);

  external bool get highlight;
  external set highlight(bool value);

  external int get indent;
  external set indent(int value);

  external int get maxDepth;
  external set maxDepth(int value);

  external bool get min;
  external set min(bool value);

  external /*Plugins*/ get plugins;
  external set plugins(/*Plugins*/ value);

  external bool get printFunctionName;
  external set printFunctionName(bool value);

  external /*ThemeReceived*/ get themeReceived;
  external set themeReceived(/*ThemeReceived*/ value);
}
