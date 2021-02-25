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
/// matches of [MatchType] for [queryShouldMatchOn].
///
/// Exercises the 3 types of queries (queryBy, getBy and findBy) - which should be returned from
/// [getQueryByQuery], [getGetByQuery] and [getFindByQuery], respectively.
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
void testTextMatchTypes(
  String queryTypeName, {
  @required String textMatchArgName,
  @required String queryShouldMatchOn,
  @required Function Function() getQueryByQuery,
  @required Function Function() getGetByQuery,
  @required Function Function() getFindByQuery,
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

  group('when the $textMatchArgName argument is a', () {
    group('String (TextMatch.parse),', () {
      String fuzzyValue = getStringThatFuzzyMatches(queryShouldMatchOn);

      group('and exact = true (default),', () {
        group('and a failure/null or empty return value is expected for the', () {
          test('queryBy$queryTypeName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(getQueryByQuery()(validRoleNotInDom), isNull);
              } else if (textMatchArgName == 'name') {
                expect(getQueryByQuery()(validRoleInDom, name: fuzzyValue), isNull);
              }
            } else {
              expect(getQueryByQuery()(fuzzyValue), isNull);
            }
          });

          test('getBy$queryTypeName query', () {
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
                expect(() => getGetByQuery()(validRoleNotInDom),
                    toThrowErrorMatchingInlineSnapshotPattern(validRoleNotInDom));
              } else if (textMatchArgName == 'name') {
                expect(() => getGetByQuery()(validRoleInDom, name: fuzzyValue),
                    toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
              }
            } else {
              expect(() => getGetByQuery()(fuzzyValue), toThrowErrorMatchingInlineSnapshotPattern(fuzzyValue));
            }
          });

          test('findBy$queryTypeName query', () async {
            final query = getFindByQuery();
            if (queryTypeName == 'Role') {
              if (textMatchArgName == 'role') {
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

        group('returning the matching element from the', () {
          test('queryBy$queryTypeName query', () {
            if (queryTypeName == 'Role') {
              expect(getQueryByQuery()(validRoleInDom, name: queryShouldMatchOn), isA<Element>());
            } else {
              expect(getQueryByQuery()(queryShouldMatchOn), isA<Element>());
            }
          });

          test('getBy$queryTypeName query', () {
            if (queryTypeName == 'Role') {
              expect(getGetByQuery()(validRoleInDom, name: queryShouldMatchOn), isA<Element>());
            } else {
              expect(getGetByQuery()(queryShouldMatchOn), isA<Element>());
            }
          });

          test('findBy$queryTypeName query', () async {
            Element findByQueryReturnValue;

            if (queryTypeName == 'Role') {
              findByQueryReturnValue = await getFindByQuery()(validRoleInDom, name: queryShouldMatchOn);
            } else {
              findByQueryReturnValue = await getFindByQuery()(queryShouldMatchOn);
            }

            expect(findByQueryReturnValue, isA<Element>());
          }, timeout: asyncQueryTestTimeout);
        });
      });

      if (textMatchArgSupportsFuzzyMatching) {
        group('and exact = false,', () {
          group('and a failure/null return value is expected when calling the', () {
            test('queryBy$queryTypeName query', () {
              expect(getQueryByQuery()('somethingDifferentThatDoesNotMatch', exact: false), isNull);
            });

            test('getBy$queryTypeName query', () {
              expect(() => getGetByQuery()('somethingDifferentThatDoesNotMatch', exact: false),
                  toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch'));
            });

            test('findBy$queryTypeName query', () {
              final query = getFindByQuery();
              expect(() async => await query('somethingDifferentThatDoesNotMatch', exact: false),
                  toThrowErrorMatchingInlineSnapshotPattern('somethingDifferentThatDoesNotMatch'));
            }, timeout: asyncQueryTestTimeout);
          });

          group('and a match is found when calling the', () {
            test('queryBy$queryTypeName query', () {
              expect(getQueryByQuery()(fuzzyValue, exact: false), isA<Element>());
            });

            test('getBy$queryTypeName query', () {
              expect(getGetByQuery()(fuzzyValue, exact: false), isA<Element>());
            });

            test('findBy$queryTypeName query', () async {
              final findByQueryReturnValue = await getFindByQuery()(fuzzyValue, exact: false);
              expect(findByQueryReturnValue, isA<Element>());
            }, timeout: asyncQueryTestTimeout);
          });
        });
      }

      group('and normalizer is customized', () {
        // TODO
      });
    });

    group('RegExp (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        const badRegExPattern = "^somethingDifferentThatDoesNotMatch\$";

        test('queryBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()(RegExp(badRegExPattern)), isNull);
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: RegExp(badRegExPattern)), isNull);
            }
          } else {
            expect(getQueryByQuery()(RegExp(badRegExPattern)), isNull);
          }
        });

        test('getBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() => getGetByQuery()(RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            } else if (textMatchArgName == 'name') {
              expect(() => getGetByQuery()(validRoleInDom, name: RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            }
          } else {
            expect(() => getGetByQuery()(RegExp(badRegExPattern)),
                toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
          }
        });

        test('findBy$queryTypeName query', () async {
          final query = getFindByQuery();
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() async => await query(RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            } else if (textMatchArgName == 'name') {
              expect(() async => await query(validRoleInDom, name: RegExp(badRegExPattern)),
                  toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
            }
          } else {
            expect(() async => await query(RegExp(badRegExPattern)),
                toThrowErrorMatchingInlineSnapshotPattern('RegExp/$badRegExPattern/'));
          }
        }, timeout: asyncQueryTestTimeout);
      });

      group('returning the matching element from the', () {
        test('queryBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()(RegExp("^$validRoleInDom\$")), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$")), isA<Element>());
            }
          } else {
            expect(getQueryByQuery()(RegExp("^$queryShouldMatchOn\$")), isA<Element>());
          }
        });

        test('getBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getGetByQuery()(RegExp("^$validRoleInDom\$")), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getGetByQuery()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$")), isA<Element>());
            }
          } else {
            expect(getGetByQuery()(RegExp("^$queryShouldMatchOn\$")), isA<Element>());
          }
        });

        test('findBy$queryTypeName query', () async {
          Element findByQueryReturnValue;

          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              findByQueryReturnValue = await getFindByQuery()(RegExp("^$validRoleInDom\$"));
            } else if (textMatchArgName == 'name') {
              findByQueryReturnValue = await getFindByQuery()(validRoleInDom, name: RegExp("^$queryShouldMatchOn\$"));
            }
          } else {
            findByQueryReturnValue = await getFindByQuery()(RegExp("^$queryShouldMatchOn\$"));
          }

          expect(findByQueryReturnValue, isA<Element>());
        }, timeout: asyncQueryTestTimeout);
      });
    });

    group('Function (TextMatch.parse),', () {
      group('and a failure/null return value is expected for the', () {
        test('queryBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()((content, el) => content == validRoleNotInDom), isNull);
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: (content, el) => content != queryShouldMatchOn), isNull);
            }
          } else {
            expect(getQueryByQuery()((content, el) => content != queryShouldMatchOn), isNull);
          }
        });

        test('getBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() => getGetByQuery()((content, el) => content == validRoleNotInDom),
                  toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            } else if (textMatchArgName == 'name') {
              expect(() => getGetByQuery()(validRoleInDom, name: (content, el) => content != queryShouldMatchOn),
                  toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            }
          } else {
            expect(() => getGetByQuery()((content, el) => content != queryShouldMatchOn),
                toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
          }
        });

        test('findBy$queryTypeName query', () async {
          final query = getFindByQuery();
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(() async => await query((content, el) => content == validRoleNotInDom),
                  toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            } else if (textMatchArgName == 'name') {
              expect(() async => await query(validRoleInDom, name: (content, el) => content != queryShouldMatchOn),
                  toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
            }
          } else {
            expect(() async => await query((content, el) => content != queryShouldMatchOn),
                toThrowErrorMatchingInlineSnapshotPattern(TextMatch.functionValueErrorMessage));
          }
        }, timeout: asyncQueryTestTimeout);
      });

      group('returning the matching element from the', () {
        test('queryBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getQueryByQuery()((content, el) => content == validRoleInDom), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getQueryByQuery()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn),
                  isA<Element>());
            }
          } else {
            expect(getQueryByQuery()((content, el) => content == queryShouldMatchOn), isA<Element>());
          }
        });

        test('getBy$queryTypeName query', () {
          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              expect(getGetByQuery()((content, el) => content == validRoleInDom), isA<Element>());
            } else if (textMatchArgName == 'name') {
              expect(getGetByQuery()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn),
                  isA<Element>());
            }
          } else {
            expect(getGetByQuery()((content, el) => content == queryShouldMatchOn), isA<Element>());
          }
        });

        test('findBy$queryTypeName query', () async {
          Element findByQueryReturnValue;

          if (queryTypeName == 'Role') {
            if (textMatchArgName == 'role') {
              findByQueryReturnValue = await getFindByQuery()((content, el) => content == validRoleInDom);
            } else if (textMatchArgName == 'name') {
              findByQueryReturnValue =
                  await getFindByQuery()(validRoleInDom, name: (content, el) => content == queryShouldMatchOn);
            }
          } else {
            findByQueryReturnValue = await getFindByQuery()((content, el) => content == queryShouldMatchOn);
          }

          expect(findByQueryReturnValue, isA<Element>());
        }, timeout: asyncQueryTestTimeout);
      });
    });
  });
}
