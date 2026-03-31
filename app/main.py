"""
main.py

Reads and streams flight telemetry data over serial to two controllers.
Also writes the latest telemetry values to a live CSV file for the dashboard.

Author: Kenyi Kubari
"""

import time
from datetime import datetime
from enum import StrEnum
from pathlib import Path

import polars as pl
import serial
import tomli


# --- Data variables ---
class FlightDataVariables(StrEnum):
    timestamp = "timestamp"
    speed = "speed"
    heading = "heading"
    yaw = "yaw"
    altitude = "altitude"
    pitch = "pitch"
    roll = "roll"


FDV = FlightDataVariables


# --- Configuration ---
# Load serial port settings from Ravedude.toml
RAVEDUDE_TOML = tomli.load(open("Ravedude.toml", "rb"))

PORT_C1 = RAVEDUDE_TOML["general"]["serial-port-01"]
PORT_C2 = RAVEDUDE_TOML["general"]["serial-port-02"]
BAUD_RATE = RAVEDUDE_TOML["general"]["serial-baudrate"]

# Input telemetry file and live output file
CSV_PATH = "data/telemetry.csv"
LIVE_PATH = "data/live.csv"


# --- Write latest data for dashboard ---
def write_live(row: dict) -> None:
    """
    Writes the current telemetry row to live.csv.

    This file is continuously overwritten so the dashboard
    can always read the most recent values.
    """
    Path(LIVE_PATH).parent.mkdir(exist_ok=True)

    live = pl.DataFrame(
        [
            {
                "timestamp": datetime.now().isoformat(),
                FDV.speed: float(row[FDV.speed]),
                FDV.heading: float(row[FDV.heading]),
                FDV.yaw: float(row[FDV.yaw]),
                FDV.altitude: float(row[FDV.altitude]),
                FDV.pitch: float(row[FDV.pitch]),
                FDV.roll: float(row[FDV.roll]),
            }
        ]
    )

    live.write_csv(LIVE_PATH)


# --- Send telemetry over serial ---
def stream_row(ser1: serial.Serial, ser2: serial.Serial, row: dict) -> None:
    """
    Sends one row of telemetry data to both controllers.

    Controller 1:
        speed, heading, yaw

    Controller 2:
        altitude, pitch, roll
    """
    packet1 = f"{row[FDV.speed]:.1f},{int(row[FDV.heading])},{int(row[FDV.yaw])}\n"
    packet2 = f"{row[FDV.altitude]:.0f},{int(row[FDV.pitch])},{int(row[FDV.roll])}\n"

    ser1.write(packet1.encode("utf-8"))
    ser2.write(packet2.encode("utf-8"))

    # Update dashboard file
    write_live(row)

    print(f"C1: {packet1.strip()} | C2: {packet2.strip()}")


# --- Main execution ---
def main() -> None:
    """
    Loads telemetry data and streams it row-by-row to both controllers.

    Also updates a live CSV file for the dashboard.
    """
    csv = Path(CSV_PATH)

    # Check telemetry file exists
    if not csv.exists():
        print(f"Error: {CSV_PATH} not found")
        return

    # Load telemetry dataset
    df = pl.read_csv(csv)

    # Open serial connections
    try:
        ser1 = serial.Serial(PORT_C1, BAUD_RATE, timeout=1)
        ser2 = serial.Serial(PORT_C2, BAUD_RATE, timeout=1)
        print(f"Connected to {PORT_C1} and {PORT_C2}")
    except serial.SerialException as e:
        print(f"Error opening serial ports: {e}")
        return

    # Give microcontrollers time to initialize
    time.sleep(2)

    print("Starting telemetry stream...")

    try:
        # Loop through dataset and stream each row
        for row in df.iter_rows(named=True):
            stream_row(ser1, ser2, row)
            time.sleep(1)

    finally:
        ser1.close()
        ser2.close()
        print("Stream finished.")


# --- Entry point ---
if __name__ == "__main__":
    main()
