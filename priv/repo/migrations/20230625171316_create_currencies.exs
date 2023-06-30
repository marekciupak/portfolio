defmodule Portfolio.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies, primary_key: false) do
      add :code, :string, primary_key: true
    end
  end
end
