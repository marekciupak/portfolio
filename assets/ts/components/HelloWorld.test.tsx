import React from "react";
import {expect, test} from "@jest/globals";
import {render, screen} from "@testing-library/react";
import HelloWorld from "./HelloWorld";

test("displays hello world", () => {
  render(<HelloWorld />);

  expect(screen.getByText("Hello, world")).toBeTruthy;
});
