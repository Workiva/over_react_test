import 'dart:async';
import 'dart:html';

import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:over_react_test/src/testing_library/dom/matches/types.dart' show TextMatch;

import '../../../util/constants.dart';
import '../../../util/matchers.dart';
import '../../../util/rendering.dart';

String getStringThatFuzzyMatches(String exactValue) => exactValue.substring(2);

/// Tests both success and failure scenarios for queries with [textMatchArgName] that utilize
/// [TextMatch.parse] to allow `String`, `RegExp` and `Function`s as values to find one or more
/// matches of type [E] for [queryShouldMatchOn].
///
/// Exercises the 3 types of queries (queryBy, getBy and findBy) - which should be returned from
/// the value of each key in [queryQueriesByName], [getQueriesByName] and [findQueriesByName], respectively.
///
/// [getExpectedPrettyDom] should return the return value of calling `prettyDOM` with
/// the `container` of a `RenderResult` like so:
///
/// ```dart
/// getExpectedPrettyDom: () => prettyDOM(someRenderResult.container)
/// ```
///
/// For tests that exercise failure scenarios, provide a [failureSnapshotPattern] that
/// represents what the error message displayed to the user should contain, using
/// the [valueNotFoundPlaceholder] within the pattern to represent where the value of
/// the argument named [textMatchArgName] should be in the message. Check out some
/// uses of `testTextMatchTypes` in places like `hasQueriesScopedTo()` for practical examples.
///
/// If the query does not support `MatcherOptions.exact`, set [textMatchArgSupportsFuzzyMatching] to `false`.
@isTestGroup
void testTextMatchTypes<E extends Element>(
  String queryTypeName, {
  @required String textMatchArgName,
  @required String queryShouldMatchOn,
  @required Map<String, Function Function()> queryQueriesByName,
  @required Map<String, Function Function()> getQueriesByName,
  @required Map<String, Function Function()> findQueriesByName,
  @required String Function() getExpectedPrettyDom,
  bool textMatchArgSupportsFuzzyMatching = true,
  String failureSnapshotPattern,
}) {
  Matcher toThrowErrorMatchingInlineSnapshotPattern(String valueExpectedButNotFound) {
    Matcher containsMatcher;
    if (failureSnapshotPattern != null) {
      containsMatcher = buildContainsPatternUsing(failureSnapshotPattern, valueExpectedButNotFound);
    } else {
      containsMatcher = contains(valueExpectedButNotFound);
    }

    // When running only a single test, if the query is an async one,
    // RenderResult.container will not be accurate when called - so `expectedPrettyDom` will be null.
    final expectedPrettyDom = getExpectedPrettyDom();
    final stringPrettyDomMatcher = expectedPrettyDom != null ? endsWith(expectedPrettyDom) : null;
    return toThrowErrorMatchingInlineSnapshot(containsMatcher, stringPrettyDomMatcher);
  }

  Matcher getExpectedMatcherForFailedQuery(String queryName) {
    return queryName.contains('All') ? isEmpty : isNull;
  }

  Matcher getExpectedMatcherForSuccessfulQuery(String queryName) {
    return queryName.contains('All') ? isA<List<E>>() : isA<E>();
  }

  group('when the $textMatchArgName argument is a', () {
    group('String (TextMatch.parse),', () {
      String fuzzyValue = getStringThatFuzzyMatches(queryShouldMatchOn);

      group('and exact = true (default),', () {
        group('and a failure/null or empty return value is expected for the', () {
          queryQueriesByName.forEach((queryName, queryGetter) {
            test('$queryName query', () {
              if (queryTypeName == 'Role') {
                if (textMatchArgName == 'role') {
                  expect(queryGetter()(validRoleNotInDom), getExpectedMatcherForFailedQuery(queryName));
                } else if (textMatchArgName == 'name') {
                  expect(queryGetter()(validRoleInDom, name: fuzzyValue), getExpectedMatcherForFailedQuery(queryName));
                }
              } else {
                expect(queryGetter()(fuzzyValue), getExpectedMatcherForFailedQuery(queryName));
              }
            });
          });

          getQueriesByName.forEach((queryName, queryGetter) {
            test('$queryName query', () {
              if (queryTypeName == 'Role') {
                if (textMatchArgName == 'role') {
                  expect(() => queryGetter()(validRoleNotInDom),
                      toThrowErrorMatchingInlineSnapshotPattern(validRoleNotInDom));
                } else if (textMatchArgName == 'name') {
                  expect(() => queryGetter()(validRoleInDom, name: fuzzyValue),
                      toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
                }
              } else {
                expect(() => queryGetter()(fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
              }
            });
          });

          findQueriesByName.forEach((queryName, queryGetter) {
            test('$queryName query', () async {
              final query = queryGetter();
              if (queryTypeName == 'Role') {
                if (textMatchArgName == 'role') {
                  // TODO: Can this be switched to `query(fuzzyValue)` now that the async error message race conditions are resolved? If so, use a var to declare `toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue)` as `throwsWithExpectedFailureMessage`
                  expect(() async => await query(validRoleNotInDom),
                      toThrowErrorMatchingInlineSnapshotPattern(validRoleNotInDom));
                } else if (textMatchArgName == 'name') {
                  expect(() async => await query(validRoleInDom, name: fuzzyValue),
                      toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
                }
              } else {
                expect(() async => await query(fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
              }
            }, timeout: asyncQueryTestTimeout);
          });
        });

        group('returning the matching element from the', () {
          queryQueriesByName.forEach((queryName, queryGetter) {
            test('$queryName query', () {
              if (queryTypeName == 'Role') {
                expect(queryGetter()(validRoleInDom, name: queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
              } else {
                expect(queryGetter()(queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
              }
            });
          });

          getQueriesByName.forEach((queryName, queryGetter) {
            test('$queryName query', () {
              if (queryTypeName == 'Role') {
                expect(queryGetter()(validRoleInDom, name: queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
              } else {
                expect(queryGetter()(queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
              }
            });
          });

          findQueriesByName.forEach((queryName, queryGetter) {
            test('$queryName query', () async {
              dynamic findByQueryReturnValue;

              if (queryTypeName == 'Role') {
                findByQueryReturnValue = await queryGetter()(validRoleInDom, name: queryShouldMatchOn);
              } else {
                findByQueryReturnValue = await queryGetter()(queryShouldMatchOn);
              }

              expect(findByQueryReturnValue, getExpectedMatcherForSuccessfulQuery(queryName));
            }, timeout: asyncQueryTestTimeout);
          });
        });
      });

      if (textMatchArgSupportsFuzzyMatching) {
        group('and exact = false,', () {
          group('and a failure/null return value is expected when calling the', () {
            queryQueriesByName.forEach((queryName, queryGetter) {
              test('$queryName query', () {
                expect(queryGetter()('somethingDifferentThatDoesNotMatch', exact: false), getExpectedMatcherForFailedQuery(queryName));
              });
            });

            getQueriesByName.forEach((queryName, queryGetter) {
              test('$queryName query', () {
                expect(() => queryGetter()('somethingDifferentThatDoesNotMatch', exact: false),
                    toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch'));
              });
            });

            findQueriesByName.forEach((queryName, queryGetter) {
              test('$queryName query', () async {
                final query = queryGetter();
                expect(() async => await query('somethingDifferentThatDoesNotMatch', exact: false),
                    toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch'));
              }, timeout: asyncQueryTestTimeout);
            });
          });

          group('and a match is found when calling the', () {
            queryQueriesByName.forEach((queryName, queryGetter) {
              test('$queryName query', () {
                expect(queryGetter()(fuzzyValue, exact: false), getExpectedMatcherForSuccessfulQuery(queryName));
              });
            });

            getQueriesByName.forEach((queryName, queryGetter) {
              test('$queryName query', () {
                expect(queryGetter()(fuzzyValue, exact: false), getExpectedMatcherForSuccessfulQuery(queryName));
              });
            });

            findQueriesByName.forEach((queryName, queryGetter) {
              test('$queryName query', () async {
                final query = queryGetter();
                final findByQueryReturnValue = await query(fuzzyValue, exact: false);
                expect(findByQueryReturnValue, getExpectedMatcherForSuccessfulQuery(queryName));
              }, timeout: asyncQueryTestTimeout);
            });
          });
        });
      }

      group('and normalizer is customized', () {
        // TODO
      });
    });

    group('RegExp (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        const badRegExPattern = '^somethingDifferentThatDoesNotMatch\$';
        final throwsWithExpectedFailureMessage = toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/');

        queryQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(queryGetter()(RegExp(badRegExPattern)), getExpectedMatcherForFailedQuery(queryName));
              } else if (textMatchArgName == 'name') {
                expect(queryGetter()(validRoleInDom, name: RegExp(badRegExPattern)), getExpectedMatcherForFailedQuery(queryName));
              }
            } else {
              expect(queryGetter()(RegExp(badRegExPattern)), getExpectedMatcherForFailedQuery(queryName));
            }
          });
        });

        getQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() => queryGetter()(RegExp(badRegExPattern)), throwsWithExpectedFailureMessage);
              } else if (textMatchArgName == 'name') {
                expect(() => queryGetter()(validRoleInDom, name: RegExp(badRegExPattern)), throwsWithExpectedFailureMessage);
              }
            } else {
              expect(() => queryGetter()(RegExp(badRegExPattern)), throwsWithExpectedFailureMessage);
            }
          });
        });

        findQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () async {
            final query = queryGetter();
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() async => await query(RegExp(badRegExPattern)), throwsWithExpectedFailureMessage);
              } else if (textMatchArgName == 'name') {
                expect(() async => await query(validRoleInDom, name: RegExp(badRegExPattern)),
                    throwsWithExpectedFailureMessage);
              }
            } else {
              expect(() async => await query(RegExp(badRegExPattern)), throwsWithExpectedFailureMessage);
            }
          }, timeout: asyncQueryTestTimeout);
        });
      });

      group('returning the matching element from the', () {
        queryQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(queryGetter()(RegExp("^$validRoleInDom\$")), getExpectedMatcherForSuccessfulQuery(queryName));
              } else if (textMatchArgName == 'name') {
                expect(queryGetter()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$")), getExpectedMatcherForSuccessfulQuery(queryName));
              }
            } else {
              expect(queryGetter()(RegExp("^$queryShouldMatchOn\$")), getExpectedMatcherForSuccessfulQuery(queryName));
            }
          });
        });

        getQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(queryGetter()(RegExp("^$validRoleInDom\$")), getExpectedMatcherForSuccessfulQuery(queryName));
              } else if (textMatchArgName == 'name') {
                expect(queryGetter()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$")), getExpectedMatcherForSuccessfulQuery(queryName));
              }
            } else {
              expect(queryGetter()(RegExp("^$queryShouldMatchOn\$")), getExpectedMatcherForSuccessfulQuery(queryName));
            }
          });
        });

        findQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () async {
            dynamic findByQueryReturnValue;

            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                findByQueryReturnValue = await queryGetter()(RegExp("^$validRoleInDom\$"));
              } else if (textMatchArgName == 'name') {
                findByQueryReturnValue = await queryGetter()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$"));
              }
            } else {
              findByQueryReturnValue = await queryGetter()(RegExp("^$queryShouldMatchOn\$"));
            }

            expect(findByQueryReturnValue, getExpectedMatcherForSuccessfulQuery(queryName));
          }, timeout: asyncQueryTestTimeout);
        });
      });
    });

    group('Function (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        final throwsWithExpectedFailureMessage = toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage);

        queryQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(queryGetter()((content, el) => content == validRoleNotInDom), getExpectedMatcherForFailedQuery(queryName));
              } else if (textMatchArgName == 'name') {
                expect(queryGetter()(validRoleInDom, name: (content, el) => content != queryShouldMatchOn), getExpectedMatcherForFailedQuery(queryName));
              }
            } else {
              expect(queryGetter()((content, el) => content != queryShouldMatchOn), getExpectedMatcherForFailedQuery(queryName));
            }
          });
        });

        getQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() => queryGetter()((content, el) => content == validRoleNotInDom),
                    throwsWithExpectedFailureMessage);
              } else if (textMatchArgName == 'name') {
                expect(() => queryGetter()(validRoleInDom, name: (content, el) => content != queryShouldMatchOn),
                    throwsWithExpectedFailureMessage);
              }
            } else {
              expect(() => queryGetter()((content, el) => content != queryShouldMatchOn), throwsWithExpectedFailureMessage);
            }
          });
        });

        findQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () async {
            final query = queryGetter();
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() async => await query((content, el) => content == validRoleNotInDom), throwsWithExpectedFailureMessage);
              } else if (textMatchArgName == 'name') {
                expect(() async => await query(validRoleInDom, name: (content, el) => content == validRoleNotInDom),
                    throwsWithExpectedFailureMessage);
              }
            } else {
              expect(() async => await query((content, el) => content == validRoleNotInDom), throwsWithExpectedFailureMessage);
            }
          }, timeout: asyncQueryTestTimeout);
        });
      });

      group('returning the matching element from the', () {
        queryQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(queryGetter()((content, el) => content == validRoleInDom), getExpectedMatcherForSuccessfulQuery(queryName));
              } else if (textMatchArgName == 'name') {
                expect(queryGetter()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
              }
            } else {
              expect(queryGetter()((content, el) => content == queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
            }
          });
        });

        getQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(queryGetter()((content, el) => content == validRoleInDom), getExpectedMatcherForSuccessfulQuery(queryName));
              } else if (textMatchArgName == 'name') {
                expect(queryGetter()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
              }
            } else {
              expect(queryGetter()((content, el) => content == queryShouldMatchOn), getExpectedMatcherForSuccessfulQuery(queryName));
            }
          });
        });

        findQueriesByName.forEach((queryName, queryGetter) {
          test('$queryName query', () async {
            dynamic findByQueryReturnValue;

            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                findByQueryReturnValue = await queryGetter()((content, el) => content == validRoleInDom);
              } else if (textMatchArgName == 'name') {
                findByQueryReturnValue = await queryGetter()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn);
              }
            } else {
              findByQueryReturnValue = await queryGetter()((content, el) => content == queryShouldMatchOn);
            }

            expect(findByQueryReturnValue, getExpectedMatcherForSuccessfulQuery(queryName));
          }, timeout: asyncQueryTestTimeout);
        });
      });
    });
  });
}
