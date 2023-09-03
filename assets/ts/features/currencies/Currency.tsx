import React from "react";
import {useParams} from "react-router-dom";

const Currency = () => {
  const {code} = useParams();

  return (
    <React.Fragment>
      <h1>Currency {code}</h1>
    </React.Fragment>
  );
};

export default Currency;
