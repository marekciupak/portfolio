defmodule Portfolio.Repo.Migrations.CreateAssetValues do
  use Ecto.Migration

  def change do
    create table(:asset_values, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :asset_symbol, references(:assets, on_delete: :delete_all, column: :symbol, type: :string), null: false
      add :date, :date, null: false
      add :open, :decimal, precision: 7, scale: 2, null: false
      add :high, :decimal, precision: 7, scale: 2, null: false
      add :low, :decimal, precision: 7, scale: 2, null: false
      add :close, :decimal, precision: 7, scale: 2, null: false
      add :volume, :integer
    end

    create unique_index(:asset_values, [:asset_symbol, :date])
  end
end
