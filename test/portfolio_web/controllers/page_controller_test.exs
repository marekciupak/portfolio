# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule PortfolioWeb.PageControllerTest do
  use PortfolioWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "<div id=\"root\"></div>"
  end
end
