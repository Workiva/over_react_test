/// Returns whether `assert`s are enabled in the current runtime.
///
/// Unless the Dart SDK option to enable `assert`s in dart2js is configured,
/// this can also be used to indicate whether the JS was compiled using `dartdevc`.
bool assertsEnabled() {
  bool assertsEnabled = false;
  assert(assertsEnabled = true);
  return assertsEnabled;
}

/// Whether the current runtime supports `propTypes` matchers like `logsPropError`.
bool runtimeSupportsPropTypeWarnings() => assertsEnabled();
