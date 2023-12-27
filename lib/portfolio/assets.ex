defmodule Portfolio.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Assets.{Asset, Value, ValuesFetcher}

  defdelegate fetch_values, to: ValuesFetcher

  def list_assets() do
    Repo.all(Asset)
  end

  def get_asset!(symbol) do
    Asset
    |> Repo.get!(symbol)
    |> Repo.preload(values: from(v in Value, order_by: [asc: v.date]))
  end

  def create_asset!(attrs \\ %{}) do
    %Asset{}
    |> Asset.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates an asset value.

  ## Examples

      iex> create_value!(%{field: value})
      {:ok, %Value{}}

  """
  def create_value!(attrs \\ %{}) do
    %Value{}
    |> Value.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates assets with given symbols and trade currency codes.

  It updates trade currency codes for records that already exist (no error is returned).

  ## Examples

      iex> create_assets({"sgln.uk", "GBP"})
      {1, nil}

  """
  def create_assets(assets) when is_list(assets) do
    assets =
      Enum.map(assets, fn {symbol, trade_currency_code} ->
        [symbol: symbol, trade_currency_code: trade_currency_code]
      end)

    Repo.insert_all(Asset, assets, conflict_target: [:symbol], on_conflict: {:replace, [:trade_currency_code]})
  end

  def change_asset(%Asset{} = asset, attrs \\ %{}) do
    Asset.changeset(asset, attrs)
  end
end
