#import "../../utils/preamble.typ": double-hline, hline

#figure(
    table(
        columns: (2fr, 1fr, 1fr, 1fr),
        stroke: none,
        align: (left, center, center, center),
        double-hline, double-hline, double-hline, double-hline,
        [*Criteria*], [*Python*], [*C/C++*], [*Rust*],
        hline, hline, hline, hline,

        [Ease of Learning], [3], [2], [1],

        [Arduino Support], [1], [3], [2],

        [Performance], [1], [3], [3],

        [Memory Efficiency], [1], [3], [3],

        [Hardware Control], [1], [3], [2],

        [Code Safety / Reliability], [2], [2], [3],

        [Library Availability], [2], [3], [1],

        double-hline,
    ),
    caption: [Decision matrix comparing Python, C/C++, and Rust for Arduinos],
) <tab:arduino-decision-matrix>
