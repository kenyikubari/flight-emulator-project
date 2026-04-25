#import "/utils/preamble.typ": *

In practice, communication between the computer and the Arduinos proved to be
reliable, with no significant instances of data loss or corruption observed
during testing. Basic error handling was implemented on the Arduino side to
account for potential parsing issues, such as non-numeric input or incomplete
data packets. This included validating incoming float values and ensuring that
the expected number of data fields were received before updating the gauges.
Overall, the communication system was robust and sufficient for the requirements
of this project.

On the hardware side, the circuit was relatively robust and performed reliably
throughout testing. Gauge movements were smooth; however, they were primarily
qualitative, as the readings were not fully accurate due to the absence of
position feedback from the DC motors. In contrast, the digital displays provided
accurate representations of the flight parameters, and the system responded
consistently to changes in the input data. The overall setup is shown in
@fig:controller-overview, which illustrates the physical arrangement of
components and wiring from both top and front views.

#subpar.grid(
    figure(
        image("../rsc/figures/flight_emulator_controller_front.jpg"),
        caption: [
            Front view of the flight emulator controller.
        ],
    ),
    <fig:controller-front>,

    figure(
        image("../rsc/figures/flight_emulator_controller_top.jpg"),
        caption: [
            Top view of the flight emulator controller.
        ],
    ),
    <fig:controller-top>,

    columns: (1fr, 1fr),
    caption: [Flight emulator controller: (a) front view and (b) top view.],
    label: <fig:controller-overview>,
)



One limitation of the current system is that it is not yet optimized for
deployment or distribution. Setup requires several manual steps, including
configuring USB serial ports and ensuring synchronized communication between the
Arduinos and the Bus through terminal commands. Future improvements could focus
on automating this initialization process to improve usability and portability.

The dashboard visualization was tested, and the plotting and live updating
matched the digital display values. The `steamlit` library in Python proved to
be very convenient for creating a simple dashboard interface, and the live
updating of the plots @streamlit_docs.
