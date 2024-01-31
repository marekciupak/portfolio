# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule PortfolioWeb.API.V1.CurrencyJSON do
  @doc """
  Renders a list of currencies.
  """
  def index(%{currencies: currencies}) do
    %{
      data:
        Enum.map(currencies, fn currency ->
          %{
            code: currency.code
          }
        end)
    }
  end

  @doc """
  Renders a single currency.
  """
  def show(%{currency: currency}) do
    %{
      data: %{
        code: currency.code,
        exchange_rates:
          Enum.map(currency.pairs, fn pair ->
            %{
              quote_code: pair.quote_code,
              values: [
                Enum.map(pair.exchange_rates, &date_to_unixtime(&1.date)),
                Enum.map(pair.exchange_rates, & &1.mid)
              ]
            }
          end)
      }
    }
  end

  defp date_to_unixtime(date), do: date |> DateTime.new!(~T[00:00:00]) |> DateTime.to_unix()
end
