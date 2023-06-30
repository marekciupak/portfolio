import React, {useEffect} from "react";
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
          <li key={currency.code}>{currency.code}</li>
        ))}
      </ul>
    </React.Fragment>
  );
};

export default Currencies;
