/// Utility function to convert `SCREAMING_SNAKE` strings into `spinal-case` equivalents.
String screamingSnakeToSpinal(String str) => str.replaceAll('_', '-').toLowerCase();
