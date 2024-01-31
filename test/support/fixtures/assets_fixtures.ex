# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.AssetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Portfolio.Assets` context.
  """

  alias Portfolio.Assets

  @doc """
  Generate a asset.
  """
  def asset_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{symbol: "vwra.uk"})
    |> Assets.create_asset!()
  end

  @doc """
  Generate an asset value.
  """
  def value_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      date: ~D[2019-07-26],
      close: Decimal.new("80.07"),
      high: Decimal.new("80.12"),
      low: Decimal.new("79.99"),
      open: Decimal.new("79.99"),
      volume: 110
    })
    |> Assets.create_value!()
  end
end
