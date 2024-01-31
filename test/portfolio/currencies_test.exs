# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.CurrenciesTest do
  use Portfolio.DataCase

  alias Portfolio.Currencies

  describe "currencies" do
    import Portfolio.CurrenciesFixtures

    test "list_currencies/0 returns all currencies" do
      currency = currency_fixture()
      assert Currencies.list_currencies() == [currency]
    end

    test "get_currency!/1 returns the currency with given code" do
      currency = currency_fixture()
      assert Currencies.get_currency!(currency.code).code == currency.code
    end

    test "create_currency!/1 with valid data creates a currency" do
      valid_attrs = %{code: "PLN"}

      currency = Currencies.create_currency!(valid_attrs)
      assert currency.code == "PLN"
    end
  end
end
