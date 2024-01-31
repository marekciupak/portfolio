/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import axios from "axios";
import type {AxiosInstance, AxiosResponseTransformer} from "axios";

type Code = string;

type GetCurrenciesResponse = {
  data: {
    code: Code;
  }[];
};

type GetCurrencyResponseRaw = {
  data: {
    code: Code;
    exchange_rates: {
      values: [number[], string[]];
      quote_code: "PLN";
    }[];
  };
};

type GetCurrencyResponse = {
  data: {
    code: Code;
    exchange_rates: {
      values: [number[], number[]];
      quote_code: "PLN";
    }[];
  };
};

class CurrenciesAPI {
  client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: "/api",
      headers: {
        Accept: "application/json",
      },
    });
  }

  fetchCurrencies() {
    return this.client.get<GetCurrenciesResponse>("/v1/currencies");
  }

  fetchCurrency(code: Code) {
    return this.client.get<GetCurrencyResponse>(`/v1/currencies/${code}`, {
      transformResponse: [
        ...(this.client.defaults.transformResponse as AxiosResponseTransformer[]),
        (res: GetCurrencyResponseRaw): GetCurrencyResponse => ({
          ...res,
          data: {
            ...res.data,
            exchange_rates: res.data.exchange_rates.map((exchange_rates) => ({
              ...exchange_rates,
              values: [exchange_rates.values[0], exchange_rates.values[1].map((mid) => parseFloat(mid))],
            })),
          },
        }),
      ],
    });
  }
}

export default new CurrenciesAPI();
