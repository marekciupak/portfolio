# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfol.Repo.Migrations.CreateExchangeRates do
  use Ecto.Migration

  def change do
    create table(:exchange_rates, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :currency_pair_id, references(:currency_pairs, on_delete: :delete_all, column: :id, type: :binary_id),
        null: false

      add :date, :date, null: false
      add :mid, :decimal, precision: 7, scale: 4, null: false
    end

    create unique_index(:exchange_rates, [:currency_pair_id, :date])
  end
end
