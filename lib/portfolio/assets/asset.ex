# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Assets.Asset do
  use Ecto.Schema
  import Ecto.Changeset

  alias Portfolio.Assets.Value
  alias Portfolio.Currencies.Currency

  @primary_key {:symbol, :string, autogenerate: false}
  @foreign_key_type :binary_id
  schema "assets" do
    belongs_to(:trade_currency, Currency, references: :code, foreign_key: :trade_currency_code, type: :string)
    field :values_fetched_at, :naive_datetime

    has_many(:values, Value)
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:symbol, :trade_currency_code, :values_fetched_at])
    |> validate_required([:symbol, :trade_currency_code])
    |> foreign_key_constraint(:trade_currency_code)
  end
end
