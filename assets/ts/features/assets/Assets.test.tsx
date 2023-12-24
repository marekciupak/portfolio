import React from "react";
import {beforeAll, afterEach, afterAll, test, expect} from "@jest/globals";
import {rest} from "msw";
import {setupServer} from "msw/node";
import {renderWithProviders} from "../../utils/test-utils";
import {screen} from "@testing-library/react";
import Assets from "./Assets";

const server = setupServer(
  rest.get("/api/v1/assets", (_req, res, ctx) => {
    return res(
      ctx.json({
        data: [
          {
            symbol: "acwi.uk",
            trade_currency_code: "GBP",
          },
          {
            symbol: "vwra.uk",
            trade_currency_code: "USD",
          },
        ],
      }),
      ctx.delay(50),
    );
  }),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

test("displays all assets", async () => {
  renderWithProviders(<Assets />);

  expect(screen.getByText("Assets")).toBeTruthy();
  expect(await screen.findByText("acwi.uk")).toBeTruthy();
  expect(screen.getByText("vwra.uk")).toBeTruthy();
});
