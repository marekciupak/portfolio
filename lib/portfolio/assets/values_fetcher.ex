# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Assets.ValuesFetcher do
  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Assets.{Asset, Value}

  @hour 60 * 60
  @min_fetching_interval 3 * @hour

  def fetch_values() do
    became_stale_at = NaiveDateTime.utc_now(:second) |> NaiveDateTime.add(-@min_fetching_interval)

    from(a in Asset, where: is_nil(a.values_fetched_at) or a.values_fetched_at < ^became_stale_at)
    |> Repo.all()
    |> fetch_values()
  end

  defp fetch_values(assets) when is_list(assets) do
    assets
    |> preload_latest_value()
    |> Enum.each(&fetch_values/1)
  end

  defp fetch_values(%{symbol: symbol, values: values} = asset) do
    values
    |> case do
      [] -> []
      [lastest_value] -> [date_range: Date.range(Date.add(lastest_value.date, 1), Date.utc_today())]
    end
    |> Keyword.merge(symbol: symbol)
    |> Stooq.Client.get_historical_values()
    |> extrapolate_to_cover_all_days()
    |> create_values(asset)

    mark_as_fetched!(asset)
  end

  defp preload_latest_value(assets) do
    assets
    |> Repo.preload(values: from(v in Value, order_by: [desc: v.date], distinct: v.asset_symbol))
  end

  defp extrapolate_to_cover_all_days(values, acc \\ [])

  defp extrapolate_to_cover_all_days([value | rest], []) do
    extrapolate_to_cover_all_days(rest, [value])
  end

  defp extrapolate_to_cover_all_days([value | rest] = values, acc) do
    prev_value = List.first(acc)
    current_date = Date.add(prev_value.date, 1)

    case Date.compare(value.date, current_date) do
      :eq ->
        extrapolate_to_cover_all_days(rest, [value | acc])

      :gt ->
        value = %Stooq.Value{
          date: current_date,
          open: prev_value.open,
          high: prev_value.high,
          low: prev_value.low,
          close: prev_value.close,
          volume: prev_value.volume
        }

        extrapolate_to_cover_all_days(values, [value | acc])
    end
  end

  defp extrapolate_to_cover_all_days([], acc) do
    Enum.reverse(acc)
  end

  defp create_values(values, asset) do
    values =
      Enum.map(
        values,
        &%{
          open: &1.open,
          close: &1.close,
          high: &1.high,
          low: &1.low,
          volume: &1.volume,
          date: &1.date,
          asset_symbol: asset.symbol
        }
      )

    Repo.insert_all(
      Value,
      values,
      conflict_target: [:asset_symbol, :date],
      on_conflict: {:replace, [:open, :close, :high, :low, :volume]}
    )
  end

  defp mark_as_fetched!(asset) do
    asset
    |> Asset.changeset(%{values_fetched_at: NaiveDateTime.utc_now()})
    |> Repo.update!()
  end
end
