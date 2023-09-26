defmodule Portfolio.Currencies.CurrencyPairs do
  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Currencies.{CurrencyPair, ExchangeRate}

  @hour 60 * 60
  @min_fetching_interval 3 * @hour

  def fetch_exchange_rates() do
    became_stale_at = NaiveDateTime.utc_now(:second) |> NaiveDateTime.add(-@min_fetching_interval)

    from(cp in CurrencyPair,
      where: is_nil(cp.exchange_rates_fetched_at) or cp.exchange_rates_fetched_at < ^became_stale_at
    )
    |> Repo.all()
    |> fetch_exchange_rates()
  end

  defp fetch_exchange_rates(pairs) when is_list(pairs) do
    pairs
    |> preload_latest_exchange_rate()
    |> Enum.each(&fetch_exchange_rates/1)
  end

  defp fetch_exchange_rates(%{base_code: base_code, quote_code: "PLN", exchange_rates: exchange_rates} = pair) do
    end_date = DateTime.now!("Europe/Warsaw") |> DateTime.to_date()

    exchange_rates
    |> case do
      [] -> []
      [lastest_exchange_rate] -> [start_date: Date.add(lastest_exchange_rate.date, 1)]
    end
    |> Keyword.merge(currency_code: base_code, end_date: end_date)
    |> Nbp.Client.get_exchange_rates()
    |> extrapolate_to_cover_all_days()
    |> create_exchange_rates(pair)

    mark_as_fetched!(pair)
  end

  defp preload_latest_exchange_rate(pairs) do
    Repo.preload(
      pairs,
      exchange_rates:
        from(
          e in ExchangeRate,
          order_by: [desc: e.date],
          distinct: e.currency_pair_id
        )
    )
  end

  defp extrapolate_to_cover_all_days(exchange_rates, acc \\ [])

  defp extrapolate_to_cover_all_days([exchange_rate | rest], []) do
    extrapolate_to_cover_all_days(rest, [exchange_rate])
  end

  defp extrapolate_to_cover_all_days([exchange_rate | rest] = exchange_rates, acc) do
    prev_exchange_rate = List.first(acc)
    current_date = Date.add(prev_exchange_rate.date, 1)

    case Date.compare(exchange_rate.date, current_date) do
      :eq ->
        extrapolate_to_cover_all_days(rest, [exchange_rate | acc])

      :gt ->
        exchange_rate = %Nbp.ExchangeRate{date: current_date, mid: prev_exchange_rate.mid}
        extrapolate_to_cover_all_days(exchange_rates, [exchange_rate | acc])
    end
  end

  defp extrapolate_to_cover_all_days([], acc) do
    Enum.reverse(acc)
  end

  defp create_exchange_rates(exchange_rates, pair) do
    exchange_rates =
      Enum.map(
        exchange_rates,
        &%{
          currency_pair_id: pair.id,
          date: &1.date,
          mid: &1.mid
        }
      )

    Repo.insert_all(
      ExchangeRate,
      exchange_rates,
      conflict_target: [:currency_pair_id, :date],
      on_conflict: {:replace, [:mid]}
    )
  end

  defp mark_as_fetched!(pair) do
    pair
    |> CurrencyPair.changeset(%{exchange_rates_fetched_at: NaiveDateTime.utc_now()})
    |> Repo.update!()
  end
end
