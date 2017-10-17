# OverReact Test

[![Pub](https://img.shields.io/pub/v/over_react_test.svg)](https://pub.dartlang.org/packages/over_react_test)
[![Build Status](https://travis-ci.org/Workiva/over_react_test.svg?branch=master)](https://travis-ci.org/Workiva/over_react_test)
[![Test Coverage](https://codecov.io/github/Workiva/over_react_test/coverage.svg?branch=master)](https://codecov.io/github/Workiva/over_react_test?branch=master)
[![Documentation](https://img.shields.io/badge/Documentation-over_react_test-blue.svg)](http://www.dartdocs.org/documentation/over_react_test/latest/)

> A library for testing [OverReact][over-react] components.

+ __[Using it in your project](#using-it-in-your-project)__
+ __[Documentation](#documentation)__
+ __[Contributing](#contributing)__


## Using it in your project

1. Import it into your test files:

    ```dart
    import 'package:over_react_test/over_react_test.dart';
    ```

2. Add the `test/pub_serve` transformer to your `pubspec.yaml` _after_ the `over_react` transformer.

    ```yaml
    transformers:
    - over_react
    - test/pub_serve:
        $include: test/**_test{.*,}.dart
    - $dart2js
    ```

3. Use the [--pub-serve option](https://github.com/dart-lang/test#testing-with-barback) when running your tests:

    ```bash
    $ pub run test --pub-serve=8081 test/your_test_file.dart
    ```

    > __Note:__ `8081` is the default port used, but your project may use something different. Be sure to take note of the output when running `pub serve` to ensure you are using the correct port.

## Naming Conventions

#### Variables and Types

Usage | Actual Type | Suggested Referencing
--- | --- | ---
`render` and `render` helper functions | `ReactComponent` \| `Element` | `instance`
Component class | `ReactClass` | `type`
VDOM Instance (invoked `UiProps`) | `ReactElement` | `-ReactElement`  or not suffixed
`findDomNode`, `queryByTestId`, etc. | `Element` | `node`
The Dart component | `react.Component` (backed by `ReactComponent`) | `dartInstance`
Invoked `UiFactory` | `UiProps` | `builder`

Example:

```dart
test('my test' () {
  var sampleBuilder = Sample();
  var sampleReactElement = sampleBuilder(); // Or var sample = sampleBuilder();
  var instance = render(sampleInstance);
  SampleComponent sampleDartInstance = getDartComponent(instance);
  var sampleNode = findDomNode(instance);
});
```

#### Test IDs

When coming up with test ID strings:
- __DO NOT__ use spaces; space-delimited strings will be treated as separate test IDs
    
    Just like CSS class names, you can use multiple test IDs together, and use any one of them to target a given component/node.

- __PREFER__ following our naming scheme for consistency across projects:
    
    `<library>.<Component>[.<subpart>...].<part>`
    
    We recommend including a library abbreviation and component name within a test ID so that it's easy to track down where that ID came from.
    
    Namespacing (`.<subpart>`) can be added however it makes sense.
    
    Finally, test IDs should be descriptive and useful in the context of tests.
    
    Examples:
    
    - `wsd.DatepickerPrimitive.goToSelectedButton`
    - `sox.AbstractDataLayoutGroup.headerBlock.title`

- __CONSIDER__ adding multiple IDs to serve different purposes

  ```dart
  for (var i = 0; i < items.length; i++) {
    // ...
      ..addTestId('foo.Bar.menuItem')
      ..addTestId('foo.Bar.menuItem.$i')
      ..addTestId('foo.Bar.menuItem.${items[i].id}')
    // ...
  }
  ```
  
  With the output of above code, you can:
  * target all of the `Bar` component's menu items using `foo.Bar.menuItem`
  * target the 4th item using `foo.Bar.menuItem.3`
  * target the item corresponding to an item with id `baz123` using `foo.Bar.menuItem.baz123`
  
  This won't always be needed, but it comes in handy in certain cases.


## Documentation

You would never skip reading the docs for a new language you are asked to learn, 
so _please_ don't skip over reading [our API documentation][api-docs] either.


## Contributing

Yes please! ([__Please read our contributor guidelines first__][contributing-docs])


## Versioning

The `over_react_test` library adheres to [Semantic Versioning](http://semver.org/):

* Any API changes that are not backwards compatible will __bump the major version__ _(and reset the minor / patch)_.
* Any new functionality that is added in a backwards-compatible manner will __bump the minor version__
  _(and reset the patch)_.
* Any backwards-compatible bug fixes that are added will __bump the patch version__.



[api-docs]: https://www.dartdocs.org/documentation/over_react_test/1.0.0/over_react_test/over_react_test-library.html
[contributing-docs]: https://github.com/Workiva/over_react/blob/master/.github/CONTRIBUTING.md
[over-react]: https://github.com/Workiva/over_react
