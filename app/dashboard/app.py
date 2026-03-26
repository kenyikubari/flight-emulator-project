import time
from datetime import datetime
from pathlib import Path

import polars as pl
import streamlit as st

st.set_page_config(page_title="Flight Dashboard", layout="wide")
st.title("✈️ Flight Telemetry Dashboard")

col1, col2, col3 = st.columns(3)
speed_box = col1.empty()
alt_box = col2.empty()
heading_box = col3.empty()

chart_speed = st.empty()
chart_alt = st.empty()
chart_heading = st.empty()

BASE_DIR = Path(__file__).resolve().parents[2]
csv_file = BASE_DIR / "data" / "telemetry.csv"

# Initialize empty chart data with schema
if "chart_data" not in st.session_state:
    st.session_state.chart_data = pl.DataFrame(
        {
            "timestamp": [],
            "speed": [],
            "altitude": [],
            "heading": [],
        },
        schema={
            "timestamp": pl.Datetime,
            "speed": pl.Int64,
            "altitude": pl.Int64,
            "heading": pl.Int64,
        },
    )

row = 0
while True:
    try:
        # Read CSV and parse timestamp
        df = pl.read_csv(csv_file)
        if "timestamp" in df.columns:
            df = df.with_columns(
                pl.col("timestamp").str.strptime(
                    pl.Datetime, format="%Y-%m-%d %H:%M:%S"
                )
            )
        if df.is_empty():
            raise ValueError("CSV empty")

        # Get the row as a dict and convert types
        data_row = df.row(row, named=True)
        data = {
            "timestamp": data_row["timestamp"],
            "speed": int(data_row["speed"]),
            "altitude": int(data_row["altitude"]),
            "heading": int(data_row["heading"]),
        }
    except Exception as e:
        # Use current datetime as fallback
        data = {
            "timestamp": datetime.now(),
            "speed": 0,
            "altitude": 0,
            "heading": 0,
        }

    speed_box.metric("Speed", f"{data['speed']} m/s")
    alt_box.metric("Altitude", f"{data['altitude']} m")
    heading_box.metric("Heading", f"{data['heading']}°")

    # Create new row dataframe with explicit schema
    new_row = pl.DataFrame(
        [data],
        schema={
            "timestamp": pl.Datetime,
            "speed": pl.Int64,
            "altitude": pl.Int64,
            "heading": pl.Int64,
        },
    )

    # Append to session state
    st.session_state.chart_data = pl.concat(
        [st.session_state.chart_data, new_row], how="vertical"
    )

    # Display charts if data exists
    if not st.session_state.chart_data.is_empty():
        chart_speed.line_chart(
            st.session_state.chart_data.select(["timestamp", "speed"]).to_pandas(),
            x="timestamp",
            y="speed",
            width=700,
        )
        chart_alt.line_chart(
            st.session_state.chart_data.select(["timestamp", "altitude"]).to_pandas(),
            x="timestamp",
            y="altitude",
            width=700,
        )
        chart_heading.line_chart(
            st.session_state.chart_data.select(["timestamp", "heading"]).to_pandas(),
            x="timestamp",
            y="heading",
            width=700,
        )

    row += 1
    time.sleep(0.5)
