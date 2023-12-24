import React, {useEffect} from "react";
import {Link} from "react-router-dom";
import {useAppDispatch, useAppSelector} from "../../app/hooks";
import {fetchAssets, selectAllAssets} from "./assetsSlice";

const Assets = () => {
  const dispatch = useAppDispatch();
  const assets = useAppSelector(selectAllAssets);

  useEffect(() => {
    dispatch(fetchAssets());
  }, [dispatch]);

  return (
    <React.Fragment>
      <h1>Assets</h1>
      <ul>
        {assets.map((asset) => (
          <li key={asset.symbol}>
            <Link to={asset.symbol}>{asset.symbol}</Link>
          </li>
        ))}
      </ul>
    </React.Fragment>
  );
};

export default Assets;
