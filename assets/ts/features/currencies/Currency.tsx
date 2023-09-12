import React, {useEffect} from "react";
import {useParams} from "react-router-dom";
import {useAppDispatch, useAppSelector} from "../../app/hooks";
import {fetchCurrency, selectLoadingStatusById, selectCurrencyById} from "./currenciesSlice";

const Currency = () => {
  const {code} = useParams();

  if (!code) throw new Error("Currency code is not defined.");

  const dispatch = useAppDispatch();
  const loadingStatus = useAppSelector((state) => selectLoadingStatusById(state, code));
  const _currency = useAppSelector((state) => selectCurrencyById(state, code));

  useEffect(() => {
    dispatch(fetchCurrency(code));
  }, [dispatch, code]);

  return (
    <React.Fragment>
      <h1>Currency {code}</h1>
      {loadingStatus === "loading" && <div>Loading...</div>}
    </React.Fragment>
  );
};

export default Currency;
