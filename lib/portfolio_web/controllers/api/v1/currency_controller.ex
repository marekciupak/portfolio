defmodule PortfolioWeb.API.V1.CurrencyController do
  use PortfolioWeb, :controller

  alias Portfolio.Currencies

  action_fallback PortfolioWeb.FallbackController

  def index(conn, _params) do
    currencies = Currencies.list_currencies()
    render(conn, :index, currencies: currencies)
  end
end
