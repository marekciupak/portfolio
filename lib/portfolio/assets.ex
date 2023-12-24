defmodule Portfolio.Assets do
  @moduledoc """
  The Assets context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Assets.{Asset, Value}

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

  def change_asset(%Asset{} = asset, attrs \\ %{}) do
    Asset.changeset(asset, attrs)
  end
end
