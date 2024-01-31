# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Portfolio.{Currencies, Assets}

Currencies.create_currencies(["PLN", "USD", "GBP", "EUR"])
Currencies.fetch_exchange_rates()

Assets.create_assets([
  {"acwi.uk", "GBP"},
  {"vwra.uk", "USD"}
])

Assets.fetch_values()
