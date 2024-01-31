/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import React, {PropsWithChildren} from "react";
import {render} from "@testing-library/react";
import type {RenderOptions} from "@testing-library/react";
import type {PreloadedState} from "@reduxjs/toolkit";
import {Provider} from "react-redux";
import {MemoryRouter} from "react-router-dom";

import {setupStore} from "../app/store";
import type {AppStore, RootState} from "../app/store";

// This type interface extends the default options for render from RTL, as well
// as allows the user to specify other things such as initialState, store.
interface ExtendedRenderOptions extends Omit<RenderOptions, "queries"> {
  preloadedState?: PreloadedState<RootState>;
  store?: AppStore;
  route?: string;
}

// https://github.com/reduxjs/redux/blob/e312a02cbfdc021432fdf82f5d0499483391ec5f/docs/usage/WritingTests.mdx#L289
export const renderWithProviders = (
  ui: React.ReactElement,
  {
    preloadedState = {},
    // Automatically create a store instance if no store was passed in
    store = setupStore(preloadedState),
    route = "/",
    ...renderOptions
  }: ExtendedRenderOptions = {},
) => {
  const Wrapper = ({children}: PropsWithChildren<NonNullable<unknown>>): JSX.Element => {
    return (
      <Provider store={store}>
        <MemoryRouter initialEntries={[route]}>{children}</MemoryRouter>
      </Provider>
    );
  };
  return {store, ...render(ui, {wrapper: Wrapper, ...renderOptions})};
};
