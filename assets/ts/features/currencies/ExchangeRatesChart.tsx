import React, {useRef, useState, useEffect} from "react";
import debounce from "lodash/debounce";
import UplotReact from "uplot-react";
import uPlot from "uplot";

const ExchangeRatesChart = ({title, data}: {title: string; data: [number[], number[]]}) => {
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
            series: [
              {
                label: "Date",
                value: "{YYYY}-{MM}-{DD}",
              },
              {
                stroke: "red",
                fill: "rgba(255,0,0,0.1)",
                label: "Exchange rate (mid)",
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

export default ExchangeRatesChart;
