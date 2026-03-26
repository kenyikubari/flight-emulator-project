# Flight Emulator Project

| | |
|-|-|
|**Hardware**|2× SparkFun Inventor's Kit|
|**Core Theme**|Aerospace / Flight Simulation|
|**Key Deliverables**|Physical analog gauges, digital display, GUI dashboard|
|**Primary Skills**|Embedded systems, mechanical design, software GUI|


---
## Proposal

This project aims to design and build a functional flight emulator using two SparkFun Inventor's Kits. The emulator will recreate the essential instruments in an aircraft cockpit by combining physical analog gauges driven by gear motors, a digital readout display, and a software-based GUI dashboard.

---

## Background Information

Modern aircraft use a set of instruments to convey important flight data to the pilot. The six main flight instruments are:

- the altimeter
- airspeed indicator
- attitude indicator
- heading indicator
- turn coordinator
- vertical speed indicator

This project draws inspiration from these instruments by using gear motors to drive analog-style pointer gauges, mimicking the feel of real aircraft instruments.

---

## Project Components

### Main Components

The heart of the flight emulator includes four physical analog gauges and a digital display panel:

- **Yaw:** Shows left/right yaw (rotation around the vertical axis) with a gear motor moving a needle pointer along a printed arc scale.
- **Roll:** Indicates the bank angle of the aircraft (rotation around the longitudinal axis) to give a physical sense of wing tilt.
- **Pitch:** Displays nose-up or nose-down position (rotation around the lateral axis), reflecting whether the aircraft is climbing or descending.
- **Heading:** A compass-style gauge showing the aircraft's current magnetic heading in degrees (0–360°).

### Digital Display

A small digital display module will provide real-time numerical readouts for the two key flight parameters:

- **Airspeed**, displayed in kilometers per second (km/s), updated consistently from the simulation input.
- **Altitude**, shown in meters (m), representing the simulated aircraft's current height above sea level.

### Additional Component: GUI Dashboard

A graphical user interface (GUI) on a connected laptop will act as the control panel for the emulator. The dashboard will communicate with the Arduino through a USB serial connection and offer these features:

- Real-time display of all six flight parameters: yaw, roll, pitch, heading, airspeed, and altitude.
- Live-updating graphs that track each parameter over time, helping the user visualize flight path trends.
- A flight data logger that saves all values with timestamps to a local CSV or log file for review after each session.

### Optional Features

If time and resources permit, the following improvements may be added:

- Audible alerts that sound when parameters exceed realistic limits using the kit's piezo buzzer.
- A joystick input panel that lets the user physically "fly" the emulator and view live responses on the gauges.

---

## Potential Issues & Mitigation Strategies

### 1. Gauge Zeroing and Motor Position

The main challenge is that DC gear motors do not have built-in position feedback. Unlike servo motors, they cannot be set to a specific angle; they only turn in one direction at a specific speed. As a result, the gauges will not know the needle's starting position when the system powers on.

**Proposed mitigations:**

- At startup, a homing routine will run each motor in the minimum direction for a set time, pushing the needle against a mechanical end-stop to establish a known zero position.
- If necessary, gauges can be manually zeroed.

### 2. Motor Speed and Gauge Resolution

Gear motors might move too quickly or slowly for smooth and realistic needle motion. Accurate control of speed will be necessary to ensure the needle moves naturally rather than snapping between positions.

**Proposed mitigations:**

- PWM (pulse-width modulation) will regulate motor speed, enabling slow and smooth transitions between positions.
- Interpolation logic in the code will gradually guide the needle toward its target value instead of jumping immediately.