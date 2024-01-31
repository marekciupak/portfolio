# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule PortfolioWeb.API.V1.CurrencyController do
  use PortfolioWeb, :controller

  alias Portfolio.Currencies

  action_fallback PortfolioWeb.FallbackController

  def index(conn, _params) do
    currencies = Currencies.list_currencies()
    render(conn, :index, currencies: currencies)
  end

  def show(conn, %{"code" => code}) do
    currency = Currencies.get_currency!(code)
    render(conn, :show, currency: currency)
  end
end
