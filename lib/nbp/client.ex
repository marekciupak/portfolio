defmodule Nbp.Client do
  alias Nbp.ExchangeRate

  @table "A"
  @beginning_of_data_range ~D[2002-01-01]
  @max_days_period_per_request 367

  def get_exchange_rates(currency_code: currency_code, end_date: end_date) do
    get_exchange_rates(currency_code: currency_code, start_date: @beginning_of_data_range, end_date: end_date)
  end

  def get_exchange_rates(currency_code: currency_code, start_date: start_date, end_date: end_date) do
    split_into_smaller_ranges(start_date, end_date, @max_days_period_per_request)
    |> Enum.flat_map(fn [start_date, end_date] ->
      "http://api.nbp.pl/api/exchangerates/rates/#{@table}/#{currency_code}/#{start_date}/#{end_date}/"
      |> URI.new!()
      |> URI.to_string()
      |> HTTP.get!()
      |> handle_response()
    end)
  end

  defp split_into_smaller_ranges(start_date, end_date, size) do
    Date.range(start_date, Date.add(end_date, 1), size)
    |> Enum.chunk_every(2, 1, [Date.add(end_date, 1)])
    |> Enum.map(fn [start_date, next_start_date] -> [start_date, Date.add(next_start_date, -1)] end)
    |> Enum.reject(fn [start_date, end_date] -> Date.compare(start_date, end_date) == :gt end)
  end

  defp handle_response(%{status_code: 200, body: body}) do
    body
    |> Jason.decode!(floats: :decimals)
    |> parse_rates()
  end

  defp handle_response(%{status_code: 404}), do: []

  defp parse_rates(%{"rates" => rates}) do
    Enum.map(rates, &parse_rate(&1))
  end

  defp parse_rate(%{"effectiveDate" => date, "mid" => mid}) do
    %ExchangeRate{
      date: Date.from_iso8601!(date),
      mid: mid
    }
  end
end
