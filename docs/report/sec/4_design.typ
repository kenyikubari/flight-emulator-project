== Hardware Architecture

The hardware for this project consists of components from two SparkFun
Inventor's Kits. The specific components used are outlined in the Bill of
Materials in @tab:robot-bom.

#include "../rsc/tables/hardware_BOM.typ"

Two Arduinos were used because the project required a large number of components
and sensors, exceeding the pin availability of a single board. By using two
Arduinos in a parallel (stereo) configuration, responsibilities for displaying
flight data were distributed between the boards with minimal overhead and coding
complexity.

In this architecture, the computer program running on the PC processes and sends
the required flight data to each Arduino. This allows each microcontroller to
focus solely on displaying its assigned flight parameters, simplifying the
embedded logic.

#figure(
    image("../rsc/figures/tinker_cad_circuit_diagram.png", width: 100%),
    caption: [Hardware Setup: Two Arduino Unos in Parallel Configuration],
) <fig:arduino-setup>

@fig:arduino-setup shows the wiring diagram for the two Arduinos. The left
Arduino, `controller_1`, is responsible for displaying heading and yaw on the
analog gauges, as well as flight speed on the digital display. The right
Arduino, `controller_2`, handles roll and pitch on the analog gauges and
altitude on the display.

Both Arduinos receive data from the computer via USB serial communication. A
more detailed wiring diagram is included in the Appendix
(@fig:flight-emulator-schematic-01 and @fig:flight-emulator-schematic-02).

== Software Architecture

The software architecture consists of two main layers: the Computer Layer, which
handles data processing and dashboard visualization, and the Microcontroller
Layer, which manages the real-time display of flight parameters on the gauges
and digital displays.

#figure(
    image("/rsc/figures/project_control_flow.png", width: 100%),
    caption: [Software Architecture: Data Flow and Component Interaction],
) <fig:software-architecture>

@fig:software-architecture illustrates the control flow of the software
components. In the Computer Layer, flight telemetry data is stored in the form
of a CSV file, which is read and processed by the Bus. The Bus then parses this
data into two separate serial streams, one for each Arduino. It also manages the
data stream for the Dashboard by writing the processed flight data to a
temporary CSV file that the dashboard can read.

The Microcontroller Layer consists of two Arduinos, each running a program that
listens for incoming serial data from the computer. Upon receiving data, the
Arduinos update the corresponding gauges and digital displays in real time to
reflect the current flight parameters.

This layered architecture enables efficient data handling and a clear separation
of responsibilities between the computer and microcontroller components. It also
provides flexibility, allowing modules or components to be swapped or extended
without requiring a complete rewrite of the codebase. In future iterations,
additional functionality could be incorporated, such as a speaker for audio
alerts when certain flight limits are reached, or a Bluetooth module to decouple
the computer from the microcontrollers and enable a more portable system.


== Software Design Considerations
As mentioned in _The Robotics Primer_ by Maja J. Matarić, every Turing-complete programming language can be used to solve any computational problem; however, some languages are better suited for certain tasks than others @mataric2017robotics_primer. For this project, the main software design considerations were safety, performance, scalability, and correctness. For simplicity, I chose to focus on the three languages that offer the strongest support for Arduino development: Python, C/C++, and Rust. The decision matrix in @tab:arduino-decision-matrix compares these languages across the key criteria relevant to this project, using a rating scale of 1 (least suitable) to 3 (most suitable).

#pagebreak()

#include "/rsc/tables/language_selection_matrix.typ"

After evaluating the three languages based on these criteria, C/C++ emerged as the best overall choice according to the matrix @arduino_documentation. However, given that Rust ranked a close second and offers significant advantages in terms of memory safety, bug prevention, and modern tooling, as well due to my personal interest in learning it, I chose Rust for the microcontroller programming @naxaes_rust_arduino. For the computer layer, I selected Python because of its ease of use and extensive ecosystem for data processing and visualization. This combination allows me to leverage the strengths of both languages while still meeting the project requirements.

== Testing and Validation

Hardware testing was conducted in stages, starting with individual components and then integrating them into the full system. Each Arduino was tested separately to ensure that the gauges and displays responded correctly to simulated input data. Once both Arduinos were verified, they were connected to the computer, and end-to-end testing was performed to confirm that the entire data flow, from the computer to the microcontrollers, functioned as intended.

Initially the use of formal unit testing frameworks where planned for both the Rust and Python codebases. However, due to time constraints and the complexity of setting up testing for embedded systems, I opted for a more manual testing approach. This involved writing test scripts to simulate flight data and observing the behavior of the gauges and dashboard in real time. While this method is less rigorous than formal unit testing, it allowed me to validate the core functionality of the system within the project timeline.

