defmodule Portfolio.Currencies.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:code, :string, autogenerate: false}
  @foreign_key_type :binary_id
  schema "currencies" do
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:code])
    |> validate_required([:code])
  end
end
