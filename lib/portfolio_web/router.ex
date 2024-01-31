# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule PortfolioWeb.Router do
  use PortfolioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_live_flash
    plug :put_root_layout, html: {PortfolioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => "default-src 'self'"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PortfolioWeb.API, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/currencies", CurrencyController, only: [:index, :show], param: "code"
      resources "/assets", AssetController, only: [:index, :show], param: "symbol"
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:portfolio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PortfolioWeb.Telemetry
    end
  end

  scope "/", PortfolioWeb do
    pipe_through :browser

    get "/*page", PageController, :index
  end
end
