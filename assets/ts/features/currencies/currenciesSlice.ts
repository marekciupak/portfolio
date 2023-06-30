import {createSlice, createEntityAdapter, createAsyncThunk} from "@reduxjs/toolkit";
import type {RootState} from "../../app/store";
import currenciesAPI from "./currenciesAPI";
import type {Currency} from "./currenciesAPI";

const currenciesAdapter = createEntityAdapter<Currency>({selectId: (currency) => currency.code});

export const fetchCurrencies = createAsyncThunk("currenciess/fetchCurrencies", (_, {rejectWithValue}) =>
  currenciesAPI
    .fetchCurrencies()
    .then((response) => response.data.data)
    .catch((error) => rejectWithValue(error))
);

const GENERIC_ERROR_MESSAGE = "Something went wrong.";

const currenciesSlice = createSlice({
  name: "currencies",
  initialState: currenciesAdapter.getInitialState({
    status: "idle" as "idle" | "loading" | "succeeded" | "failed",
    error: null as string | null,
  }),
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCurrencies.pending, (state, _action) => {
        state.status = "loading";
      })
      .addCase(fetchCurrencies.fulfilled, (state, action) => {
        state.status = "succeeded";
        currenciesAdapter.setMany(state, action.payload);
      })
      .addCase(fetchCurrencies.rejected, (state, action) => {
        state.status = "failed";
        state.error = action.error.message || GENERIC_ERROR_MESSAGE;
      });
  },
});

export default currenciesSlice.reducer;

export const {selectAll: selectAllCurrencies} = currenciesAdapter.getSelectors((state: RootState) => state.currencies);
