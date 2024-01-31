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
import Asset from "./Asset";

test("displays asset", async () => {
  renderWithProviders(
    <Routes>
      <Route path="/:symbol" element={<Asset />} />
    </Routes>,
    {route: "/vwra.uk"},
  );

  expect(screen.getByText("Asset", {exact: false})).toBeTruthy();
  expect(screen.getByText("vwra.uk", {exact: false})).toBeTruthy();
});
