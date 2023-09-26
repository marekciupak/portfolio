defmodule Portfolio.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  alias Portfolio.Currencies.CurrencyPair

  @primary_key {:code, :string, autogenerate: false}
  @foreign_key_type :binary_id
  schema "currencies" do
    has_many(:pairs, CurrencyPair, foreign_key: :base_code)
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:code])
    |> validate_required([:code])
  end
end
