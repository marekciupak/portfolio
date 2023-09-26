import axios from "axios";
import type {AxiosInstance} from "axios";

type Code = string;

type GetCurrenciesResponse = {
  data: {
    code: Code;
  }[];
};

type GetCurrencyResponse = {
  data: {
    code: Code;
    exchange_rates: {
      values: [number[], string[]];
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
    return this.client.get<GetCurrencyResponse>(`/v1/currencies/${code}`);
  }
}

export default new CurrenciesAPI();
