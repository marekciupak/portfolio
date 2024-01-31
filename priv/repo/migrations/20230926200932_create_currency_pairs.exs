# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfol.Repo.Migrations.CreateCurrencyPairs do
  use Ecto.Migration

  def change do
    create table(:currency_pairs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :base_code, references(:currencies, on_delete: :delete_all, column: :code, type: :string), null: false
      add :quote_code, references(:currencies, on_delete: :delete_all, column: :code, type: :string), null: false
      add :exchange_rates_fetched_at, :naive_datetime
    end

    create unique_index(:currency_pairs, [:base_code, :quote_code])
    create index(:currency_pairs, [:exchange_rates_fetched_at])
  end
end
