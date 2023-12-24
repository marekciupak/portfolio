import React, {useRef, useState, useEffect} from "react";
import debounce from "lodash/debounce";
import UplotReact from "uplot-react";
import uPlot from "uplot";

const AssetValuesChart = ({
  title,
  data,
  trade_currency_code,
}: {
  title: string;
  data: [number[], number[]];
  trade_currency_code: string;
}) => {
  const rootRef = useRef<HTMLDivElement>(null);
  const [width, setWidth] = useState<number | null>(null);

  useEffect(() => {
    const updateWidth = () => {
      setWidth(rootRef.current && rootRef.current.offsetWidth);
    };
    const handleResize = debounce(updateWidth, 150);

    updateWidth();
    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);

  return (
    <div ref={rootRef}>
      {width && (
        <UplotReact
          options={{
            title: title,
            width: width,
            height: 1200,
            tzDate: (ts) => uPlot.tzDate(new Date(ts * 1e3), "Etc/UTC"),
            axes: [
              {},
              {
                values: (_self, ticks) => ticks.map((rawValue) => `${rawValue} ${trade_currency_code}`),
                size: 75,
              },
            ],
            series: [
              {
                label: "Date",
                value: "{YYYY}-{MM}-{DD}",
              },
              {
                stroke: "red",
                fill: "rgba(255,0,0,0.1)",
                label: "Value (close)",
                value: (_self, rawValue) => rawValue && `${rawValue} ${trade_currency_code}`,
              },
            ],
          }}
          data={data}
          onCreate={(_chart) => {}}
          onDelete={(_chart) => {}}
        />
      )}
    </div>
  );
};

export default AssetValuesChart;
