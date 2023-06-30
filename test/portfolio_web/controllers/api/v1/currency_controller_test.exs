defmodule PortfolioWeb.API.V1.CurrencyControllerTest do
  use PortfolioWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all currencies", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/currencies")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
