This section outlines a high-level overview of the methods used in this project,
including the hardware and software design choices and control system
architecture.

== Control System Architecture

This project implements a control architecture that considers both open-loop and
closed-loop control. Understanding both control strategies is important for
evaluating the design decisions and trade-offs made throughout the system.

=== Open-Loop vs. Closed-Loop Control

Control systems are typically classified based on whether feedback is used to
adjust system behavior. In this project, control at the microcontroller level is
primarily open-loop, with calibration handled at the system level.

*Open-loop control:* Control actions are applied without measuring the resulting
output. For example, when the computer sends a PWM signal to drive a motor to a
target position, the Arduino applies the signal without verifying the actual
position achieved.

*Closed-loop control:* The system continuously measures output, compares it to a
desired setpoint, and adjusts the control input accordingly. A common example is
a thermostat, which regulates temperature by adjusting heating based on
feedback. Closed-loop control improves accuracy and robustness but requires
additional sensors and processing.

=== Servo Motors vs. DC Motors: Design Trade-offs

Motor selection plays a significant role in determining the overall control
strategy. This project considers both DC gear motors and servo motors.

*DC gear motors:* DC gear motors are simple electromechanical devices that
rotate when voltage is applied. They require an external driver to control
direction and speed, with speed regulated through Pulse Width Modulation (PWM).
The motors used in this project, DAGU Robot DG01D motors with a 48:1 gearbox
they provide sufficient torque for driving gauge needles. However, they do not
provide position feedback.

*Servo motors:* Servo motors integrate a DC motor, gearbox, position sensor, and
control electronics into a single unit. Position is controlled using a PWM
signal with pulse widths corresponding to specific angles. Internal feedback
allows the servo to maintain its commanded position, making it a closed-loop
device.

== Motor Control Methodologies

=== Pulse Width Modulation

Pulse Width Modulation (PWM) is used to control motor speed by varying the
effective voltage supplied to the motor. A PWM signal alternates between 0 V and
5 V at a fixed frequency. On the Arduino Uno, PWM outputs operate at
approximately 490 Hz with 8-bit resolution from 0 to 255.

The duty cycle, defined as the ratio of the signal's on-time to its total
period, determines the effective voltage. For example, a 50% duty cycle
corresponds to approximately half the supply voltage.

For DC motors, the duty cycle directly controls rotational speed. In contrast,
servo motors interpret pulse width rather than duty cycle, requiring a different
signal structure generated through a dedicated library or custom timing.

=== Speed Ramping and Smooth Acceleration

To improve the visual and mechanical response of the system, motor speed is not
changed instantaneously. Instead, speed is increased gradually using a linear
ramp:


$
    "current_speed" = "current_speed" + "acceleration_increment"
$


This approach reduces abrupt motion and produces smoother transitions that
better reflect real mechanical systems. Acceleration rates are tuned
experimentally to account for differences in load, friction, and supply
conditions.

== Communication Protocols

Communication between the computer and the microcontrollers is implemented using
USB serial at 9600 baud. This method is simple, reliable, and sufficient for the
relatively low data rates required by the system.
