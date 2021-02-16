@JS()
library over_react_test.src.testing_library.dom.async.types;

import 'package:js/js.dart';

@JS()
@anonymous
class SharedWaitForOptions {
  external int get timeout;
  external set timeout(int value);

  external int get interval;
  external set interval(int value);

  external dynamic get onTimeout;
  external set onTimeout(dynamic value);

  external MutationObserverInit get mutationObserverOptions;
  external set mutationObserverOptions(MutationObserverInit value);
}

@JS()
@anonymous
class MutationObserverInit {
  external bool get subtree;
  external set subtree(bool value);

  external bool get childList;
  external set childList(bool value);

  external bool get attributes;
  external set attributes(bool value);

  external bool get characterData;
  external set characterData(bool value);
}

MutationObserverInit get defaultMutationObserverOptions => _defaultMutationObserverOptions;
MutationObserverInit _defaultMutationObserverOptions = MutationObserverInit()
  ..subtree = true
  ..childList = true
  ..attributes = true
  ..characterData = true;
