defmodule Portfolio.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Currencies` context.
  """

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{code: "USD"})
    |> Portfolio.Currencies.create_currency!()
  end
end
