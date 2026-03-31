"""
app.py

Code for web dashboard for flight emulator plotting the speed, altitude, yaw, pitch, roll data for a flight regime. Dashboard created using streamlit framework.

Author: Kenyi Kubari
"""

import time
from datetime import datetime
from pathlib import Path

import polars as pl
import streamlit as st


# --- Page setup ---
st.set_page_config(
    page_title="Flight Telemetry",
    layout="wide",
)

st.title("Flight Telemetry Dashboard")


# --- Data schema ---
SCHEMA = {
    "timestamp": pl.Datetime,
    "speed": pl.Float64,
    "heading": pl.Float64,
    "yaw": pl.Float64,
    "altitude": pl.Float64,
    "pitch": pl.Float64,
    "roll": pl.Float64,
}


# --- State init ---
if "data" not in st.session_state:
    st.session_state.data = pl.DataFrame(schema=SCHEMA)

if "current" not in st.session_state:
    st.session_state.current = {
        "speed": 0.0,
        "heading": 0.0,
        "yaw": 0.0,
        "altitude": 0.0,
        "pitch": 0.0,
        "roll": 0.0,
    }

if "previous" not in st.session_state:
    st.session_state.previous = st.session_state.current.copy()


# --- Sidebar ---
with st.sidebar:
    st.header("Controls")

    run = st.checkbox("Start stream", value=False)
    max_points = st.slider("History length", 20, 200, 50)

    if st.button("Clear"):
        st.session_state.data = pl.DataFrame(schema=SCHEMA)


# --- Layout ---
col1, col2, col3 = st.columns(3)
speed_box = col1.empty()
heading_box = col2.empty()
yaw_box = col3.empty()

col4, col5, col6 = st.columns(3)
alt_box = col4.empty()
pitch_box = col5.empty()
roll_box = col6.empty()

chart_area = st.container()


# --- CSV reader ---
def get_latest_row(path):
    try:
        df = pl.read_csv(path)
        if df.height == 0:
            return None
        return df.row(-1, named=True)
    except Exception:
        return None


# --- UI updates ---
def update_metrics():
    c = st.session_state.current
    p = st.session_state.previous

    speed_box.metric("Speed", f"{c['speed']:.1f}", f"{c['speed'] - p['speed']:+.1f}")
    heading_box.metric("Heading", f"{c['heading']:.0f}", f"{c['heading'] - p['heading']:+.0f}")
    yaw_box.metric("Yaw", f"{c['yaw']:.0f}", f"{c['yaw'] - p['yaw']:+.0f}")

    alt_box.metric("Altitude", f"{c['altitude']:.0f}", f"{c['altitude'] - p['altitude']:+.0f}")
    pitch_box.metric("Pitch", f"{c['pitch']:.0f}", f"{c['pitch'] - p['pitch']:+.0f}")
    roll_box.metric("Roll", f"{c['roll']:.0f}", f"{c['roll'] - p['roll']:+.0f}")


def update_charts():
    df = st.session_state.data
    if df.is_empty():
        return

    pdf = df.to_pandas()

    c1, c2 = chart_area.columns(2)
    c1.line_chart(pdf, x="timestamp", y=["speed", "altitude"])
    c2.line_chart(pdf, x="timestamp", y=["pitch", "roll", "yaw"])


# --- File path ---
CSV_PATH = Path("data/live.csv")

st.caption(f"File: {CSV_PATH.resolve()}")
st.caption(f"Exists: {CSV_PATH.exists()}")


# --- Initial render ---
update_metrics()
update_charts()


# --- Live loop ---
if run:
    row = get_latest_row(CSV_PATH)

    if row:
        st.session_state.previous = st.session_state.current.copy()

        for key in st.session_state.current:
            st.session_state.current[key] = float(row.get(key, 0.0))

        new_point = pl.DataFrame(
            [{"timestamp": datetime.now(), **st.session_state.current}],
            schema=SCHEMA,
        )

        st.session_state.data = pl.concat(
            [st.session_state.data, new_point]
        ).tail(max_points)

    else:
        st.warning("No data yet...")

    time.sleep(1)
    st.rerun()