#import "../../utils/preamble.typ": double-hline, hline

#figure(
  table(
    columns: 2,
    stroke: none,
    align: left,
    double-hline, double-hline,
    [*Instrument*], [*Purpose*],
    hline, hline,

    [Altimeter],
    [Displays altitude above mean sea level for terrain clearance and navigation],

    [Airspeed Indicator],
    [Indicates aircraft speed relative to the surrounding air to help prevent stalls and structural overstress],

    [Attitude Indicator],
    [Shows pitch and bank angle relative to the horizon for spatial orientation],

    [Heading Indicator],
    [Displays aircraft heading and assists with directional control],

    [Turn Coordinator],
    [Indicates rate of turn and whether the aircraft is in coordinated flight],

    [Vertical Speed Indicator],
    [Shows the rate of climb or descent],
    double-hline,
  ),
  caption: [The six primary flight instruments and their functions],
) <tab:primary-flight-instruments>