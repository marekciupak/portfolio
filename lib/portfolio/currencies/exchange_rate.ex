# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Currencies.ExchangeRate do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "exchange_rates" do
    field :currency_pair_id, :binary_id
    field :date, :date
    field :mid, :decimal
  end

  @doc false
  def changeset(exchange_rate, attrs) do
    exchange_rate
    |> cast(attrs, [:currency_pair_id, :date, :mid])
    |> validate_required([:currency_pair_id, :date, :mid])
    |> foreign_key_constraint(:currency_pair_id)
    |> unique_constraint([:currency_pair_id, :date])
  end
end
