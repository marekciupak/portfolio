/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import {createSlice, createEntityAdapter, createAsyncThunk} from "@reduxjs/toolkit";
import type {RootState} from "../../app/store";
import assetsAPI from "./assetsAPI";

export type Asset = {
  symbol: string;
  trade_currency_code: string;
  values?: [number[], number[]];
};

const assetsAdapter = createEntityAdapter<Asset>({selectId: (asset) => asset.symbol});

export const fetchAssets = createAsyncThunk("assetss/fetchAssets", (_, {rejectWithValue}) =>
  assetsAPI
    .fetchAssets()
    .then((response) => response.data.data)
    .catch((error) => rejectWithValue(error)),
);

export const fetchAsset = createAsyncThunk("assetss/fetchAsset", (symbol: Asset["symbol"], {rejectWithValue}) =>
  assetsAPI
    .fetchAsset(symbol)
    .then((response) => response.data.data)
    .catch((error) => rejectWithValue(error)),
);

const GENERIC_ERROR_MESSAGE = "Something went wrong.";

type status = "idle" | "loading" | "succeeded" | "failed";
type error = string | null;
type meta = {
  [key: Asset["symbol"]]: {status: status; error: error};
};

const assetsSlice = createSlice({
  name: "assets",
  initialState: assetsAdapter.getInitialState({
    status: "idle" as status,
    error: null as error,
    meta: {} as meta,
  }),
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchAssets.pending, (state, _action) => {
        state.status = "loading";
      })
      .addCase(fetchAssets.fulfilled, (state, action) => {
        state.status = "succeeded";
        assetsAdapter.upsertMany(state, action.payload);
      })
      .addCase(fetchAssets.rejected, (state, action) => {
        state.status = "failed";
        state.error = action.error.message || GENERIC_ERROR_MESSAGE;
      })
      .addCase(fetchAsset.pending, (state, action) => {
        state.meta[action.meta.arg] = {...state.meta[action.meta.arg], status: "loading"};
      })
      .addCase(fetchAsset.fulfilled, (state, action) => {
        state.meta[action.meta.arg] = {...state.meta[action.meta.arg], status: "succeeded"};
        assetsAdapter.setOne(state, action.payload);
      })
      .addCase(fetchAsset.rejected, (state, action) => {
        state.meta[action.meta.arg] = {
          ...state.meta[action.meta.arg],
          status: "failed",
          error: action.error.message || GENERIC_ERROR_MESSAGE,
        };
      });
  },
});

export default assetsSlice.reducer;

export const {selectAll: selectAllAssets, selectById: selectAssetById} = assetsAdapter.getSelectors(
  (state: RootState) => state.assets,
);

export const selectLoadingStatusById = (state: RootState, symbol: Asset["symbol"]) =>
  state.assets.meta[symbol] === undefined ? "idle" : state.assets.meta[symbol].status;
