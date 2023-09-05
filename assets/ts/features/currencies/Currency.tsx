import React, {useEffect} from "react";
import {useParams} from "react-router-dom";
import {useAppDispatch} from "../../app/hooks";
import {fetchCurrency} from "./currenciesSlice";

const Currency = () => {
  const {code} = useParams();

  if (!code) throw new Error("Currency code is not defined.");

  const dispatch = useAppDispatch();

  useEffect(() => {
    dispatch(fetchCurrency(code));
  }, [dispatch, code]);

  return (
    <React.Fragment>
      <h1>Currency {code}</h1>
    </React.Fragment>
  );
};

export default Currency;
