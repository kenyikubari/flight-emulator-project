= Media and Resources

This section provides supplementary media and resources related to the project, including the source code repository and demonstration videos.

*GitHub Repository:* \
The full codebase and supporting documentation for this project are available at the following repository: \
https://github.com/kenyikubari/flight-emulator-project

*Video Demonstrations:* \
The following videos showcase different aspects of the flight emulator system:

- *Instrument Cluster Demonstration:* \
  https://youtu.be/lIG7tXPKBvI?si=PpsRivrkwLYHKv8j

- *Serial Data Stream Demonstration:* \
  https://youtu.be/hduWfnMPjoY

- *Dashboard Visualization Demonstration:* \
  https://youtu.be/hO7zURT9W1o

#pagebreak()

= Documentation and Schematics <app:docs-and-schematics>

This Section contains the documentation and schematics for the project,
including the Arduino RedBoard V2.2 schematic, TB6612FNG motor driver
specification sheet, and the flight emulator circuit schematics. These resources
provide a overview of the hardware components.

#pagebreak()

#figure(
    block(
        width: 140%,
        height: 22cm,
        clip: false,
        rotate(
            90deg,
            image(
                "../rsc/files/RedBoard-V22_schematic.pdf",
                page: 1,
                width: 100%,
            ),
        ),
    ),
    caption: [Arduino RedBoard V2.2 schematic ],
) <fig:redboard-schematic>

#figure(
    block(
        width: 100%,
        height: 22cm,
        clip: false,
        image(
            "../rsc/files/TB6612FNG_motor_driver_specification_sheet.pdf",
            page: 1,
            width: 100%,
        ),
    ),
    caption: [TB6612FNG Motor Driver Spec Sheet @toshiba_tb6612fng_2007.],
) <fig:tb6612fng-motor-driver-specs>

#figure(
    block(
        width: 140%,
        height: 22cm,
        clip: false,
        rotate(
            90deg,
            image(
                "../rsc/files/flight_emulator_circuit_schematic.pdf",
                page: 1,
                width: 100%,
            ),
        ),
    ),
    caption: [Flight Emulator Circuit Schematic Page 1],
) <fig:flight-emulator-schematic-01>

#figure(
    block(
        width: 140%,
        height: 22cm,
        clip: false,
        rotate(
            90deg,
            image(
                "../rsc/files/flight_emulator_circuit_schematic.pdf",
                page: 2,
                width: 100%,
            ),
        ),
    ),
    caption: [Flight Emulator Circuit Schematic Page 2],
) <fig:flight-emulator-schematic-02>
