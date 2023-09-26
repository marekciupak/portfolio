# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias Portfolio.Currencies

Currencies.create_currencies(["PLN", "USD", "GBP", "EUR"])
Currencies.fetch_exchange_rates()
