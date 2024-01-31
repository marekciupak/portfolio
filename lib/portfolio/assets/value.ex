# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Assets.Value do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "asset_values" do
    field :asset_symbol, :string
    field :close, :decimal
    field :date, :date
    field :high, :decimal
    field :low, :decimal
    field :open, :decimal
    field :volume, :integer
  end

  @doc false
  def changeset(value, attrs) do
    value
    |> cast(attrs, [:asset_symbol, :date, :open, :high, :low, :close, :volume])
    |> validate_required([:asset_symbol, :date, :open, :high, :low, :close])
    |> foreign_key_constraint(:asset_symbol)
    |> unique_constraint([:asset_symbol, :date])
  end
end
