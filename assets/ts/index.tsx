import React from "react";
import {createRoot} from "react-dom/client";
import {store} from "./app/store";
import {Provider} from "react-redux";
import HelloWorld from "./components/HelloWorld";

const rootElement = document.getElementById("root");
if (!rootElement) throw new Error("Failed to find the root element.");
const root = createRoot(rootElement);

root.render(
  <React.StrictMode>
    <Provider store={store}>
      <HelloWorld />
    </Provider>
  </React.StrictMode>
);
