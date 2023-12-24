defmodule PortfolioWeb.API.V1.AssetController do
  use PortfolioWeb, :controller

  alias Portfolio.Assets

  action_fallback PortfolioWeb.FallbackController

  def index(conn, _params) do
    assets = Assets.list_assets()
    render(conn, :index, assets: assets)
  end

  def show(conn, %{"symbol" => symbol}) do
    asset = Assets.get_asset!(symbol)
    render(conn, :show, asset: asset)
  end
end
