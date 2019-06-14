import 'dart:html';

import 'package:js/js.dart';
import 'package:over_react/over_react.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'enzyme_bindings.dart' as eb;

abstract class CommonWrapper<This extends CommonWrapper<This, JsThis>, JsThis extends eb.CommonWrapper<JsThis>> {
  JsThis _js;

  This fromJs(JsThis js) {
    if (js == _js) return this;
    return newFromJs(js);
  }
  This newFromJs(JsThis js);

  /// Returns a new wrapper with only the nodes of the current wrapper that, when passed into the provided predicate function, return true.
  This filterWhere(bool Function(This wrapper) predicate) => fromJs(_js.filterWhere(allowInterop((JsThis wrapper) {
    return predicate(fromJs(wrapper));
  })));

  /// Returns whether or not the current wrapper has a node anywhere in it's render tree that looks like the one passed in.
  bool contains(dynamic /* ReactElement | List<ReactElement> | string */ node) => _js.contains(node);

  /// Returns whether or not a given react element exists in the shallow render tree.
  bool containsMatchingElement(dynamic /* ReactElement | List<ReactElement> */ node) => _js.containsMatchingElement(node);

  /// Returns whether or not all the given react elements exists in the shallow render tree
  bool containsAllMatchingElements(List<ReactElement> nodes) => _js.containsAllMatchingElements(nodes);

  /// Returns whether or not one of the given react elements exists in the shallow render tree.
  bool containsAnyMatchingElements(List<ReactElement> nodes) => _js.containsAnyMatchingElements(nodes);

  /// Returns whether or not the current render tree is equal to the given node, based on the expected value.
  bool equals(ReactElement node) => _js.equals(node);

  /// Returns whether or not a given react element matches the shallow render tree.
  bool matchesElement(ReactElement node) => _js.matchesElement(node);

  /// Returns whether or not the current node has a className prop including the passed in class name.
  bool hasClass(dynamic /* string | RegExp */ className) => _js.hasClass(className);

  /// Returns whether or not the current node matches a provided selector.
  bool isA(EnzymeSelector selector);

  /// Returns whether or not the current node is empty.
  /// @deprecated Use .exists() instead.
  bool isEmpty() => _js.isEmpty();

  /// Returns whether or not the current node exists.
  bool exists([EnzymeSelector selector]) => _js.exists(selector);

  /// Returns a new wrapper with only the nodes of the current wrapper that don't match the provided selector.
  /// This method is effectively the negation or inverse of filter.
  This not(EnzymeSelector selector)  => fromJs(_js.not(selector));

  /// Returns a string of the rendered text of the current render tree. This function should be looked at with
  /// skepticism if being used to test what the actual HTML output of the component will be. If that is what you
  /// would like to test, use enzyme's render function instead.
  ///
  /// Note: can only be called on a wrapper of a single node.
  String text() => _js.text();

  /// Returns a string of the rendered HTML markup of the current render tree.
  ///
  /// Note: can only be called on a wrapper of a single node.
  String html() => _js.html();

  /// Returns the node at a given index of the current wrapper.
  ReactElement get(int index) => _js.get(index);

  /// Returns the wrapper's underlying node.
  ReactElement getNode() => _js.getNode();

  /// Returns the wrapper's underlying nodes.
  List<ReactElement> getNodes() => _js.getNodes();

  /// Returns the wrapper's underlying node.
  ReactElement getElement() => _js.getElement();

  /// Returns the wrapper's underlying node.
  List<ReactElement> getElements() => _js.getElements();

  /// Returns the outer most DOMComponent of the current wrapper.
  T getDOMNode<T extends Element>() => _js.getDOMNode();

  /// Returns a wrapper around the node at a given index of the current wrapper.
  This at(int index) => at(index);

  /// Reduce the set of matched nodes to the first in the set.
  This first() => fromJs(_js.first());

  /// Reduce the set of matched nodes to the last in the set.
  This last() =>  fromJs(_js.last());

  /// Returns a new wrapper with a subset of the nodes of the original wrapper, according to the rules of `Array#slice`.
  This slice([int begin, int end]) =>  fromJs(_js.slice(begin, end));

  /// Taps into the wrapper method chain. Helpful for debugging.
  This tap(eb.Intercepter<This> intercepter) => fromJs(_js.tap(allowInterop((JsThis wrapper) {
    intercepter(fromJs(wrapper));
  })));

  /// Returns the state hash for the root node of the wrapper. Optionally pass in a prop name and it will return just that value.
  Map state() => JsBackedMap.backedBy(_js.state());

  /// Returns the context hash for the root node of the wrapper. Optionally pass in a prop name and it will return just that value.
  dynamic context() => _js.context();

  /// Returns the props hash for the current node of the wrapper.
  ///
  /// NOTE: can only be called on a wrapper of a single node.
  Map props() => JsBackedMap.backedBy(_js.props());

  T propsAs<T>(T Function(Map) factory) => factory(props());
  T stateAs<T>(T Function(Map) factory) => factory(state());

  /// Returns the key value for the node of the current wrapper.
  /// NOTE: can only be called on a wrapper of a single node.
  String key() => _js.key();

  /// Simulate events.
  /// Returns itself.
  /// @param args?
  This simulate(String event, [List<dynamic> args]) => fromJs(_js.simulate(event, args));

  /// Used to simulate throwing a rendering error. Pass an error to throw.
  /// Returns itself.
  /// @param error
  This simulateError(dynamic error) => fromJs(_js.simulateError(error));

  /// A method to invoke setState() on the root component instance similar to how you might in the definition of
  /// the component, and re-renders. This method is useful for testing your component in hard to achieve states,
  /// however should be used sparingly. If possible, you should utilize your component's API in order to
  /// get it into whatever state you want to test, in order to be as accurate of a test as possible. This is not
  /// always practical, however.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  This setState([void Function() callback]);

  /// A method that sets the props of the root component, and re-renders. Useful for when you are wanting to test
  /// how the component behaves over time with changing props. Calling this, for instance, will call the
  /// componentWillReceiveProps lifecycle method.
  ///
  /// Similar to setState, this method accepts a props object and will merge it in with the already existing props.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  This setProps([void Function() callback]);

  /// A method that sets the context of the root component, and re-renders. Useful for when you are wanting to
  /// test how the component behaves over time with changing contexts.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  This setContext(dynamic context);

  /// Gets the instance of the component being rendered as the root node passed into shallow().
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  C instance<C extends react.Component>() {
    final instance = getDartComponent(jsInstance());
    if (instance == null) {
      throw new UnsupportedError('Cannot use instance on a non-Dart component');
    }
    return instance as C;
  }

  ReactComponent jsInstance() {
    final instance = _js.instance();
    if (instance is Element) {
      throw new UnsupportedError('Cannot use jsInstance on a DOM component');
    }
    return instance as ReactComponent;
  }

  /// Forces a re-render. Useful to run before checking the render output if something may be updating
  /// the state of the component somewhere.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  This update() => fromJs(_js.update());

  /// Returns an html-like string of the wrapper for debugging purposes. Useful to print out to the console when
  /// tests are not passing when you expect them to.
  String debug() => _js.debug();

  /// Returns the name of the current node of the wrapper.
  String name() => _js.name();

  /// Iterates through each node of the current wrapper and executes the provided function with a wrapper around
  /// the corresponding node passed in as the first argument.
  ///
  /// Returns itself.
  /// @param fn A callback to be run for every node in the collection. Should expect a ShallowWrapper as the first
  ///              argument, and will be run with a context of the original instance.
  This forEach(dynamic Function(This wrapper, int index) fn);

  /// Maps the current array of nodes to another array. Each node is passed in as a ShallowWrapper to the map
  /// function.
  /// Returns an array of the returned values from the mapping function..
  /// @param fn A mapping function to be run for every node in the collection, the results of which will be mapped
  ///              to the returned array. Should expect a ShallowWrapper as the first argument, and will be run
  ///              with a context of the original instance.
  List<V> map<V>(V Function(This wrapper, int index) fn);

  /// Applies the provided reducing function to every node in the wrapper to reduce to a single value. Each node
  /// is passed in as a ShallowWrapper, and is processed from left to right.
  R reduce<R>(R Function(R prevVal, This wrapper, int index) fn, [R initialValue]);

  /// Applies the provided reducing function to every node in the wrapper to reduce to a single value.
  /// Each node is passed in as a ShallowWrapper, and is processed from right to left.
  R reduceRight<R>(R Function(R prevVal, This wrapper, int index) fn, [R initialValue]);

  /// Returns whether or not any of the nodes in the wrapper match the provided selector.
  bool some(EnzymeSelector selector);

  /// Returns whether or not any of the nodes in the wrapper pass the provided predicate function.
  bool someWhere(bool Function(This wrapper) fn);

  /// Returns whether or not all of the nodes in the wrapper match the provided selector.
  bool every(EnzymeSelector selector);

  /// Returns whether or not all of the nodes in the wrapper pass the provided predicate function.
  bool everyWhere(bool Function(This wrapper) fn);

  /// Returns true if renderer returned null
  bool isEmptyRender() => _js.isEmptyrRender();

  /// Renders the component to static markup and returns a Cheerio wrapper around the result.
  Cheerio render() => _js.render();

  /// Returns the type of the current node of this wrapper. If it's a composite component, this will be the
  /// component constructor. If it's native DOM node, it will be a string of the tag name.
  ///
  /// Note: can only be called on a wrapper of a single node.
  dynamic /* string | ComponentClass <P> | StatelessComponent<P>*/ typeOf() => _js.typeOf;

  int get length => _js.length;
}
