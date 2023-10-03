import React, {useEffect} from "react";
import {useParams} from "react-router-dom";
import {useAppDispatch, useAppSelector} from "../../app/hooks";
import {fetchCurrency, selectLoadingStatusById, selectCurrencyById} from "./currenciesSlice";
import ExchangeRatesChart from "./ExchangeRatesChart";

const Currency = () => {
  const {code} = useParams();

  if (!code) throw new Error("Currency code is not defined.");

  const dispatch = useAppDispatch();
  const loadingStatus = useAppSelector((state) => selectLoadingStatusById(state, code));
  const currency = useAppSelector((state) => selectCurrencyById(state, code));

  useEffect(() => {
    dispatch(fetchCurrency(code));
  }, [dispatch, code]);

  const renderDetails = () => {
    if (!currency) throw new Error("Missing currency.");

    return (currency.exchange_rates || []).map((exchange_rates) => (
      <ExchangeRatesChart
        key={exchange_rates.quote_code}
        title={`${currency.code} to ${exchange_rates.quote_code}`}
        data={exchange_rates.values}
      />
    ));
  };

  return (
    <React.Fragment>
      <h1>Currency {code}</h1>
      {loadingStatus === "loading" && <div>Loading...</div>}
      {loadingStatus === "succeeded" && renderDetails()}
    </React.Fragment>
  );
};

export default Currency;
