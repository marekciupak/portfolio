defmodule Portfolio.Currencies.CurrencyPair do
  use Ecto.Schema
  import Ecto.Changeset

  alias Portfolio.Currencies.ExchangeRate

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "currency_pairs" do
    field :base_code, :string
    field :quote_code, :string
    field :exchange_rates_fetched_at, :naive_datetime

    has_many(:exchange_rates, ExchangeRate)
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:base_code, :quote_code, :exchange_rates_fetched_at])
    |> validate_required([:base_code, :quote_code])
    |> foreign_key_constraint(:base_code)
    |> foreign_key_constraint(:quote_code)
    |> unique_constraint([:base_code, :quote_code])
  end
end
