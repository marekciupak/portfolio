defmodule Portfolio.AssetsTest do
  use Portfolio.DataCase

  import Portfolio.{CurrenciesFixtures, AssetsFixtures}

  alias Portfolio.Assets

  describe "assets" do
    setup [:create_currency]

    test "list_assets/0 returns all assets", %{currency: trade_currency} do
      asset = asset_fixture(trade_currency_code: trade_currency.code)
      assert Assets.list_assets() == [asset]
    end

    test "get_asset!/1 returns the asset with given symbol", %{currency: trade_currency} do
      asset = asset_fixture(trade_currency_code: trade_currency.code)
      assert Assets.get_asset!(asset.symbol).symbol == asset.symbol
    end

    test "create_asset!/1 with valid data creates a asset", %{currency: trade_currency} do
      valid_attrs = %{symbol: "vwra.uk", trade_currency_code: trade_currency.code}

      asset = Assets.create_asset!(valid_attrs)
      assert asset.symbol == "vwra.uk"
    end
  end

  defp create_currency(_) do
    %{currency: currency_fixture()}
  end
end
