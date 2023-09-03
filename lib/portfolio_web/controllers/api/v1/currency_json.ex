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
        code: currency.code
      }
    }
  end
end
