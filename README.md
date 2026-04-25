# Flight Emulator Instrumentation System

A real-time flight instrumentation system that integrates motorized analog gauges, digital displays, and a live software dashboard to simulate aircraft flight parameters.

## Overview

This project recreates a simplified aircraft instrument cluster using Arduino-based embedded systems, DC motor-driven gauges, LCD displays, and a Python-based dashboard. The objective is to combine mechanical systems, embedded programming, and software visualization into a unified platform.

![Project Circuit Layout](assets\images\tinker_cad_circuit_diagram.png)

## System Architecture

The system is divided into two primary layers:

### Computer Layer

- Reads flight telemetry data from a CSV file
- Processes and distributes data through a central "Bus"
- Sends data to:
  - Microcontrollers via serial communication
  - Dashboard via a temporary CSV file

### Microcontroller Layer

- Two Arduino boards operating in parallel
- Each board:
  - Controls analog gauges using DC motors
  - Updates digital LCD displays
- Receives real-time data from the computer via USB serial

## Features

- Real-time simulation of flight parameters:
  - Heading
  - Yaw
  - Roll
  - Pitch
- Motorized analog gauges
- Digital LCD readouts
- Live dashboard visualization
- Serial communication pipeline
- Modular system design

## Hardware Components

|                      |                                                        |
| -------------------- | ------------------------------------------------------ |
| **Hardware**         | 2× SparkFun Inventor's Kit                             |
| **Core Theme**       | Aerospace / Flight Simulation                          |
| **Key Deliverables** | Physical analog gauges, digital display, GUI dashboard |
| **Primary Skills**   | Embedded systems, mechanical design, software GUI      |

## Software Stack

### Microcontroller

- Rust (rust-arduino)
- PWM-based motor control
- Serial data parsing

### Computer

- Python
- Streamlit dashboard
- CSV-based data pipeline

## Control Strategy

- Open-loop control for motor actuation
- Homing at startup to establish reference positions

## Dashboard

The dashboard provides:

- Real-time plots of flight data
- Numerical display of parameters
- Continuous updates from telemetry input

Built using Streamlit and Python-based data processing tools.

## Testing

Testing was conducted in stages:

- Component-level testing of motors and displays
- Integration testing between microcontrollers and computer
- End-to-end validation using simulated flight data

## Limitations

- No position feedback from DC motors (open-loop system)
- Analog gauge readings are qualitative rather than precise
- Manual configuration required for serial communication
- System is not optimized for deployment or portability

## Future Improvements

- Integrate position feedback using encoders or servo motors
- Implement closed-loop control
- Add wireless communication (e.g., Bluetooth)
- Automate system initialization
- Improve mechanical design of gauge system
- Expand dashboard functionality

## Demonstrations

- Instrument Cluster: https://youtu.be/lIG7tXPKBvI
- Serial Data Stream: https://youtu.be/hduWfnMPjoY
- Dashboard: https://youtu.be/hO7zURT9W1o

## Author

Kenyi Kubari  
BSc Mechanical Engineering  
https://www.linkedin.com/in/kenyikubari/
