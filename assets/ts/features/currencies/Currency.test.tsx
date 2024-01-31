/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import React from "react";
import {test, expect} from "@jest/globals";
import {renderWithProviders} from "../../utils/test-utils";
import {Routes, Route} from "react-router-dom";
import {screen} from "@testing-library/react";
import "../../utils/matchMedia.mock";
import Currency from "./Currency";

test("displays currency", async () => {
  renderWithProviders(
    <Routes>
      <Route path="/:code" element={<Currency />} />
    </Routes>,
    {route: "/USD"},
  );

  expect(screen.getByText("Currency", {exact: false})).toBeTruthy();
  expect(screen.getByText("USD", {exact: false})).toBeTruthy();
});
