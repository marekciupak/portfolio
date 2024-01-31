# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add :symbol, :string, primary_key: true
      add :trade_currency_code, references(:currencies, on_delete: :nothing, column: :code, type: :string), null: false
      add :values_fetched_at, :naive_datetime
    end

    create index(:assets, [:values_fetched_at])
  end
end
