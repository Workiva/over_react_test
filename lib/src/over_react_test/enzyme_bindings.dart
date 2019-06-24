@JS()
library foo;

import 'dart:html';

import 'package:js/js.dart';
import 'package:react/react_client.dart';

// Type definitions for Enzyme 3.9
// Project: https://github.com/airbnb/enzyme
// Definitions by: Marian Palkus <https://github.com/MarianPalkus>
//                 Cap3 <http://www.cap3.de>
//                 Ivo Stratev <https://github.com/NoHomey>
//                 jwbay <https://github.com/jwbay>
//                 huhuanming <https://github.com/huhuanming>
//                 MartynasZilinskas <https://github.com/MartynasZilinskas>
//                 Torgeir Hovden <https://github.com/thovden>
//                 Martin Hochel <https://github.com/hotell>
//                 Christian Rackerseder <https://github.com/screendriver>
//                 Mateusz Sokoła <https://github.com/mateuszsokola>
//                 Braiden Cutforth <https://github.com/braidencutforth>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
// TypeScript Version: 3.1

/* These are purposefully stripped down versions of React.ComponentClass and React.StatelessComponent.
 * The optional static properties on them break overload ordering for wrapper methods if they're not
 * all specified in the implementation. TS chooses the EnzymePropSelector overload and loses the generics
 */

/// Many methods in Enzyme's API accept a selector as an argument. Selectors in Enzyme can fall into one of the
/// following three categories:
///
///  1. A Valid CSS Selector
///  2. A React Component Constructor
///  3. A React Component's displayName
///  4. A React Stateless component
///  5. A React component property map
//typedef EnzymeSelector = dynamic;

class Cheerio {}
class EnzymeSelector {}

typedef void Intercepter<T>(T intercepter);


@JS()
//class CommonWrapper<P, S, C, This extends CommonWrapper<P, S, C, This>> {
class CommonWrapper<This extends CommonWrapper<This>> {
  /// Returns a new wrapper with only the nodes of the current wrapper that, when passed into the provided predicate function, return true.
  external This filterWhere(bool Function(This wrapper) predicate);

  /// Returns whether or not the current wrapper has a node anywhere in it's render tree that looks like the one passed in.
  external bool contains(dynamic /* ReactElement | List<ReactElement> | string */ node);

  /// Returns whether or not a given react element exists in the shallow render tree.
  external bool containsMatchingElement(dynamic /* ReactElement | List<ReactElement> */ node);

  /// Returns whether or not all the given react elements exists in the shallow render tree
  external bool containsAllMatchingElements(dynamic /* List<ReactElement> | List<List<ReactElement>> */ nodes);

  /// Returns whether or not one of the given react elements exists in the shallow render tree.
  external bool containsAnyMatchingElements(dynamic /* List<ReactElement> | List<List<ReactElement>> */ nodes);

  /// Returns whether or not the current render tree is equal to the given node, based on the expected value.
  external bool equals(ReactElement node);

  /// Returns whether or not a given react element matches the shallow render tree.
  external bool matchesElement(ReactElement node);

  /// Returns whether or not the current node has a className prop including the passed in class name.
  external bool hasClass(dynamic /* string | RegExp */ className);

  /// Returns whether or not the current node matches a provided selector.
  external bool isA(EnzymeSelector selector);

  /// Returns whether or not the current node is empty.
  /// @deprecated Use .exists() instead.
  external bool isEmpty();

  /// Returns whether or not the current node exists.
  external bool exists([EnzymeSelector selector]);

  /// Returns a new wrapper with only the nodes of the current wrapper that don't match the provided selector.
  /// This method is effectively the negation or inverse of filter.
  external This not(EnzymeSelector selector);

  /// Returns a string of the rendered text of the current render tree. This function should be looked at with
  /// skepticism if being used to test what the actual HTML output of the component will be. If that is what you
  /// would like to test, use enzyme's render function instead.
  ///
  /// Note: can only be called on a wrapper of a single node.
  external String text();

  /// Returns a string of the rendered HTML markup of the current render tree.
  ///
  /// Note: can only be called on a wrapper of a single node.
  external String html();

  /// Returns the node at a given index of the current wrapper.
  external ReactElement get(int index);

  /// Returns the wrapper's underlying node.
  external ReactElement getNode();

  /// Returns the wrapper's underlying nodes.
  external List<ReactElement> getNodes();

  /// Returns the wrapper's underlying node.
  external ReactElement getElement();

  /// Returns the wrapper's underlying node.
  external List<ReactElement> getElements();

  /// Returns the outer most DOMComponent of the current wrapper.
  external T getDOMNode<T extends Element>();

  /// Returns a wrapper around the node at a given index of the current wrapper.
  external This at(int index);

  /// Reduce the set of matched nodes to the first in the set.
  external This first();

  /// Reduce the set of matched nodes to the last in the set.
  external This last();

  /// Returns a new wrapper with a subset of the nodes of the original wrapper, according to the rules of `Array#slice`.
  external This slice([int begin, int end]);

  /// Taps into the wrapper method chain. Helpful for debugging.
  external This tap(Intercepter<This> intercepter);

  /// Returns the state hash for the root node of the wrapper. Optionally pass in a prop name and it will return just that value.
//  external S state([String key]);
  external JsMap state();

  /// Returns the context hash for the root node of the wrapper. Optionally pass in a prop name and it will return just that value.
  external context([String key]);

  /// Returns the props hash for the current node of the wrapper.
  ///
  /// NOTE: can only be called on a wrapper of a single node.
//  external P props();
  external JsMap props();

  /// Returns the prop value for the node of the current wrapper with the provided key.
  ///
  /// NOTE: can only be called on a wrapper of a single node.
  external T prop<T>(String key);

  /// Returns the key value for the node of the current wrapper.
  /// NOTE: can only be called on a wrapper of a single node.
  external String key();

  /// Simulate events.
  /// Returns itself.
  /// @param args?
  external This simulate(String event, [List<dynamic> args]);

  /// Used to simulate throwing a rendering error. Pass an error to throw.
  /// Returns itself.
  /// @param error
  external This simulateError(dynamic error);

  /// A method to invoke setState() on the root component instance similar to how you might in the definition of
  /// the component, and re-renders. This method is useful for testing your component in hard to achieve states,
  /// however should be used sparingly. If possible, you should utilize your component's external API in order to
  /// get it into whatever state you want to test, in order to be as accurate of a test as possible. This is not
  /// always practical, however.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  external This setState([void Function() callback]);

  /// A method that sets the props of the root component, and re-renders. Useful for when you are wanting to test
  /// how the component behaves over time with changing props. Calling this, for instance, will call the
  /// componentWillReceiveProps lifecycle method.
  ///
  /// Similar to setState, this method accepts a props object and will merge it in with the already existing props.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  external This setProps([void Function() callback]);

  /// A method that sets the context of the root component, and re-renders. Useful for when you are wanting to
  /// test how the component behaves over time with changing contexts.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  external This setContext(dynamic context);

  /// Gets the instance of the component being rendered as the root node passed into shallow().
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  external C instance<C>();

  /// Forces a re-render. Useful to run before checking the render output if something external may be updating
  /// the state of the component somewhere.
  /// Returns itself.
  ///
  /// NOTE: can only be called on a wrapper instance that is also the root instance.
  external This update();

  /// Returns an html-like string of the wrapper for debugging purposes. Useful to print out to the console when
  /// tests are not passing when you expect them to.
  external String debug();

  /// Returns the name of the current node of the wrapper.
  external String name();

  /// Iterates through each node of the current wrapper and executes the provided function with a wrapper around
  /// the corresponding node passed in as the first argument.
  ///
  /// Returns itself.
  /// @param fn A callback to be run for every node in the collection. Should expect a ShallowWrapper as the first
  ///              argument, and will be run with a context of the original instance.
  external This forEach(dynamic Function(This wrapper, int index) fn);

  /// Maps the current array of nodes to another array. Each node is passed in as a ShallowWrapper to the map
  /// function.
  /// Returns an array of the returned values from the mapping function..
  /// @param fn A mapping function to be run for every node in the collection, the results of which will be mapped
  ///              to the returned array. Should expect a ShallowWrapper as the first argument, and will be run
  ///              with a context of the original instance.
  external List/*<V>*/ map<V>(V Function(This wrapper, int index) fn);

  /// Applies the provided reducing function to every node in the wrapper to reduce to a single value. Each node
  /// is passed in as a ShallowWrapper, and is processed from left to right.
  external R reduce<R>(R Function(R prevVal, This wrapper, int index) fn, [R initialValue]);

  /// Applies the provided reducing function to every node in the wrapper to reduce to a single value.
  /// Each node is passed in as a ShallowWrapper, and is processed from right to left.
  external R reduceRight<R>(R Function(R prevVal, This wrapper, int index) fn, [R initialValue]);

  /// Returns whether or not any of the nodes in the wrapper match the provided selector.
  external bool some(EnzymeSelector selector);

  /// Returns whether or not any of the nodes in the wrapper pass the provided predicate function.
  external bool someWhere(bool Function(This wrapper) fn);

  /// Returns whether or not all of the nodes in the wrapper match the provided selector.
  external bool every(EnzymeSelector selector);

  /// Returns whether or not all of the nodes in the wrapper pass the provided predicate function.
  external bool everyWhere(bool Function(This wrapper) fn);

  /// Returns true if renderer returned null
  external bool isEmptyRender();

  /// Renders the component to static markup and returns a Cheerio wrapper around the result.
  external Cheerio render();

  /// Returns the type of the current node of this wrapper. If it's a composite component, this will be the
  /// component constructor. If it's native DOM node, it will be a string of the tag name.
  ///
  /// Note: can only be called on a wrapper of a single node.
  external dynamic /* string | ComponentClass <P> | StatelessComponent<P>*/ typeOf();

  external int get length;
}
//
//export type Parameters<T> = T extends (...args: infer A) => dynamic ? A : never;
//
//// tslint:disable-next-line no-empty-interface
//export interface ShallowWrapper<P = {}, S = {}, C = Component> extends CommonWrapper<P, S, C> { }
//export class ShallowWrapper<P = {}, S = {}, C = Component> {
//    constructor(dynamic /* JSX.List<Element> | JSX.Elemen */t nodes, root?: ShallowWrapper<dynamic, dynamic>, options?: ShallowRendererProps);
//    shallow([options?: ShallowRendererProps]): ShallowWrapper<P, S>;
//    This unmount();
//
//    /**
//     * Find every node in the render tree that matches the provided selector.
//     * @param selector The selector to match.
//     */
//    find<P2>(StatelessComponent<P2> statelessComponent): ShallowWrapper<P2, never>;
//    find<P2>(ComponentType<P2> component): ShallowWrapper<P2, dynamic>;
//    find(EnzymePropSelector props): ShallowWrapper<dynamic, dynamic>;
//    find(String selector): ShallowWrapper<HTMLAttributes, dynamic>;
//
//    /**
//     * Removes nodes in the current wrapper that do not match the provided selector.
//     * @param selector The selector to match.
//     */
//    filter<P2>(StatelessComponent<P2> statelessComponent): ShallowWrapper<P2, never>;
//    filter<P2>(ComponentType<P2> component): ShallowWrapper<P2, dynamic>;
//    filter(dynamic /* EnzymePropSelector | string */ props): ShallowWrapper<P, S>;
//
//    /**
//     * Finds every node in the render tree that returns true for the provided predicate function.
//     */
//    findWhere(predicate: (ShallowWrapper<dynamic wrapper, dynamic>) => boolean): ShallowWrapper<dynamic, dynamic>;
//
//    /**
//     * Returns a new wrapper with all of the children of the node(s) in the current wrapper. Optionally, a selector
//     * can be provided and it will filter the children by this selector.
//     */
//    children<P2>(StatelessComponent<P2> statelessComponent): ShallowWrapper<P2, never>;
//    children<P2>(ComponentType<P2> component): ShallowWrapper<P2, dynamic>;
//    children(String selector): ShallowWrapper<HTMLAttributes, dynamic>;
//    children([props?: EnzymePropSelector]): ShallowWrapper<dynamic, dynamic>;
//
//    /**
//     * Returns a new wrapper with child at the specified index.
//     */
//    childAt(int index): ShallowWrapper<dynamic, dynamic>;
//    childAt<P2, S2>(int index): ShallowWrapper<P2, S2>;
//
//    /**
//     * Shallow render the one non-DOM child of the current wrapper, and return a wrapper around the result.
//     * NOTE: can only be called on wrapper of a single non-DOM component element node.
//     */
//    dive<P2, S2>([options?: ShallowRendererProps]): ShallowWrapper<P2, S2>;
//
//    /**
//     * Strips out all the not host-nodes from the list of nodes
//     *
//     * This method is useful if you want to check for the presence of host nodes
//     * (actually rendered HTML elements) ignoring the React nodes.
//     */
//    hostNodes(): ShallowWrapper<HTMLAttributes>;
//
//    /**
//     * Returns a wrapper around all of the parents/ancestors of the wrapper. Does not include the node in the
//     * current wrapper. Optionally, a selector can be provided and it will filter the parents by this selector.
//     *
//     * Note: can only be called on a wrapper of a single node.
//     */
//    parents<P2>(StatelessComponent<P2> statelessComponent): ShallowWrapper<P2, never>;
//    parents<P2>(ComponentType<P2> component): ShallowWrapper<P2, dynamic>;
//    parents(String selector): ShallowWrapper<HTMLAttributes, dynamic>;
//    parents([props?: EnzymePropSelector]): ShallowWrapper<dynamic, dynamic>;
//
//    /**
//     * Returns a wrapper of the first element that matches the selector by traversing up through the current node's
//     * ancestors in the tree, starting with itself.
//     *
//     * Note: can only be called on a wrapper of a single node.
//     */
//    closest<P2>(StatelessComponent<P2> statelessComponent): ShallowWrapper<P2, never>;
//    closest<P2>(ComponentType<P2> component): ShallowWrapper<P2, dynamic>;
//    closest(EnzymePropSelector props): ShallowWrapper<dynamic, dynamic>;
//    closest(String selector): ShallowWrapper<HTMLAttributes, dynamic>;
//
//    /**
//     * Returns a wrapper with the direct parent of the node in the current wrapper.
//     */
//    parent(): ShallowWrapper<dynamic, dynamic>;
//
//    /**
//     * Returns a wrapper of the node rendered by the provided render prop.
//     */
//    renderProp<PropName extends keyof P>(PropName prop): (...params: Parameters<P[PropName]>) => ShallowWrapper<dynamic, never>;
//}
//
//// tslint:disable-next-line no-empty-interface
class ReactWrapper extends CommonWrapper<ReactWrapper> {
//    constructor(dynamic /* JSX.Element | JSX.Element[ */] nodes, root?: ReactWrapper<dynamic, dynamic>, options?: MountRendererProps);

  external ReactWrapper unmount();
  external ReactWrapper mount();

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
  external void detach();

  /// Strips out all the not host-nodes from the list of nodes
  ///
  /// This method is useful if you want to check for the presence of host nodes
  /// (actually rendered HTML elements) ignoring the React nodes.
  external ReactWrapper hostNodes();//: ReactWrapper<HTMLAttributes>;

  /// Find every node in the render tree that matches the provided selector.
  /// @param selector The selector to match.
//    external ReactWrapper/*<P2, never>*/ find<P2>(StatelessComponent<P2> statelessComponent);
//    external ReactWrapper/*<P2, dynamic>*/ find<P2>(ComponentType<P2> component);
//    external ReactWrapper/*<dynamic, dynamic>*/ find(EnzymePropSelector props);
//    external ReactWrapper/*<HTMLAttributes, dynamic>*/ find(String selector);
  external ReactWrapper/*<HTMLAttributes, dynamic>*/ find(dynamic selector);

  /// Finds every node in the render tree that returns true for the provided predicate function.
  external ReactWrapper findWhere(bool Function (ReactWrapper) predicate);

  /// Removes nodes in the current wrapper that do not match the provided selector.
  /// @param selector The selector to match.
//    filter<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    filter<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    filter(dynamic /* EnzymePropSelector | string */ props): ReactWrapper<P, S>;
  external ReactWrapper filter(dynamic selector);

  /// Returns a new wrapper with all of the children of the node(s) in the current wrapper. Optionally, a selector
  /// can be provided and it will filter the children by this selector.
//    children<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    children<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    children(String selector): ReactWrapper<HTMLAttributes, dynamic>;
//    children([props?: EnzymePropSelector]): ReactWrapper<dynamic, dynamic>;
  external ReactWrapper children([dynamic selector]);

  /// Returns a new wrapper with child at the specified index.
//    childAt(int index): ReactWrapper<dynamic, dynamic>;
//    childAt<P2, S2>(int index): ReactWrapper<P2, S2>;
  external ReactWrapper childAt(int index);

  /// Returns a wrapper around all of the parents/ancestors of the wrapper. Does not include the node in the
  /// current wrapper. Optionally, a selector can be provided and it will filter the parents by this selector.
  ///
  /// Note: can only be called on a wrapper of a single node.
//    parents<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    parents<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    parents(String selector): ReactWrapper<HTMLAttributes, dynamic>;
//    parents([props?: EnzymePropSelector]): ReactWrapper<dynamic, dynamic>;
  external ReactWrapper parents(dynamic selector);

  /// Returns a wrapper of the first element that matches the selector by traversing up through the current node's
  /// ancestors in the tree, starting with itself.
  ///
  /// Note: can only be called on a wrapper of a single node.
//    closest<P2>(StatelessComponent<P2> statelessComponent): ReactWrapper<P2, never>;
//    closest<P2>(ComponentType<P2> component): ReactWrapper<P2, dynamic>;
//    closest(EnzymePropSelector props): ReactWrapper<dynamic, dynamic>;
//    closest(String selector): ReactWrapper<HTMLAttributes, dynamic>;
  external ReactWrapper closest(dynamic selector);

  /// Returns a wrapper with the direct parent of the node in the current wrapper.
  external ReactWrapper parent();
}
//
//@JS()
//@anonymous
//abstract class ShallowRendererProps {
//    // See https://github.com/airbnb/enzyme/blob/enzyme@3.1.1/docs/api/shallow.md#arguments
//    /**
//     * If set to true, componentDidMount is not called on the component, and componentDidUpdate is not called after
//     * setProps and setContext. Default to false.
//     */
//    bool get disableLifecycleMethods;
//    /**
//     * Enable experimental support for full react lifecycle methods
//     */
//    bool get lifecycleExperimental;
//    /**
//     * Context to be passed into the component
//     */
//    bool get context;
//}
//
@JS()
class MountRendererOptions {
  external factory MountRendererOptions({
    /// Context to be passed into the component
    dynamic context,

    /// DOM Element to attach the component to
    Element attachTo,

//    /// Merged contextTypes for all children of the wrapper
//    dynamic childContextTypes,
  });
}
//
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
external ReactWrapper mount<C>(ReactElement node, [MountRendererOptions options]);
////export function mount<P>(ReactElement<P> node, options?: MountRendererProps): ReactWrapper<P, any>;
////export function mount<P, S>(ReactElement<P> node, options?: MountRendererProps): ReactWrapper<P, S>;
////
/////**
//// * Render react components to static HTML and analyze the resulting HTML structure.
//// */
////export function render<P, S>(ReactElement<P> node, options?: any): Cheerio;
////
////// See https://github.com/airbnb/enzyme/blob/v3.1.0/packages/enzyme/src/EnzymeAdapter.js
////export class EnzymeAdapter {
////}
////
/////**
//// * Configure enzyme to use the correct adapter for the react version
//// * This is enabling the Enzyme configuration with adapters in TS
//// */
////export function configure({
////    adapter: EnzymeAdapter options,
////    // See https://github.com/airbnb/enzyme/blob/enzyme@3.1.1/docs/guides/migration-from-2-to-3.md#lifecycle-methods
////    // Actually, `{adapter:} & Pick<ShallowRendererProps,"disableLifecycleMethods">` is more precise. However,
////    // in that case jsdoc won't be shown
////    /**
////     * If set to true, componentDidMount is not called on the component, and componentDidUpdate is not called after
////     * setProps and setContext. Default to false.
////     */
////    disableLifecycleMethods?: boolean;
////}): void;
