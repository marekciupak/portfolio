import React from "react";
import {createRoot} from "react-dom/client";
import {setupStore} from "./app/store";
import {Provider} from "react-redux";
import {createBrowserRouter, RouterProvider} from "react-router-dom";
import Root from "./Root";
import ErrorPage from "./ErrorPage";
import Currencies from "./features/currencies/Currencies";
import Currency from "./features/currencies/Currency";

const rootElement = document.getElementById("root");
if (!rootElement) throw new Error("Failed to find the root element.");
const root = createRoot(rootElement);

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
      {index: true, element: <div>Hello!</div>},
      {path: "currencies", element: <Currencies />},
      {path: "currencies/:code", element: <Currency />},
    ],
  },
]);

root.render(
  <React.StrictMode>
    <Provider store={setupStore()}>
      <RouterProvider router={router} />
    </Provider>
  </React.StrictMode>
);
