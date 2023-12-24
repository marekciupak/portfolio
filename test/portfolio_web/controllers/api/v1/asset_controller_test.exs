defmodule PortfolioWeb.API.V1.AssetControllerTest do
  use PortfolioWeb.ConnCase

  import Portfolio.{CurrenciesFixtures, AssetsFixtures}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all assets", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/assets")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup [:create_asset]

    test "renders asset", %{
      conn: conn,
      trade_currency: trade_currency,
      asset: asset,
      value: value
    } do
      conn = get(conn, ~p"/api/v1/assets/#{asset.symbol}")

      assert json_response(conn, 200)["data"] == %{
               "symbol" => asset.symbol,
               "trade_currency_code" => trade_currency.code,
               "values" => [
                 [
                   value.date |> DateTime.new!(~T[00:00:00]) |> DateTime.to_unix()
                 ],
                 [
                   Decimal.to_string(value.close, :xsd)
                 ]
               ]
             }
    end
  end

  defp create_asset(_) do
    trade_currency = currency_fixture()
    asset = asset_fixture(trade_currency_code: trade_currency.code)
    value = value_fixture(asset_symbol: asset.symbol)
    %{trade_currency: trade_currency, asset: asset, value: value}
  end
end
