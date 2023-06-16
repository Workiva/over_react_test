// @dart = 2.12
// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:html';
import 'dart:js';

const Duration _defaultTriggerTimeout = Duration(seconds: 3);

/// Dispatches a `transitionend` event when the CSS transition of the [element]
/// is complete. Returns a [Future] that completes after the event has been dispatched.
///
/// Used for testing components that rely on a `transitionend` event.
Future triggerTransitionEnd(Element element, {Duration timeout = _defaultTriggerTimeout}) {
  var eventFiredFuture = element.onTransitionEnd.first;

  // Use JS interop to construct a native TransitionEvent since Dart doesn't allow instantiating them directly.
  // TODO: move this to JS so we can use TransitionEvent constructor

  var jsElement = JsObject.fromBrowserObject(element);
  var jsDocument = JsObject.fromBrowserObject(document);

  JsObject jsEvent;
  try {
    // Dartium requires it actually to be a `TransitionEvent`, not `Event`.
    jsEvent = JsObject.fromBrowserObject(jsDocument.callMethod('createEvent', ['TransitionEvent']));
  } catch (_) {
    // Firefox only supports `TransitionEvent` constructor, but `Event` is fine since checked mode is disabled.
    jsEvent = JsObject.fromBrowserObject(jsDocument.callMethod('createEvent', ['Event']));
  }

  var eventName = Element.transitionEndEvent.getEventType(element);

  jsEvent.callMethod('initEvent', [eventName, true, true]);

  jsElement.callMethod('dispatchEvent', [jsEvent]);

  return eventFiredFuture.timeout(timeout,
      onTimeout: () => Future.error('Failed to trigger transitionend'));
}

/// Dispatches a `click` event to the specified [target].
///
/// Verifies that the [target] element is not a detached node.
void triggerDocumentClick(Element target) {
  triggerDocumentMouseEvent(target, 'click');
}

/// Dispatches a [MouseEvent] of type [event] to the specified [target].
///
/// Verifies that the [target] element is not a detached node.
void triggerDocumentMouseEvent(Element target, String event) {
  if (!document.documentElement!.contains(target)) {
    throw ArgumentError.value(target, 'target', 'Target should be attached to the document.');
  }

  target.dispatchEvent(MouseEvent(event));
}

/// Focuses the [target] and returns a [Future] when that `focus` event is fired.
///
/// Verifies that the [target] element is not a detached node.
///
/// This is necessary because IE 11 `focus` events are async.
///
/// See: <https://connect.microsoft.com/IE/feedback/details/2238257/ie11-focus-change-delayed-when-using-the-focus-method>.
Future triggerFocus(Element target, {Duration timeout = _defaultTriggerTimeout}) {
  if (!document.documentElement!.contains(target)) {
    throw ArgumentError.value(target, 'target', 'Target should be attached to the document.');
  }

  var completer = Completer()
    ..complete(target.onFocus.first);

  target.focus();

  return completer.future.timeout(timeout,
      onTimeout: () => Future.error('Failed to focus; try ensuring that your browser window is at the foreground'));
}
