defmodule Portfolio.CurrenciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Currencies` context.
  """

  alias Portfolio.Currencies

  @doc """
  Generate a currency.
  """
  def currency_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{code: "USD"})
    |> Currencies.create_currency!()
  end

  @doc """
  Generate a currency pair.
  """
  def currency_pair_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{base_code: "USD", quote_code: Currencies.default_currency_code()})
    |> Currencies.create_currency_pair!()
  end

  @doc """
  Generate an exchange rate.
  """
  def exchange_rate_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{date: ~D[2000-01-01], mid: Decimal.new("4.1200")})
    |> Currencies.create_exchange_rate!()
  end
end
