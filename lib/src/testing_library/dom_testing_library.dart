// @dart = 2.7

/// https://testing-library.com/docs/dom-testing-library/intro
library over_react_test.src.dom_testing_library;

export 'dom/async/types.dart' show MutationObserverOptions;
export 'dom/async/wait_for.dart' show waitFor, waitForElementToBeRemoved, waitForElementsToBeRemoved;
export 'dom/config/configure.dart' show configure, getConfig;
export 'dom/matches/get_default_normalizer.dart' show getDefaultNormalizer;
export 'dom/pretty_dom.dart' show prettyDOM;
export 'dom/screen.dart' show screen;
export 'dom/within.dart' show within;
// ignore: directives_ordering
export 'dom/top_level_queries.dart'
    show
        getByAltText,
        getAllByAltText,
        queryByAltText,
        queryAllByAltText,
        findByAltText,
        findAllByAltText,
        getByDisplayValue,
        getAllByDisplayValue,
        queryByDisplayValue,
        queryAllByDisplayValue,
        findByDisplayValue,
        findAllByDisplayValue,
        getByLabelText,
        getAllByLabelText,
        queryByLabelText,
        queryAllByLabelText,
        findByLabelText,
        findAllByLabelText,
        getByPlaceholderText,
        getAllByPlaceholderText,
        queryByPlaceholderText,
        queryAllByPlaceholderText,
        findByPlaceholderText,
        findAllByPlaceholderText,
        getByRole,
        getAllByRole,
        queryByRole,
        queryAllByRole,
        findByRole,
        findAllByRole,
        getByText,
        getAllByText,
        queryByText,
        queryAllByText,
        findByText,
        findAllByText,
        getByTestId,
        getAllByTestId,
        queryByTestId,
        queryAllByTestId,
        findByTestId,
        findAllByTestId,
        getByTitle,
        getAllByTitle,
        queryByTitle,
        queryAllByTitle,
        findByTitle,
        findAllByTitle;
