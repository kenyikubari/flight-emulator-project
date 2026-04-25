#import "../../utils/preamble.typ": *
#figure(
    table(
        columns: (0.5fr, 1fr, 2fr),
        stroke: none,
        align: (center, left, left),
        double-hline, double-hline, double-hline,
        [*QTY*], [*Component*], [*Specification*],
        hline, hline, hline,
        [2],[Microcontroller],  [Sparkfun RedBoard],
        [4],[DC Motor],  [DAGU Robot DG01D 48:1 GearBox],
        [2],[Motor Driver],  [Toshiba TB6612FNG],
        [2],[LCD Display],  [16x2 I2C],
        [2],[Potentiometer],  [--],
        [4],[Wheels],  [65mm Diameter],

        double-hline,
    ),
    caption: [Bill of Materials (BOM): Robot Components and Specifications],
) <tab:robot-bom>
