#!/usr/bin/env nu

$env.RAVEDUDE_PORT = "/dev/ttyUSB1"
cargo run --bin controller-1

$env.RAVEDUDE_PORT = "/dev/ttyUSB0"
cargo run --bin controller-2

python app/main.py
streamlit run app/dashboard/app.py