# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Stooq.Client do
  alias Stooq.Value

  def get_historical_values(params) do
    params
    |> parse_params()
    |> URI.encode_query()
    |> build_url()
    |> HTTP.get!()
    |> Map.fetch!(:body)
    |> String.split("\r\n", trim: true)
    |> parse_rows()
  end

  defp parse_params(params) do
    params
    |> Enum.reduce(%{i: "d"}, fn param, acc ->
      case param do
        {:symbol, symbol} ->
          Map.put(acc, :s, symbol)

        {:date_range, %Date.Range{first: from, last: to}} ->
          Map.merge(acc, %{d1: Date.to_iso8601(from, :basic), d2: Date.to_iso8601(to, :basic)})
      end
    end)
  end

  defp build_url(query) do
    "https://stooq.pl/q/d/l/?#{query}"
  end

  defp parse_rows(["Brak danych"]) do
    []
  end

  defp parse_rows(["Data,Otwarcie,Najwyzszy,Najnizszy,Zamkniecie,Wolumen" | rest]) do
    parse_rows(rest, [])
  end

  defp parse_rows([row | rest], acc) do
    rest
    |> parse_rows([parse_row(row) | acc])
  end

  defp parse_rows([], acc) do
    Enum.reverse(acc)
  end

  defp parse_row(row) when is_bitstring(row) do
    row
    |> String.split(",")
    |> parse_row()
  end

  defp parse_row([date, open, high, low, close]) do
    parse_row([date, open, high, low, close, nil])
  end

  defp parse_row([date, open, high, low, close, volume]) do
    %Value{
      date: Date.from_iso8601!(date),
      open: Decimal.new(open),
      high: Decimal.new(high),
      low: Decimal.new(low),
      close: Decimal.new(close),
      volume: volume && String.to_integer(volume)
    }
  end
end
