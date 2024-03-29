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

import 'dart:html';
import 'dart:svg';

import 'package:over_react/over_react.dart';
import 'package:over_react_test/src/over_react_test/dart_util.dart';
import 'package:test/test.dart';
import 'package:over_react_test/over_react_test.dart';

import './helper_components/sample_component.dart';
import './helper_components/sample_component2.dart';

/// Main entry point for CustomMatchers testing
main() {
  group('CustomMatcher', () {
    late Element testElement;

    setUp(() {
      testElement = Element.div();
    });

    group('hasClasses', () {
      group('passes when', () {
        test('the element has the exact classes', () {
          testElement.className = 'class1 class2';
          shouldPass(testElement, hasClasses('class1 class2'));
        });

        test('the element has the exact classes (specified as an Iterable)', () {
          testElement.className = 'class1 class2';
          shouldPass(testElement, hasClasses(['class1', 'class2']));
        });

        test('the element has the exact classes with duplication', () {
          testElement.className = 'class1 class1 class2';
          shouldPass(testElement, hasClasses('class1 class2'));
        });

        test('the element has extraneous classes', () {
          testElement.className = 'class1 class2 class3';
          shouldPass(testElement, hasClasses('class1 class2'));
        });
      });

      group('fails when', () {
        test('the element has only some classes', () {
          testElement.className = 'class1';
          shouldFail(testElement, hasClasses('class1 class2'),
              'Expected: Element that has the classes: {class1, class2}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'class1\' which is missing classes: {class2}'
          );
        });

        test('the element has no classes', () {
          testElement.className = '';
          shouldFail(testElement, hasClasses('class1 class2'),
              'Expected: Element that has the classes: {class1, class2}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'\' which is missing classes: {class1, class2}'
          );
        });
      });

      test('throws an error when an invalid, non-class value is passed to the matcher', () {
        expect(() {
          hasClasses(Object());
        }, throwsArgumentError);
      });
    });

    group('hasExactClasses', () {
      group('passes when', () {
        test('the element has the exact classes', () {
          testElement.className = 'class1 class2';
          shouldPass(testElement, hasExactClasses('class1 class2'));
        });

        test('the element has the exact classes (specified as an Iterable)', () {
          testElement.className = 'class1 class2';
          shouldPass(testElement, hasExactClasses(['class1', 'class2']));
        });

        test('the element has the exact classes and is an SvgElement', () {
          // Test workaround for https://github.com/dart-lang/sdk/issues/36200.
          // This may be removed when the workaround is removed.
          testElement = SvgElement.svg('<svg class="class1 class2"/>');
          shouldPass(testElement, hasExactClasses(['class1', 'class2']));
        });
      });

      group('fails when', () {
        test('the element has the exact classes with duplication', () {
          testElement.className = 'class1 class1 class2';
          shouldFail(testElement, hasExactClasses('class1 class2'),
              'Expected: Element that has ONLY the classes: {class1, class2}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'class1 class1 class2\' which has extraneous classes: [class1]'
          );
        });

        test('the element has extraneous classes', () {
          testElement.className = 'class1 class2 class3';
          shouldFail(testElement, hasExactClasses('class1 class2'),
              'Expected: Element that has ONLY the classes: {class1, class2}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'class1 class2 class3\' which has extraneous classes: [class3]'
          );
        });

        test('the element has only some classes', () {
          testElement.className = 'class1';
          shouldFail(testElement, hasExactClasses('class1 class2'),
              'Expected: Element that has ONLY the classes: {class1, class2}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'class1\' which is missing classes: {class2}'
          );
        });

        test('the element has no classes', () {
          testElement.className = '';
          shouldFail(testElement, hasExactClasses('class1 class2'),
              'Expected: Element that has ONLY the classes: {class1, class2}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'\' which is missing classes: {class1, class2}'
          );
        });
      });

      test('throws an error when an invalid, non-class value is passed to the matcher', () {
        expect(() {
          hasExactClasses(Object());
        }, throwsArgumentError);
      });
    });

    group('excludesClasses', () {
      group('passes when', () {
        test('the element has none of the excluded classes', () {
          testElement.className = 'class1';
          shouldPass(testElement, excludesClasses('class2 class3'));
        });
      });

      group('fails when', () {
        test('the element has some of the excluded classes', () {
          testElement.className = 'class1 class2';
          shouldFail(testElement, excludesClasses('class2 class3'),
            'Expected: Element that does not have the classes: {class2, class3}'
            ' Actual: DivElement:<div>'
            ' Which: has className with value \'class1 class2\' which has unwanted classes: {class2}'
          );
        });

        test('the element has some of the excluded classes (specified as an Iterable)', () {
          testElement.className = 'class1 class2';
          shouldFail(testElement, excludesClasses(['class2', 'class3']),
            'Expected: Element that does not have the classes: {class2, class3}'
            ' Actual: DivElement:<div>'
            ' Which: has className with value \'class1 class2\' which has unwanted classes: {class2}'
          );
        });

        test('the element has all of the excluded classes', () {
          testElement.className = 'class1 class2 class3';
          shouldFail(testElement, excludesClasses('class2 class3'),
              'Expected: Element that does not have the classes: {class2, class3}'
              ' Actual: DivElement:<div>'
              ' Which: has className with value \'class1 class2 class3\' which has unwanted classes: {class2, class3}'
          );
        });
      });

      test('throws an error when an invalid, non-class value is passed to the matcher', () {
        expect(() {
          excludesClasses(Object());
        }, throwsArgumentError);
      });
    });

    group('hasToStringValue', () {
      test('passes when an object has an equal toString value', () {
        var someMap = {'foo': 'bar'};
        shouldPass(someMap, hasToStringValue(someMap.toString()));
      });

      test('passes when an object has a matching toString value', () {
        var someMap = {'foo': 'bar'};
        shouldPass(someMap, hasToStringValue(contains('foo')));
      });

      test('fails when an object does not have a matching toString value', () {
        var someMap = {'foo': 'bar'};
        shouldFail(someMap, hasToStringValue('baz'),
            contains('has toString() with value \'{foo: bar}\' which is different.'));
      });
    });

    group('hasProp', () {
      group('passes when the props are present in a', () {
        group('ReactElement', () {
          test('(DOM)', () {
            shouldPass((Dom.div()..id = 'test')(), hasProp('id', 'test'));
          });

          test('(Dart)', () {
            shouldPass((Wrapper()..id = 'test')(), hasProp('id', 'test'));
          });

          test('(JS composite)', () {
            shouldPass(testJsComponentFactory({'id': 'test'}), hasProp('id', 'test'));
          });
        });

        group('ReactComponent', () {
          test('(DOM)', () {
            shouldPass(render((Dom.div()..id = 'test')()), hasProp('id', 'test'));
          });

          test('(Dart)', () {
            shouldPass(render((Wrapper()..id = 'test')()), hasProp('id', 'test'));
          });

          test('(JS composite)', () {
            shouldPass(render(testJsComponentFactory({'id': 'test'})), hasProp('id', 'test'));
          });
        });

        test('react.Component', () {
          shouldPass(getDartComponent(render((Wrapper()..id = 'test')())), hasProp('id', 'test'));
        });

        test('Element', () {
          shouldPass(DivElement()..id = 'test', hasProp('id', 'test'));
        });
      });

      group('fails when the props are not present in a', () {
        final failMessagePattern = RegExp(r"Which: has props/attributes map with value .* which doesn't contain key 'id'");

        group('ReactElement', () {
          test('(DOM)', () {
            shouldFail(Dom.div()(), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(Dart)', () {
            shouldFail(Wrapper()(), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(JS composite)', () {
            shouldFail(testJsComponentFactory(), hasProp('id', 'test'), matches(failMessagePattern));
          });
        });

        group('ReactComponent', () {
          test('(DOM)', () {
            shouldFail(render(Dom.div()()), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(Dart)', () {
            shouldFail(render(Wrapper()()), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(JS composite)', () {
            shouldFail(render(testJsComponentFactory()), hasProp('id', 'test'), matches(failMessagePattern));
          });
        });
      });

      group('fails when the props are different in a', () {
        final failMessagePattern = RegExp(r"Which: has props/attributes map with value .* is different. Expected: test +Actual: different");

        group('ReactElement', () {
          test('(DOM)', () {
            shouldFail((Dom.div()..id = 'different')(), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(Dart)', () {
            shouldFail((Wrapper()..id = 'different')(), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(JS composite)', () {
            shouldFail(testJsComponentFactory({'id': 'different'}), hasProp('id', 'test'), matches(failMessagePattern));
          });
        });

        group('ReactComponent', () {
          test('(DOM)', () {
            shouldFail(render((Dom.div()..id = 'different')()), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(Dart)', () {
            shouldFail(render((Wrapper()..id = 'different')()), hasProp('id', 'test'), matches(failMessagePattern));
          });

          test('(JS composite)', () {
            shouldFail(render(testJsComponentFactory({'id': 'different'})), hasProp('id', 'test'), matches(failMessagePattern));
          });
        });
      });

      group('validates prop keys when matched agains DOM ReactElements,', () {
        group('not failing for', () {
          test('keys in DomPropsMixin', () {
            shouldPass(render((Dom.div()..id = 'test')()), hasProp('id', 'test'));
          });

          test('keys in SvgPropsMixin', () {
            shouldPass(render((Dom.circle()..fill = 'test')()), hasProp('fill', 'test'));
          });

          test('"data-" attributes', () {
            shouldPass(render((Dom.div()..addProp('data-test', 'test'))()), hasProp('data-test', 'test'));
          });

          test('"aria-" attributes', () {
            shouldPass(render((Dom.div()..addProp('aria-test', 'test'))()), hasProp('aria-test', 'test'));
          });
        });

        test('failing when the an unsupported prop is tested agains a DOM ReactElement', () {
          shouldFail(render(Dom.div()()), hasProp('notADomProp', 'test'), contains(
              'Cannot verify whether the `notADomProp` prop is available on a DOM ReactComponent. '
              'Only props in `DomPropsMixin`/`SvgPropsMixin` or starting with "data-"/"aria-" are supported.'
          ));
        });
      });
    });

    group('hasAttr', () {
      test('should pass when the element has the attribute set to the correct value', () {
        testElement.setAttribute('index', '1');
        shouldPass(testElement, hasAttr('index', '1'));
      });

      test('should fail when the element has the attribute set to the wrong value', () {
        testElement.setAttribute('index', '-1');
        shouldFail(testElement, hasAttr('index', '1'),
            'Expected: Element with "index" attribute that equals \'1\''
            ' Actual: DivElement:<div> Which: has attributes with value \'-1\' which is different.'
            ' Expected: 1'
            ' Actual: -1'
            ' ^ Differ at offset 0'
        );
      });
    });

    group('hasNodeName', () {
      test('should pass when the element has the nodeName', () {
        shouldPass(testElement, hasNodeName('DIV'));
        shouldPass(testElement, hasNodeName('div'));
      });

      test('should fail when the element has a different nodeName', () {
        shouldFail(testElement, hasNodeName('SPAN'),
            'Expected: Element with nodeName that is \'SPAN\' ignoring case'
            ' Actual: DivElement:<div>'
            ' Which: has nodeName with value \'DIV\''
        );
        shouldFail(testElement, hasNodeName('span'),
            'Expected: Element with nodeName that is \'span\' ignoring case'
            ' Actual: DivElement:<div>'
            ' Which: has nodeName with value \'DIV\''
        );
      });
    });

    group('isFocused:', () {
      group('attached node:', () {
        List<Element> allAttachedNodes = [];
        Element makeAttachedNode() {
          var node = DivElement()..tabIndex = 1;
          document.body!.append(node);

          allAttachedNodes.add(node);

          return node;
        }

        late Element attachedNode;

        setUp(() {
          attachedNode = makeAttachedNode();
        });

        tearDown(() {
          for (var node in allAttachedNodes) {
            node.remove();
          }
          allAttachedNodes.clear();
        });

        test('passes when an attached node is focused', () {
          attachedNode.focus();
          shouldPass(attachedNode, isFocused);
        });

        test('fails when the node is not focused', () {
          shouldFail(attachedNode, isFocused,
              contains('Which: is not focused; there is no element currently focused')
          );
        });

        test('fails when the node is not focused, but another node is instead', () {
          var otherNode = makeAttachedNode();
          otherNode.focus();

          shouldFail(attachedNode, isFocused,
              contains('Which: is not focused; the currently focused element is ')
          );

          otherNode.remove();
        });
      });

      group('provides a useful failure message when', () {
        test('the node is not attached to the DOM, and thus cannot be focused', () {
          var detachedNode = DivElement();
          shouldFail(detachedNode, isFocused, contains(
              'Which: is not attached to the document, and thus cannot be focused.'
              ' If testing with React, you can use `renderAttachedToDocument`.'
          ));
        });

        test('the matched item is not an element', () {
          shouldFail(null, isFocused,
              contains('Which: is not a valid Element.')
          );
        });
      });
    });

    group('LoggingFunctionMatcher', () {
      group('when passed a List of logs', () {
        late List<String> logs;

        setUp(() {
          logs = [
            'random log1',
            'random log2',
            'random log',
            'pizza',
            'nonsense',
            'Failed prop type: combination error',
          ];
        });

        group('- hasLog -', () {
          test('simple usage', () {
            shouldPass(logs, hasLog('pizza'));
          });

          test('when looking for a substring of a log', () {
            shouldPass(logs, hasLog('log2'));
          });

          test('when there are multiple of the same log', () {
            logs = ['random log', 'random log', 'nonense'];

            shouldPass(logs, hasLog('random log'));
          });
        });

        group('- logsToConsole -', () {
          test('when passed in a matcher instead of a String', () {
            shouldPass(logs, logsToConsole(anyElement(contains('nonsense'))));
          });

          test('simple usage when checking for specifically two logs', () {
            logs = ['random log1', 'random log2'];

            shouldPass(logs, logsToConsole([contains('random log1'), contains('random log2')]));
          });

          test('when passed in a matcher looking for multiple logs', () {
            shouldPass(logs, logsToConsole(containsAll([contains('random log1'), contains('combination error')])));
          });

          test('when two expects are the same', () {
            logs = ['nonsense', 'nonsense'];

            shouldPass(logs, logsToConsole(['nonsense', 'nonsense']));
          });
        });

        group('- hasNoLogs -', () {
          setUp(() {
            logs = [
              'random log',
              'nonsense',
              'random log 2'
            ];
          });

          test('simple usage', () {
            logs = [];

            shouldPass(logs, hasNoLogs);
          });

          test('when there are prop type errors', () {
            shouldFail(logs, hasNoLogs, contains("has logs with value ['random log', 'nonsense', 'random log 2']"));
          });
        });
      });

      group('when passed a callback', () {
        group('that is synchronous', () {
          group('- hasLog -', () {
            test('simple usage', () {
              shouldPass(() => mount(Sample()()), hasLog('Logging a standard log'));
            });

            test('simple usage with warn config', () {
              shouldPass(() => mount(Sample()()), hasLog('Just a lil warning', consoleConfig: warnConfig));
            });

            test('simple usage with error config', () {
              shouldPass(() => mount((Sample()
                ..shouldErrorInMount = true
              )()), hasLog('error', consoleConfig: errorConfig));
            });

            test('when there are multiple logs', () {
              shouldPass(
                    () => mount((Sample()..addExtraLogAndWarn = true)()),
                hasLog('Extra Log'),
              );
            });

            test('when two actual logs are the same', () {
              shouldPass(
                    () => mount(Sample()(Sample2()())),
                hasLog('Logging a standard log'),
              );
            });
          });

          group('- logsToConsole -', () {
            test('simple usage when looking for multiple logs', () {
              shouldPass(
                  () => mount((Sample()..addExtraLogAndWarn = true)()),
                  logsToConsole(containsAll(['Logging a standard log', 'Extra Log',]))
              );
            });

            test('simple usage with warn config', () {
              shouldPass(
                  () => mount((Sample()..addExtraLogAndWarn = true)()),
                  logsToConsole(['A second warning', 'Extra Warn', 'And a third', 'Just a lil warning'],
                      consoleConfig: warnConfig)
              );
            });

            test('simple usage with error config', () {
              shouldPass(
                  () => mount((Sample()
                    ..shouldNeverBeNull = true
                    ..shouldErrorInMount = true
                  )()),
                  logsToConsole([
                    contains('error'),
                  ], consoleConfig: errorConfig)
              );
            });

            test('when two actual logs are the same', () {
              shouldPass(() => mount(Sample()(Sample2()())),
                  logsToConsole(containsAll(['Logging a standard log'])));
            });

            test('when two expected logs are the same', () {
              shouldPass(() => mount(Sample()(Sample2()())),
                  logsToConsole(['Logging a standard log', 'Logging a standard log']));
            });
          });

          group('- doesNotLog -', () {
            test('simple usage', () {
              shouldPass(() => mount((Sample()..shouldLog = false)()), hasNoLogs);
            });

            if (runtimeSupportsPropTypeWarnings()) {
              test('when there are prop type errors', () {
                shouldFail(() => mount(Sample()()),
                    hasNoLogs,
                    contains("has logs with value"));
              });
            }
          });
        });
      });
    });

    group('PropTypeLogMatcher', () {
      group('when passed a List of logs', () {
        late List<String> logs;

        setUp(() {
          logs = [
            'random log',
            'Failed prop type: foo is required',
            'nonsense',
            'Failed prop type: combination error',
          ];
        });

        group('- logsPropTypeWarning -', () {
          test('simple usage', () {
            shouldPass(logs, logsPropTypeWarning('foo is required'));
          });

          test('when there are multiple prop validation errors', () {
            logs = [
              'random log',
              'Failed prop type: foo is required',
              'Failed prop type: shouldAlwaysBeFalse set to true',
            ];

            shouldPass(logs, logsPropTypeWarning('foo is required'));
          });
        });

        group('- logsPropTypeWarnings -', () {
          test('when passed in a matcher instead of a String', () {
            shouldPass(logs, logsPropTypeWarnings(containsAll([contains('foo is required')])));
          });

          test('simple usage with multiple logs', () {
            shouldPass(logs, logsPropTypeWarnings([
              'Failed prop type: foo is required',
              'Failed prop type: combination error',
            ]));
          });

          test('when passed in matchers instead of string', () {
            shouldPass(logs, logsPropTypeWarnings(
                orderedEquals([contains('foo is required'), contains('combination error')])));
          });

          test('when two expects are the same', () {
            shouldPass(logs, logsPropTypeWarnings(orderedEquals([
              contains('Failed prop type'),
              contains('Failed prop type'),
            ])));
          });

          test('when two logs are the same', () {
            logs = [
              'random log',
              'Failed prop type: foo is required',
              'Failed prop type: foo is required',
              'Failed prop type: combination error',
            ];

            shouldPass(logs,
                logsPropTypeWarnings(orderedEquals([
                  contains('foo is required'),
                  contains('foo is required'),
                  contains('combination error')
                ])),
            );
          });
        });

        group('- logsNoPropTypeWarnings -', () {
          setUp(() {
            logs = [
              'random log',
              'Failed prop type: foo is required',
              'nonsense',
              'Failed prop type: combination error',
            ];
          });

          test('simple usage', () {
            logs = ['random log', 'random error', 'not a prop type log'];

            shouldPass(logs, logsNoPropTypeWarnings);
          });

          test('when there are prop type errors', () {
            if (runtimeSupportsPropTypeWarnings()) {
              shouldFail(logs, logsNoPropTypeWarnings, contains('has propType warning with value'));
            } else {
              shouldPass(logs, logsNoPropTypeWarnings);
            }
          });
        });
      });

      group('when passed a callback', () {
        group('that is synchronous', () {
          group('- logsPropTypeWarning -', () {
            test('simple usage', () {
              shouldPass(() => mount(Sample()()), logsPropTypeWarning('shouldNeverBeNull'));
            });

            test('with a re-render', () {
              var jacket = mount(Sample()());

              shouldPass(() => jacket.rerender((Sample()
                ..shouldAlwaysBeFalse = true
                ..shouldNeverBeNull = false
              )()),
                  logsPropTypeWarning('shouldAlwaysBeFalse set to true'));
            });

            test('when there are multiple prop validation errors', () {
              shouldPass(() => mount((Sample()..shouldAlwaysBeFalse = true)()),
                  logsPropTypeWarning('shouldNeverBeNull'));

            });

            test('when two actual logs are the same', () {
              shouldPass(() => mount(Sample()(Sample2()())),
                  logsPropTypeWarning('shouldNeverBeNull'));
            });
          });

          group('- logsPropTypeWarnings -', () {
            test('simple usage with multiple logs', () {
              shouldPass(() => mount((Sample()..shouldAlwaysBeFalse = true)()),
                  logsPropTypeWarnings([
                    contains('shouldNeverBeNull'),
                    contains('shouldAlwaysBeFalse set to true'),
                  ])
              );
            });

            test('with a re-render', () {
              var jacket = mount(Sample()());

              shouldPass(() => jacket.rerender((Sample()
                ..shouldAlwaysBeFalse = true
                ..shouldNeverBeNull = false
              )(Sample2()())),
                  logsPropTypeWarnings(containsAll([
                    contains('shouldAlwaysBeFalse set to true'),
                    contains('Prop Sample2Props.shouldNeverBeNull is required')
                  ])));
            });

            test('when two actual logs are the same', () {
              shouldPass(() => mount(Sample()(Sample2()())),
                  logsPropTypeWarnings(
                      containsAll([contains('shouldNeverBeNull')])));
            });

            test('when two expected logs are the same', () {
              shouldPass(() => mount(Sample()(Sample2()())),
                  logsPropTypeWarnings(containsAll([
                    contains('shouldNeverBeNull'),
                    contains('shouldNeverBeNull'),
                  ])));
            });
          });

          group('- logsNoPropTypeWarnings -', () {
            test('simple usage', () {
              shouldPass(() => mount((Sample()..shouldNeverBeNull = true)()), logsNoPropTypeWarnings);
            });

            test('when there are prop type errors', () {
              if (runtimeSupportsPropTypeWarnings()) {
                shouldFail(() => mount((Sample())()),
                    logsNoPropTypeWarnings,
                    contains('has propType warning with value'));
              } else {
                shouldPass(() => mount((Sample())()), logsNoPropTypeWarnings);
              }
            });
          });
        });
      });
    });

    test('throwsPropError', () {
      expect(() => throw PropError('propName', 'message'), throwsPropError('propName', 'message'));
    });

    test('throwsPropError_Required', () {
      expect(() => throw PropError.required('propName', 'message'),
          throwsPropError_Required('propName', 'message')
      );
    });

    test('throwsPropError_Value', () {
      expect(() => throw PropError.value('value', 'propName', 'message'),
          throwsPropError_Value('value', 'propName', 'message')
      );
    });

    test('throwsPropError_Combination', () {
      expect(() => throw PropError.combination('prop1Name', 'prop2Name', 'message'),
          throwsPropError_Combination('prop1Name', 'prop2Name', 'message')
      );
    });

    test('logsPropError', () {
      expect(() => mount((Sample()..shouldNeverBeNull = false)()),
          logsPropError('shouldNeverBeNull', 'should not be false'));

      if (!runtimeSupportsPropTypeWarnings()) {
        // The expectation is purposefully faulty so that we can assert that in dart2js runtimes,
        // the logsPropError never results in failures since react compiles out propTypes.
        expect(() => mount((Sample()..shouldNeverBeNull = true)()),
            logsPropError('shouldNeverBeNull'));
      } else {
        expect(() => mount((Sample()..shouldNeverBeNull = true)()),
            isNot(logsPropError('shouldNeverBeNull')), reason: 'test sanity check for ddc only matcher');
      }
    });

    test('logsRequiredPropError', () {
      expect(() => mount(Sample()()),
          logsPropRequiredError('SampleProps.shouldNeverBeNull',
              'shouldNeverBeNull is necessary'));
    });

    test('logsValuePropError', () {
      expect(() => mount((Sample()
            ..shouldNeverBeNull = true
            ..shouldAlwaysBeFalse = true)()),
          logsPropValueError(true, 'SampleProps.shouldAlwaysBeFalse',
              'shouldAlwaysBeFalse should never equal true.'));
    });

    test('logsCombinationPropError', () {
      expect(() => mount((Sample()
            ..shouldNeverBeNull = false
            ..shouldAlwaysBeFalse = false
            ..shouldLog = false)()),
          logsPropCombinationError(
              'shouldLog', 'shouldAlwaysBeFalse', 'logging is required'));
    });
  });
}

/// Utility for asserting that [matcher] will fail on [value].
///
/// Copyright (c) 2012, the Dart project authors.
void shouldFail(value, Matcher matcher, expected) {
  var failed = false;
  try {
    expect(value, matcher);
  } on TestFailure catch (err) {
    failed = true;

    var _errorString = err.message;

    if (expected is String) {
      expect(_errorString, equalsIgnoringWhitespace(expected));
    } else {
      expect(_errorString, isNotNull);
      expect(_errorString!.replaceAll(RegExp(r'[\s\n]+'), ' '), expected);
    }
  }

  expect(failed, isTrue, reason: 'Expected to fail.');
}

/// Utility for asserting that [matcher] will pass on [value].
///
/// Copyright (c) 2012, the Dart project authors.
void shouldPass(value, Matcher matcher) {
  expect(value, matcher);
}
