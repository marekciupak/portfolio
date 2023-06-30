import React from "react";
import {createRoot} from "react-dom/client";
import {setupStore} from "./app/store";
import {Provider} from "react-redux";
import Root from "./Root";

const rootElement = document.getElementById("root");
if (!rootElement) throw new Error("Failed to find the root element.");
const root = createRoot(rootElement);

root.render(
  <React.StrictMode>
    <Provider store={setupStore()}>
      <Root />
    </Provider>
  </React.StrictMode>
);
