import axios from "axios";
import type {AxiosInstance} from "axios";

export type Currency = {
  code: string;
};

type GetCurrenciesResponse = {
  data: Currency[];
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
}

export default new CurrenciesAPI();
