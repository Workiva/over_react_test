// @dart = 2.7

/// https://testing-library.com/docs/dom-testing-library/api-async/#waitfor
@JS()
library over_react_test.src.testing_library.dom.async.wait_for;

import 'dart:async';
import 'dart:html' show Element, MutationObserver, document;

import 'package:js/js.dart';
import 'package:over_react_test/src/testing_library/dom/pretty_dom.dart';
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/config/configure.dart' show getConfig;
import 'package:over_react_test/src/testing_library/util/error_message_utils.dart'
    show TestingLibraryAsyncTimeout, TestingLibraryElementError;
export 'package:over_react_test/src/testing_library/dom/async/types.dart' show JsMutationObserverOptions;

/// Calls the provided [expectation] on a given [interval] and/or when the [container] DOM changes,
/// completing only if it does not `throw`, or by `throw`ing if
/// the [timeout] expires before the [expectation] succeeds.
///
/// Similar to <https://testing-library.com/docs/dom-testing-library/api-async/#waitfor>, but designed to
/// work with the `dart:test` package's [expect] function and Dart [Future]s instead of JS `Promise`s.
///
/// * If you're waiting for an element to existing in the DOM, use a `findBy*` query instead.
/// * If you're waiting for an element to be removed from the DOM, use [waitForElementToBeRemoved] instead.
///
/// ## Options
///
/// ### container
///
/// The DOM node to attach the [MutationObserver] to. Defaults to `document.body`.
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<T> waitFor<T>(
  FutureOr<T> Function() expectation, {
  Element container,
  Duration timeout,
  Duration interval = const Duration(milliseconds: 50),
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) async {
  final config = getConfig();
  container ??= document.body;
  timeout ??= Duration(milliseconds: config.asyncUtilTimeout);
  onTimeout ??= (error) => error;

  /*Error*/ dynamic lastError;
  MutationObserver observer;
  Timer intervalTimer;
  Timer overallTimeoutTimer;
  Completer resultPending;
  final doneCompleter = Completer<T>();

  void onDone(dynamic error, FutureOr<T> result) {
    overallTimeoutTimer.cancel();
    intervalTimer.cancel();
    observer.disconnect();
    if (resultPending?.isCompleted == false) {
      resultPending.complete();
    }

    if (error != null) {
      doneCompleter.completeError(error);
    } else if (result is TestFailure) {
      doneCompleter.completeError(result);
    } else {
      doneCompleter.complete(result);
    }
  }

  FutureOr<Null> handleTimeout() {
    /*Error*/ dynamic error;
    if (lastError != null) {
      error = lastError;
    } else {
      error = TestingLibraryAsyncTimeout('Timed out in waitFor after ${timeout.inMilliseconds}ms.');
    }
    onDone(onTimeout(error), null);
  }

  FutureOr checkCallback([_]) async {
    if (resultPending != null && !resultPending.isCompleted) return;

    try {
      final result = expectation();
      if (result is Future<T>) {
        // Since we'll time out the expectation's future using the same `timeout` duration,
        // cancel the `overallTimeoutTimer` so that we don't fail with a generic `TestingLibraryAsyncTimeout`
        // before the specified `expectation` has a chance to fail with a more useful / contextual error.
        overallTimeoutTimer.cancel();
        resultPending = Completer();
        await result.then((resolvedValue) {
          resultPending.complete();
          onDone(null, resolvedValue);
        }, onError: (error) {
          onDone(error, result);
        }).timeout(timeout, onTimeout: handleTimeout);
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
  observer = MutationObserver((_, __) => checkCallback());
  observer.observe(
    container,
    childList: mutationObserverOptions.childList,
    attributes: mutationObserverOptions.attributes,
    characterData: mutationObserverOptions.characterData,
    subtree: mutationObserverOptions.subtree,
    attributeFilter: mutationObserverOptions.attributeFilter,
  );
  await checkCallback();

  return doneCompleter.future;
}

/// Waits for the removal of the single element returned from the [callback] to be removed from the DOM.
///
/// Similar to <https://testing-library.com/docs/dom-testing-library/api-async/#waitforelementtoberemoved>,
/// but designed to work with Dart [Future]s instead of JS `Promise`s.
///
/// To wait for multiple elements to be removed, use [waitForElementsToBeRemoved].
///
/// ## Options
///
/// ### container
///
/// An ancestor DOM node of the element you return from [callback].
/// This node will have a [MutationObserver] attached to it.
/// Defaults to `document.body`.
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<void> waitForElementToBeRemoved(
  FutureOr<Element> Function() callback, {
  Element container,
  Duration timeout,
  Duration interval = const Duration(milliseconds: 50),
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) async {
  container ??= document.body;

  final el = await callback();
  if (el == null) {
    throw TestingLibraryElementError('The callback must return a non-null Element.');
  }

  if (!container.contains(el)) {
    throw TestingLibraryElementError(
        'The element returned from the callback was not present in the container at the time waitForElementToBeRemoved() was called:\n\n'
        '${prettyDOM(container)}');
  }

  await waitFor(
    () => expect(container.contains(el), isFalse),
    container: container,
    timeout: timeout,
    interval: interval,
    onTimeout: onTimeout ??
        (error) {
          return TestingLibraryAsyncTimeout(
              'The element returned from the callback was still present in the container after ${timeout.inMilliseconds}ms:\n\n'
              '${prettyDOM(container)}');
        },
    mutationObserverOptions: mutationObserverOptions,
  );
}

/// Waits for the removal of all the elements returned from the [callback] to be removed from the DOM.
///
/// To wait for a single element to be removed, use [waitForElementToBeRemoved].
///
/// ## Options
///
/// ### container
///
/// An ancestor DOM node of the elements you return from [callback].
/// This node will have a [MutationObserver] attached to it.
/// Defaults to `document.body`.
///
/// {@macro sharedWaitForOptionsTimeoutDescription}
/// {@macro sharedWaitForOptionsIntervalDescription}
/// {@macro sharedWaitForOptionsOnTimeoutDescription}
/// {@macro sharedWaitForOptionsMutationObserverDescription}
Future<void> waitForElementsToBeRemoved(
  FutureOr<List<Element>> Function() callback, {
  Element container,
  Duration timeout,
  Duration interval = const Duration(milliseconds: 50),
  QueryTimeoutFn onTimeout,
  MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
}) async {
  container ??= document.body;
  final els = await callback();

  if (els == null || els.isEmpty) {
    throw TestingLibraryElementError('The callback must return one or more non-null Elements.');
  }

  for (var el in els) {
    if (!container.contains(el)) {
      throw TestingLibraryElementError(
          'One of the elements returned from the callback was not present in the container at the time waitForElementsToBeRemoved() was called:\n\n'
          '${prettyDOM(container)}');
    }
  }

  await Future.wait(els.map((el) => waitForElementToBeRemoved(() => el,
      container: container,
      timeout: timeout,
      interval: interval,
      onTimeout: onTimeout,
      mutationObserverOptions: mutationObserverOptions)));
}

@JS()
@anonymous
class WaitForOptions extends SharedJsWaitForOptions {
  external Element get container;
  external set container(Element value);
}
