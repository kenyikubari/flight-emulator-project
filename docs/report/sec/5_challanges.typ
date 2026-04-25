== Challenge 1: Lack of Position Feedback

The biggest technical challenge was controlling the DC gear motors without any position feedback. DC gear motors are simple devices that rotate when powered, but they do not provide any information about their current angular position. As a result, when the system powered on, the gauge needles could start from arbitrary positions.

To address this, I attempted to implement proportional control using PWM signals, estimating position indirectly through motor speed and actuation time. However, this approach proved unreliable, as the system frequently overshot or undershot the target positions due to variations in load, friction, and supply voltage.

For future iterations, servo motors would be a more suitable solution for this application, as they provide built-in position feedback and precise control. However, due to the limitations of the development kit and budget constraints, DC motors were used.


== Challenge 2: Crowded Circuit

This project involved a complex circuit consisting of multiple motors, potentiometers, and a display. Initially, I planned to include a physical switch on the board, which would have required using digital pins `D1` to `D13`.

However, during development, I discovered that pins `D0` and `D1` are reserved for USB serial communication. To maintain reliable communication between the Arduino and the computer, these pins needed to remain unused.

As a result, I removed the switch from the design to free up sufficient I/O pins for the remaining components. This trade-off allowed the system to function correctly while staying within the hardware constraints.


== Challenge 3: Logging Data for Real-Time Dashboard

A key goal of this project was to implement a real-time digital dashboard to complement the analog gauges. In the system architecture, the computer generates simulated flight telemetry data and sends it to a central communication bus. This data is then distributed to two Arduino microcontrollers via USB serial.

Initially, I attempted to read the serial data directly from the bus for dashboard logging. However, I found that reading from the serial stream consumed the data, preventing other components from accessing it. Attempts to duplicate or re-read the data resulted in corruption.

To resolve this issue, I implemented a separate data logging pipeline. The telemetry data is written to a CSV file, which is then read exclusively by the dashboard. This approach ensured data integrity while allowing both the embedded system and the dashboard to operate reliably without interfering with each other.


