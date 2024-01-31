# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Portfolio.Repo do
  use Ecto.Repo,
    otp_app: :portfolio,
    adapter: Ecto.Adapters.Postgres
end
