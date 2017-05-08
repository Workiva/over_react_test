# OverReact Test

[![Pub](https://img.shields.io/pub/v/over_react_test.svg)](https://pub.dartlang.org/packages/over_react_test)
[![Build Status](https://travis-ci.org/Workiva/over_react_test.svg?branch=master)](https://travis-ci.org/Workiva/over_react_test)
[![Test Coverage](https://codecov.io/github/Workiva/over_react_test/coverage.svg?branch=master)](https://codecov.io/github/Workiva/over_react_test?branch=master)
[![Documentation](https://img.shields.io/badge/Documentation-over_react_test-blue.svg)](http://www.dartdocs.org/documentation/dartdoc/latest/)

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

## Variable and Type Naming Conventions

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
  SampleComponent sampleDartInstance = getDartComponent(renderedInstance);
  var sampleNode = findDomNode(renderedInstance);
});
```

## Documentation

You would never skip reading the docs for a new language you are asked to learn, so _please_ don't skip over reading these, either.

+ In-depth Dart doc comments for components props and utilities are available, for use when browsing and autocompleting code in an IDE.

## Contributing

Yes please! ([__Please read our contributor guidelines first__][contributing-docs])


## Versioning

The `over_react_test` library adheres to [Semantic Versioning](http://semver.org/):

* Any API changes that are not backwards compatible will __bump the major version__ _(and reset the minor / patch)_.
* Any new functionality that is added in a backwards-compatible manner will __bump the minor version__
  _(and reset the patch)_.
* Any backwards-compatible bug fixes that are added will __bump the patch version__.



[contributing-docs]: https://github.com/Workiva/over_react/blob/master/.github/CONTRIBUTING.md
[over-react]: https://github.com/Workiva/over_react#overreact
