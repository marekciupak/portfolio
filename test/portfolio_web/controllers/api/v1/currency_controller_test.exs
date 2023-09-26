defmodule PortfolioWeb.API.V1.CurrencyControllerTest do
  use PortfolioWeb.ConnCase

  import Portfolio.CurrenciesFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all currencies", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/currencies")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup [:create_currency]

    test "renders currency", %{
      conn: conn,
      currency: currency,
      currency_pair: currency_pair,
      exchange_rate: exchange_rate
    } do
      conn = get(conn, ~p"/api/v1/currencies/#{currency.code}")

      assert json_response(conn, 200)["data"] == %{
               "code" => currency.code,
               "exchange_rates" => [
                 %{
                   "quote_code" => currency_pair.quote_code,
                   "values" => [
                     [
                       exchange_rate.date |> DateTime.new!(~T[00:00:00]) |> DateTime.to_unix()
                     ],
                     [
                       Decimal.to_string(exchange_rate.mid)
                     ]
                   ]
                 }
               ]
             }
    end
  end

  defp create_currency(_) do
    currency = currency_fixture()
    currency_pair = currency_pair_fixture(quote_code: currency.code)
    exchange_rate = exchange_rate_fixture(currency_pair_id: currency_pair.id)
    %{currency: currency, currency_pair: currency_pair, exchange_rate: exchange_rate}
  end
end
