/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import React, {useEffect} from "react";
import {Link} from "react-router-dom";
import {useAppDispatch, useAppSelector} from "../../app/hooks";
import {fetchCurrencies, selectAllCurrencies} from "./currenciesSlice";

const Currencies = () => {
  const dispatch = useAppDispatch();
  const currencies = useAppSelector(selectAllCurrencies);

  useEffect(() => {
    dispatch(fetchCurrencies());
  }, [dispatch]);

  return (
    <React.Fragment>
      <h1>Currencies</h1>
      <ul>
        {currencies.map((currency) => (
          <li key={currency.code}>
            <Link to={currency.code}>{currency.code}</Link>
          </li>
        ))}
      </ul>
    </React.Fragment>
  );
};

export default Currencies;
