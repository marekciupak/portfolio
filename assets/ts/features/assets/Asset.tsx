/*!
 * Copyright (C) 2023-2024 Marek Ciupak
 * SPDX-License-Identifier: AGPL-3.0-only
 */

import React, {useEffect} from "react";
import {useParams} from "react-router-dom";
import {useAppDispatch, useAppSelector} from "../../app/hooks";
import {fetchAsset, selectLoadingStatusById, selectAssetById} from "./assetsSlice";
import AssetValuesChart from "./AssetValuesChart";

const Asset = () => {
  const {symbol} = useParams();

  if (!symbol) throw new Error("Asset symbol is not defined.");

  const dispatch = useAppDispatch();
  const loadingStatus = useAppSelector((state) => selectLoadingStatusById(state, symbol));
  const asset = useAppSelector((state) => selectAssetById(state, symbol));

  useEffect(() => {
    dispatch(fetchAsset(symbol));
  }, [dispatch, symbol]);

  const renderDetails = () => {
    if (!asset) throw new Error("Missing asset.");
    if (!asset.values) throw new Error("Missing asset values.");

    return (
      <AssetValuesChart title={asset.symbol} data={asset.values} trade_currency_code={asset.trade_currency_code} />
    );
  };

  return (
    <React.Fragment>
      <h1>Asset {symbol}</h1>
      {loadingStatus === "loading" && <div>Loading...</div>}
      {loadingStatus === "succeeded" && renderDetails()}
    </React.Fragment>
  );
};

export default Asset;
