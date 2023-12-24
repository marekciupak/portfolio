defmodule PortfolioWeb.API.V1.AssetJSON do
  @doc """
  Renders a list of assets.
  """
  def index(%{assets: assets}) do
    %{
      data:
        Enum.map(assets, fn asset ->
          %{
            symbol: asset.symbol,
            trade_currency_code: asset.trade_currency_code
          }
        end)
    }
  end

  @doc """
  Renders a single asset.
  """
  def show(%{asset: asset}) do
    %{
      data: %{
        symbol: asset.symbol,
        trade_currency_code: asset.trade_currency_code,
        values: [
          Enum.map(asset.values, &date_to_unixtime(&1.date)),
          Enum.map(asset.values, &Decimal.to_string(&1.close, :xsd))
        ]
      }
    }
  end

  defp date_to_unixtime(date), do: date |> DateTime.new!(~T[00:00:00]) |> DateTime.to_unix()
end
