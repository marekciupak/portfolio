defmodule Portfolio.Currencies do
  @moduledoc """
  The Currencies context.
  """

  import Ecto.Query, warn: false
  alias Portfolio.Repo

  alias Portfolio.Currencies.Currency

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
  Gets a single currency.

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
  end

  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency!(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Creates currencies with given codes. It skips currencies that already exist (no error is returned).

  ## Examples

      iex> create_currencies(["USD", "PLN"])
      {2, nil}

  """
  def create_currencies(codes) when is_list(codes) do
    currencies = Enum.map(codes, fn code -> [code: code] end)

    Repo.insert_all(Currency, currencies, on_conflict: :nothing)
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
end
