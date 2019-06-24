import 'dart:html';

import 'package:js/js.dart';
import 'package:over_react/over_react.dart';
import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:react/react_client/react_interop.dart';

import 'enzyme_bindings.dart' as eb;

abstract class CommonWrapper<This extends CommonWrapper<This, JsThis>, JsThis extends eb.CommonWrapper<JsThis>> {
  final JsThis _js;

  CommonWrapper(this._js);

  This fromJs(JsThis js) {
    if (js == _js) return this;
    return newFromJs(js);
  }
  This newFromJs(JsThis js);

  bool Function(JsThis wrapper) _wrapPredicate(bool Function(This wrapper) predicate) {
    return allowInterop((JsThis wrapper) {
      return predicate(fromJs(wrapper));
    });
  }

  /// Returns a new wrapper with only the nodes of the current wrapper that, when passed into the provided predicate function, return true.
  This filterWhere(bool Function(This wrapper) predicate) => fromJs(_js.filterWhere(_wrapPredicate(predicate)));

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
  bool isA(dynamic selector) => _js.isA(selector);

  /// Returns whether or not the current node exists.
  bool exists([/* EnzymeSelector */ selectors]) => _js.exists(selectors);

  /// Returns a new wrapper with only the nodes of the current wrapper that don't match the provided selector.
  /// This method is effectively the negation or inverse of filter.
  This not(/* EnzymeSelector */ selector)  => fromJs(_js.not(selector));

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
    return intercepter(fromJs(wrapper));
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

//  /// A method to invoke setState() on the root component instance similar to how you might in the definition of
//  /// the component, and re-renders. This method is useful for testing your component in hard to achieve states,
//  /// however should be used sparingly. If possible, you should utilize your component's API in order to
//  /// get it into whatever state you want to test, in order to be as accurate of a test as possible. This is not
//  /// always practical, however.
//  /// Returns itself.
//  ///
//  /// NOTE: can only be called on a wrapper instance that is also the root instance.
//  This setState([void Function() callback]);
//
//  /// A method that sets the props of the root component, and re-renders. Useful for when you are wanting to test
//  /// how the component behaves over time with changing props. Calling this, for instance, will call the
//  /// componentWillReceiveProps lifecycle method.
//  ///
//  /// Similar to setState, this method accepts a props object and will merge it in with the already existing props.
//  /// Returns itself.
//  ///
//  /// NOTE: can only be called on a wrapper instance that is also the root instance.
//  This setProps([void Function() callback]);
//
//  /// A method that sets the context of the root component, and re-renders. Useful for when you are wanting to
//  /// test how the component behaves over time with changing contexts.
//  /// Returns itself.
//  ///
//  /// NOTE: can only be called on a wrapper instance that is also the root instance.
//  This setContext(dynamic context);

  /// Gets the instance of the component being rendered as the root node passed into shallow().
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  // ignore: deprecated_member_use
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
  This forEach(dynamic Function(This wrapper, int index) fn) => fromJs(_js.forEach(allowInterop((JsThis wrapper, int index) {
    fn(fromJs(wrapper), index);
  })));

  /// Maps the current array of nodes to another array. Each node is passed in as a ShallowWrapper to the map
  /// function.
  /// Returns an array of the returned values from the mapping function..
  /// @param fn A mapping function to be run for every node in the collection, the results of which will be mapped
  ///              to the returned array. Should expect a ShallowWrapper as the first argument, and will be run
  ///              with a context of the original instance.
  List<V> map<V>(V Function(This wrapper, int index) fn)=> _js.map(allowInterop((JsThis wrapper, int index) {
    fn(fromJs(wrapper), index);
  })).cast<V>();

  /// Applies the provided reducing function to every node in the wrapper to reduce to a single value. Each node
  /// is passed in as a ShallowWrapper, and is processed from left to right.
  R reduce<R>(R Function(R prevVal, This wrapper, int index) fn, [R initialValue]) => _js.reduce(allowInterop((R prevVal, JsThis wrapper, int index) {
    return fn(prevVal, fromJs(wrapper), index);
  }));

  /// Applies the provided reducing function to every node in the wrapper to reduce to a single value.
  /// Each node is passed in as a ShallowWrapper, and is processed from right to left.
  R reduceRight<R>(R Function(R prevVal, This wrapper, int index) fn, [R initialValue]) => _js.reduce(allowInterop((R prevVal, JsThis wrapper, int index) {
    return fn(prevVal, fromJs(wrapper), index);
  }));

  /// Returns whether or not any of the nodes in the wrapper match the provided selector.
  bool some(dynamic /* EnzymeSelector */ selector) => _js.some(selector);

  /// Returns whether or not any of the nodes in the wrapper pass the provided predicate function.
  bool someWhere(bool Function(This wrapper) fn) => _js.someWhere(_wrapPredicate(fn));

  /// Returns whether or not all of the nodes in the wrapper match the provided selector.
  bool every(dynamic /* EnzymeSelector */ selector) => _js.every(selector);

  /// Returns whether or not all of the nodes in the wrapper pass the provided predicate function.
  bool everyWhere(bool Function(This wrapper) fn) => _js.everyWhere(_wrapPredicate(fn));

  /// Returns true if renderer returned null
  bool isEmptyRender() => _js.isEmptyRender();

//  /// Renders the component to static markup and returns a Cheerio wrapper around the result.
//  Cheerio render() => _js.render();

  /// Returns the type of the current node of this wrapper. If it's a composite component, this will be the
  /// component constructor. If it's native DOM node, it will be a string of the tag name.
  ///
  /// Note: can only be called on a wrapper of a single node.
  dynamic /* string | ComponentClass <P> | StatelessComponent<P>*/ typeOf() => _js.typeOf();

  int get length => _js.length;
}

/// Returns a CSS selector that can find an element with test ID [testIdString].
///
/// Supports multiple, space-delimited test IDs.
String testIdSelector(String testIdString) =>
    splitSpaceDelimitedString(testIdString)
      .map((testId) => '[data-test-id~="$testId"]')
      .join('');

/////  1. A Valid CSS Selector
/////  2. A React Component Constructor
/////  3. A React Component's displayName
/////  4. A React Stateless component
/////  5. A React component property map
////typedef EnzymeSelector = dynamic;
//selector(dynamic selector) => (CommonWrapper wrapper) => wrapper.isA(selector);


class ReactWrapper extends CommonWrapper<ReactWrapper, eb.ReactWrapper> {
  ReactWrapper(eb.ReactWrapper js) : super(js);

//    constructor(dynamic /* JSX.Element | JSX.Element[ */] nodes, root?: ReactWrapper<dynamic, dynamic>, options?: MountRendererProps);

  @override
  ReactWrapper newFromJs(eb.ReactWrapper js) => new ReactWrapper(js);


  ReactWrapper unmount() => fromJs(_js.unmount());
  ReactWrapper mount() => fromJs(_js.mount());

//    /**
//     * Returns a wrapper of the node that matches the provided reference name.
//     *
//     * NOTE: can only be called on a wrapper instance that is also the root instance.
//     */
//    ref(String refName): ReactWrapper<dynamic, dynamic>;
//    ref<P2, S2>(String refName): ReactWrapper<P2, S2>;

  /// Detaches the react tree from the DOM. Runs ReactDOM.unmountComponentAtNode() under the hood.
  ///
  /// This method will most commonly be used as a "cleanup" method if you decide to use the attachTo option in mount(node, options).
  ///
  /// The method is intentionally not "fluent" (in that it doesn't return this) because you should not be doing anything with this wrapper after this method is called.
  ///
  /// Using the attachTo is not generally recommended unless it is absolutely necessary to test something.
  /// It is your responsibility to clean up after yourself at the end of the test if you do decide to use it, though.
  void detach() => _js.detach();

  /// Strips out all the not host-nodes from the list of nodes
  ///
  /// This method is useful if you want to check for the presence of host nodes
  /// (actually rendered HTML elements) ignoring the React nodes.
  ReactWrapper hostNodes() => fromJs(_js.hostNodes());

  /// Find every node in the render tree that matches the provided selector.
  /// @param selector The selector to match.
//    external ReactWrapper/*<P2, never>*/ find<P2>(StatelessComponent<P2> statelessComponent);
//    external ReactWrapper/*<P2, dynamic>*/ find<P2>(ComponentType<P2> component);
//    external ReactWrapper/*<dynamic, dynamic>*/ find(EnzymePropSelector props);
//    external ReactWrapper/*<HTMLAttributes, dynamic>*/ find(String selector);
  ReactWrapper/*<HTMLAttributes, dynamic>*/ find(dynamic selector) => fromJs(_js.find(selector));

  /// Finds every node in the render tree that returns true for the provided predicate function.
  ReactWrapper findWhere(bool Function(ReactWrapper) predicate) => fromJs(_js.findWhere(_wrapPredicate(predicate)));

  /// Removes nodes in the current wrapper that do not match the provided selector.
  /// @param selector The selector to match.
//    filter<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    filter<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    filter(dynamic /* EnzymePropSelector | string */ props): ReactWrapper<P, S>;
  ReactWrapper filter(dynamic selector) => fromJs(_js.filter(selector));

  /// Returns a new wrapper with all of the children of the node(s) in the current wrapper. Optionally, a selector
  /// can be provided and it will filter the children by this selector.
//    children<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    children<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    children(String selector): ReactWrapper<HTMLAttributes, dynamic>;
//    children([props?: EnzymePropSelector]): ReactWrapper<dynamic, dynamic>;
  ReactWrapper children([dynamic selector]) => fromJs(_js.children(selector));

  /// Returns a new wrapper with child at the specified index.
//    childAt(int index): ReactWrapper<dynamic, dynamic>;
//    childAt<P2, S2>(int index): ReactWrapper<P2, S2>;
  ReactWrapper childAt(int index) => fromJs(_js.childAt(index));

  /// Returns a wrapper around all of the parents/ancestors of the wrapper. Does not include the node in the
  /// current wrapper. Optionally, a selector can be provided and it will filter the parents by this selector.
  ///
  /// Note: can only be called on a wrapper of a single node.
//    parents<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    parents<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    parents(String selector): ReactWrapper<HTMLAttributes, dynamic>;
//    parents([props?: EnzymePropSelector]): ReactWrapper<dynamic, dynamic>;
  ReactWrapper parents(dynamic selector) => fromJs(_js.parents(selector));

  /// Returns a wrapper of the first element that matches the selector by traversing up through the current node's
  /// ancestors in the tree, starting with itself.
  ///
  /// Note: can only be called on a wrapper of a single node.
//    closest<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    closest<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    closest(EnzymePropSelector props): ReactWrapper<dynamic, dynamic>;
//    closest(String selector): ReactWrapper<HTMLAttributes, dynamic>;
  ReactWrapper closest(dynamic selector)  => fromJs(_js.closest(selector));

  /// Returns a wrapper with the direct parent of the node in the current wrapper.
  ReactWrapper parent() => fromJs(_js.parent());

}

///**
// * Shallow rendering is useful to constrain yourself to testing a component as a unit, and to ensure that
// * your tests aren't indirectly asserting on behavior of child components.
// */
////export function shallow<C extends Component, P = C['props'], S = C['state']>(ReactElement<P> node, options?: ShallowRendererProps): ShallowWrapper<P, S, C>;
////export function shallow<P>(ReactElement<P> node, options?: ShallowRendererProps): ShallowWrapper<P, any>;
////export function shallow<P, S>(ReactElement<P> node, options?: ShallowRendererProps): ShallowWrapper<P, S>;
////
/////**
//// * Mounts and renders a react component into the document and provides a testing wrapper around it.
//// */
ReactWrapper mount(ReactElement node, [eb.MountRendererOptions options]) =>
    new ReactWrapper(eb.mount(node, options));
