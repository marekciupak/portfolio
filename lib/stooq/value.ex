# Copyright (C) 2023-2024 Marek Ciupak
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Stooq.Value do
  defstruct [:date, :open, :high, :low, :close, volume: nil]
end
