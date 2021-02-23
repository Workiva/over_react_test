import 'dart:html' show Element;
import 'dart:js' show allowInterop;

import 'package:meta/meta.dart';
import 'package:over_react_test/src/testing_library/dom/async/types.dart';
import 'package:over_react_test/src/testing_library/dom/matches/types.dart';

/// An interface shared by all the individual query type mixins.
abstract class IQueries {
  @protected
  Element Function() get getContainerForScope;

  @protected
  MatcherOptions buildMatcherOptions({
    bool exact = true,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) {
    final matcherOptions = MatcherOptions()..exact = exact;
    if (normalizer != null) matcherOptions.normalizer = allowInterop(normalizer); // TODO: Is allowInterop necessary?

    return matcherOptions;
  }

  @protected
  MatcherOptions buildSelectorMatcherOptions({
    bool exact = true,
    String selector,
    NormalizerFn Function(NormalizerOptions) normalizer,
  }) {
    final matcherOptions = buildMatcherOptions(exact: exact, normalizer: normalizer);
    final selectorMatcherOptions = SelectorMatcherOptions()
      ..exact = matcherOptions.exact
      ..normalizer = matcherOptions.normalizer;
    if (selector != null) selectorMatcherOptions.selector = selector;

    return selectorMatcherOptions;
  }

  @protected
  SharedJsWaitForOptions buildWaitForOptions({
    Duration timeout,
    Duration interval,
    Error Function(Error error) onTimeout,
    MutationObserverOptions mutationObserverOptions = defaultMutationObserverOptions,
  }) {
    final waitForOptions = SharedJsWaitForOptions();
    if (timeout != null) waitForOptions.timeout = timeout.inMilliseconds;
    if (interval != null) waitForOptions.interval = interval.inMilliseconds;
    // if (onTimeout != null) waitForOptions.onTimeout = allowInterop(onTimeout); // TODO: We would have to build dart error => js error conversion logic here
    // ignore: invalid_use_of_protected_member
    if (mutationObserverOptions != null) waitForOptions.mutationObserverOptions = mutationObserverOptions.toJs();

    return waitForOptions;
  }
}
