/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import React from "react";
import {beforeAll, afterEach, afterAll, test, expect} from "@jest/globals";
import {rest} from "msw";
import {setupServer} from "msw/node";
import {renderWithProviders} from "../../utils/test-utils";
import {screen} from "@testing-library/react";
import Currencies from "./Currencies";

const server = setupServer(
  rest.get("/api/v1/currencies", (_req, res, ctx) => {
    return res(ctx.json({data: [{code: "USD"}, {code: "PLN"}]}), ctx.delay(50));
  }),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

test("displays all currencies", async () => {
  renderWithProviders(<Currencies />);

  expect(screen.getByText("Currencies")).toBeTruthy();
  expect(await screen.findByText("USD")).toBeTruthy();
  expect(screen.getByText("PLN")).toBeTruthy();
});
