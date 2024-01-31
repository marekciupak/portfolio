/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import {createSlice, createEntityAdapter, createAsyncThunk} from "@reduxjs/toolkit";
import type {RootState} from "../../app/store";
import currenciesAPI from "./currenciesAPI";

export type Currency = {
  code: string;
  exchange_rates?: {
    values: [number[], number[]];
    quote_code: "PLN";
  }[];
};

const currenciesAdapter = createEntityAdapter<Currency>({selectId: (currency) => currency.code});

export const fetchCurrencies = createAsyncThunk("currenciess/fetchCurrencies", (_, {rejectWithValue}) =>
  currenciesAPI
    .fetchCurrencies()
    .then((response) => response.data.data)
    .catch((error) => rejectWithValue(error)),
);

export const fetchCurrency = createAsyncThunk(
  "currenciess/fetchCurrency",
  (code: Currency["code"], {rejectWithValue}) =>
    currenciesAPI
      .fetchCurrency(code)
      .then((response) => response.data.data)
      .catch((error) => rejectWithValue(error)),
);

const GENERIC_ERROR_MESSAGE = "Something went wrong.";

type status = "idle" | "loading" | "succeeded" | "failed";
type error = string | null;
type meta = {
  [key: Currency["code"]]: {status: status; error: error};
};

const currenciesSlice = createSlice({
  name: "currencies",
  initialState: currenciesAdapter.getInitialState({
    status: "idle" as status,
    error: null as error,
    meta: {} as meta,
  }),
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCurrencies.pending, (state, _action) => {
        state.status = "loading";
      })
      .addCase(fetchCurrencies.fulfilled, (state, action) => {
        state.status = "succeeded";
        currenciesAdapter.upsertMany(state, action.payload);
      })
      .addCase(fetchCurrencies.rejected, (state, action) => {
        state.status = "failed";
        state.error = action.error.message || GENERIC_ERROR_MESSAGE;
      })
      .addCase(fetchCurrency.pending, (state, action) => {
        state.meta[action.meta.arg] = {...state.meta[action.meta.arg], status: "loading"};
      })
      .addCase(fetchCurrency.fulfilled, (state, action) => {
        state.meta[action.meta.arg] = {...state.meta[action.meta.arg], status: "succeeded"};
        currenciesAdapter.setOne(state, action.payload);
      })
      .addCase(fetchCurrency.rejected, (state, action) => {
        state.meta[action.meta.arg] = {
          ...state.meta[action.meta.arg],
          status: "failed",
          error: action.error.message || GENERIC_ERROR_MESSAGE,
        };
      });
  },
});

export default currenciesSlice.reducer;

export const {selectAll: selectAllCurrencies, selectById: selectCurrencyById} = currenciesAdapter.getSelectors(
  (state: RootState) => state.currencies,
);

export const selectLoadingStatusById = (state: RootState, code: Currency["code"]) =>
  state.currencies.meta[code] === undefined ? "idle" : state.currencies.meta[code].status;
