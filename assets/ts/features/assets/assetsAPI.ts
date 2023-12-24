import axios from "axios";
import type {AxiosInstance, AxiosResponseTransformer} from "axios";

type AssetSymbol = string;

type GetAssetsResponse = {
  data: {
    symbol: AssetSymbol;
    trade_currency_code: string;
  }[];
};

type GetAssetResponseRaw = {
  data: {
    symbol: AssetSymbol;
    trade_currency_code: string;
    values: [number[], string[]];
  };
};

type GetAssetResponse = {
  data: {
    symbol: AssetSymbol;
    trade_currency_code: string;
    values: [number[], number[]];
  };
};

class AssetsAPI {
  client: AxiosInstance;

  constructor() {
    this.client = axios.create({
      baseURL: "/api",
      headers: {
        Accept: "application/json",
      },
    });
  }

  fetchAssets() {
    return this.client.get<GetAssetsResponse>("/v1/assets");
  }

  fetchAsset(symbol: AssetSymbol) {
    return this.client.get<GetAssetResponse>(`/v1/assets/${symbol}`, {
      transformResponse: [
        ...(this.client.defaults.transformResponse as AxiosResponseTransformer[]),
        (res: GetAssetResponseRaw): GetAssetResponse => ({
          ...res,
          data: {
            ...res.data,
            values: [res.data.values[0], res.data.values[1].map((close) => parseFloat(close))],
          },
        }),
      ],
    });
  }
}

export default new AssetsAPI();
