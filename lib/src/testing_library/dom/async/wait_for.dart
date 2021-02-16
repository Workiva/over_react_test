/// https://testing-library.com/docs/dom-testing-library/api-async/#waitfor
@JS()
library over_react_test.src.testing_library.dom.async.wait_for;

import 'dart:async';
import 'dart:html' show Element, MutationObserver, document, promiseToFuture;
import 'dart:js' show allowInterop;

import 'package:js/js.dart';
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show getConfig;

export 'package:over_react_test/src/testing_library/dom/async/types.dart' show MutationObserverInit;

/// Calls the provided [expectation] on a given [interval] and/or when the [container] DOM changes,
/// completing only if it does not throw a [TestFailure], or by throwing that [TestFailure] if
/// the [timeout] expires before the [expectation] succeeds.
///
/// Similar to <https://testing-library.com/docs/dom-testing-library/api-async/#waitfor>, but designed to
/// work with the Dart test package's [expect] function(s).
///
/// * If you're waiting for an element to existing in the DOM, using a `findBy*` query instead.
/// * If you're waiting for an element to be removed from the DOM, use [waitForElementToBeRemoved] instead.
///
/// * [timeout] defaults to 1000ms, or whatever value has been set globally for `Config.asyncUtilTimeout`.
/// * [interval] defaults to 50ms.
/// * [onTimeout] can be used to customize the [TestFailure] message.
Future<T> waitFor<T>(
  FutureOr<T> Function() expectation, {
  Element container,
  Duration timeout,
  Duration interval = const Duration(milliseconds: 50),
  TestFailure Function(TestFailure originalError) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  final config = getConfig();
  container ??= document.documentElement;
  timeout ??= Duration(milliseconds: config.asyncUtilTimeout);
  onTimeout ??= (error) {
    // final elementError = config.getElementError(error.message, container);
    // return TestFailure(JsBackedMap.fromJs(elementError)['message'])
    // debugger();
    return error;
  };
  mutationObserverOptions ??= defaultMutationObserverOptions;

  TestFailure lastError;
  MutationObserver observer;
  Timer intervalTimer;
  Timer overallTimeoutTimer;
  final doneCompleter = Completer();

  void onDone(error, result) {
    overallTimeoutTimer.cancel();
    intervalTimer.cancel();
    observer.disconnect();

    if (error != null) {
      doneCompleter.completeError(error);
    } else {
      doneCompleter.complete(result);
    }
  }

  void handleTimeout() {
    TestFailure error;
    if (lastError != null) {
      error = lastError;
    } else {
      error = TestFailure('Timed out in waitFor.');
    }
    onDone(onTimeout(error), null);
  }

  Completer resultPending;
  void checkCallback(_) {
    if (resultPending != null && !resultPending.isCompleted) return;

    try {
      final result = expectation();
      if (result is Future) {
        resultPending = Completer();
        (result as Future).then((resolvedValue) {
          resultPending.complete();
          onDone(null, resolvedValue);
        }, onError: (error) {
          resultPending.completeError(error);
          lastError = error;
        });
      } else {
        onDone(null, result);
      }
      // If `callback` throws, wait for the next mutation, interval, or timeout.
    } catch (error) {
      // Save the most recent callback error to reject the promise with it in the event of a timeout
      lastError = error;
    }
  }

  overallTimeoutTimer = Timer(timeout, handleTimeout);

  intervalTimer = Timer.periodic(interval, checkCallback);
  observer = MutationObserver((_, __) => checkCallback(null));
  observer.observe(
    container,
    childList: mutationObserverOptions.childList,
    attributes: mutationObserverOptions.attributes,
    characterData: mutationObserverOptions.characterData,
    subtree: mutationObserverOptions.subtree,
  );
  checkCallback(null);

  return doneCompleter.future;
}

Future<void> waitForElementToBeRemoved(
  FutureOr<Element> Function() callback, {
  Element container,
  Duration timeout,
  Duration interval,
  TestFailure Function(/*JsError*/ dynamic error) onTimeout,
  MutationObserverInit mutationObserverOptions,
}) {
  final waitForOptions = WaitForOptions();
  if (container != null) waitForOptions.container = container;
  if (timeout != null) waitForOptions.timeout = timeout.inMilliseconds;
  if (interval != null) waitForOptions.interval = interval.inMilliseconds;
  // TODO: We would have to build dart error => js error conversion logic here
  if (onTimeout != null) waitForOptions.onTimeout = allowInterop(onTimeout);
  if (mutationObserverOptions != null) waitForOptions.mutationObserverOptions = mutationObserverOptions;

  // TODO: How would the allowInterop(callback) work if it was a Dart future - with the JS function expecting a Promise?
  return promiseToFuture(_waitForElementToBeRemoved(allowInterop(callback), waitForOptions));
}

// @JS('rtl.waitFor')
// external /*Promise<T>*/ _waitFor(/*Promise<T> || T*/ Function() callback, WaitForOptions options);

@JS('rtl.waitForElementToBeRemoved')
external /*Promise<void>*/ _waitForElementToBeRemoved(
    /*Promise<void> || void*/ Function() callback,
    WaitForOptions options);

@JS()
@anonymous
class WaitForOptions extends SharedWaitForOptions {
  external Element get container;
  external set container(Element value);
}
