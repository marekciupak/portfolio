# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Currencies do
  @moduledoc """
  The Currencies context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Currencies.{Currency, CurrencyPairs, CurrencyPair, ExchangeRate}

  @default_currency_code "PLN"

  defdelegate fetch_exchange_rates, to: CurrencyPairs

  @doc """
  Returns the list of currencies.

  ## Examples

      iex> list_currencies()
      [%Currency{}, ...]

  """
  def list_currencies do
    Repo.all(Currency)
  end

  @doc """
  Gets a single currency with exchange rates ordered by date.

  Raises `Ecto.NoResultsError` if the Currency does not exist.

  ## Examples

      iex> get_currency!("USD")
      %Currency{}

      iex> get_currency!("XXX")
      ** (Ecto.NoResultsError)

  """
  def get_currency!(code) when is_binary(code) do
    Currency
    |> Repo.get!(code)
    |> Repo.preload(pairs: [exchange_rates: from(e in ExchangeRate, order_by: [asc: e.date])])
  end

  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency!(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency!(%{})
      ** (Ecto.InvalidChangesetError)

  """
  def create_currency!(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates a currency pair.

  ## Examples

      iex> create_currency_pair!(%{field: value})
      {:ok, %CurrencyPair{}}

  """
  def create_currency_pair!(attrs \\ %{}) do
    %CurrencyPair{}
    |> CurrencyPair.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates an exchange rate.

  ## Examples

      iex> create_exchange_rate!(%{field: value})
      {:ok, %ExchangeRate{}}

  """
  def create_exchange_rate!(attrs \\ %{}) do
    %ExchangeRate{}
    |> ExchangeRate.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates currencies with given codes. For each it also creates a pair with the default currency.

  It skips records that already exist (no error is returned).

  ## Examples

      iex> create_currencies(["USD", "PLN"])
      {:ok, {2, nil}}

  """
  def create_currencies(codes) when is_list(codes) do
    currencies = Enum.map(codes, fn code -> [code: code] end)

    pairs =
      codes
      |> Enum.reject(fn code -> code == @default_currency_code end)
      |> Enum.map(fn code -> [base_code: code, quote_code: @default_currency_code] end)

    Repo.transaction(fn ->
      Repo.insert_all(Currency, currencies, on_conflict: :nothing)
      Repo.insert_all(CurrencyPair, pairs, conflict_target: [:base_code, :quote_code], on_conflict: :nothing)
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking currency changes.

  ## Examples

      iex> change_currency(currency)
      %Ecto.Changeset{data: %Currency{}}

  """
  def change_currency(%Currency{} = currency, attrs \\ %{}) do
    Currency.changeset(currency, attrs)
  end

  @doc """
  Returns a default currency code.
  """
  def default_currency_code, do: @default_currency_code
end
