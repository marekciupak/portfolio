/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import {combineReducers, configureStore} from "@reduxjs/toolkit";
import type {PreloadedState} from "@reduxjs/toolkit";
import currenciesReducer from "../features/currencies/currenciesSlice";
import assetsReducer from "../features/assets/assetsSlice";

const rootReducer = combineReducers({
  currencies: currenciesReducer,
  assets: assetsReducer,
});

export const setupStore = (preloadedState?: PreloadedState<RootState>) => {
  return configureStore({
    reducer: rootReducer,
    preloadedState,
  });
};

export type RootState = ReturnType<typeof rootReducer>;
export type AppStore = ReturnType<typeof setupStore>;
export type AppDispatch = AppStore["dispatch"];
