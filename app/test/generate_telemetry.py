from datetime import datetime, timedelta

import numpy as np
import polars as pl


def generate_telemetry_dt(rows=1000):
    start_time = datetime.now()
    indices = np.arange(rows)

    # Generate raw signals
    speed = 150 + 10 * np.sin(indices * 0.05)
    altitude = 1000 + (indices * 50 * np.sin(indices * 0.1))

    heading = np.rad2deg(3 * np.sin(indices * 0.1))
    yaw = np.rad2deg(2 * np.sin(indices * 0.02))
    roll = np.rad2deg(20 * np.cos(indices * 0.05))
    pitch = np.rad2deg(5 * np.sin(indices * 0.1))

    # Apply constraints
    speed = np.clip(speed, 0, 1000)
    altitude = np.clip(altitude, 0, 2000)

    heading = np.mod(heading, 360)
    yaw = np.mod(yaw, 360)
    roll = np.mod(roll, 360)
    pitch = np.mod(pitch, 360)

    df = pl.DataFrame(
        {
            "timestamp": [
                start_time + timedelta(milliseconds=50 * i) for i in range(rows)
            ],
            "speed": speed,
            "altitude": altitude,
            "heading": heading.astype(int),
            "yaw": yaw.astype(int),
            "roll": roll.astype(int),
            "pitch": pitch.astype(int),
        }
    )

    # Ensure timestamp type
    df = df.with_columns(pl.col("timestamp").cast(pl.Datetime))

    df.write_csv("data/telemetry.csv")
    print("Flight Telemetry CSV Generated.")


if __name__ == "__main__":
    generate_telemetry_dt()
