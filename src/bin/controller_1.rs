#![no_std]
#![no_main]
#![allow(unused_imports)]

use arduino_hal::prelude::*;
use arduino_hal::simple_pwm::{IntoPwmPin, Prescaler, Timer1Pwm, Timer2Pwm};
use core::fmt::Write;
use flight_emulator_project::components::displays::{Display, LcdDisplay};
use flight_emulator_project::components::motors::{Motor, MotorSpeed};
use panic_halt as _;
use ufmt::uwriteln;

#[arduino_hal::entry]
fn main() -> ! {
    let dp = arduino_hal::Peripherals::take().unwrap();
    let pins = arduino_hal::pins!(dp);

    //--- INITIALIZE SERIAL (57600 baud) ---//
    let mut serial = arduino_hal::default_serial!(dp, pins, 57600);

    //--- INITIALIZE DISPLAY ---//
    let mut display = LcdDisplay::new(
        pins.d7.into_output(),
        pins.d6.into_output(),
        pins.d5.into_output(),
        pins.d4.into_output(),
        pins.d3.into_output(),
        pins.d2.into_output(),
    )
    .expect("LCD Fail");

    //--- INITIALIZE MOTORS ---//
    // Pitch: PWM D10, DIR D8/D9
    let timer1 = Timer1Pwm::new(dp.TC1, Prescaler::Prescale64);
    let mut pwm_heading = pins.d10.into_output().into_pwm(&timer1);
    pwm_heading.enable();
    let mut motor_heading = Motor::new(pins.d8.into_output(), pins.d9.into_output());

    // Roll: PWM D11, DIR D13/D12
    let timer2 = Timer2Pwm::new(dp.TC2, Prescaler::Prescale64);
    let mut pwm_yaw = pins.d11.into_output().into_pwm(&timer2);
    pwm_yaw.enable();
    let mut motor_yaw = Motor::new(pins.d13.into_output(), pins.d12.into_output());

    // State Variables
    let mut index = 0;
    let mut motor_tick: u8 = 0;

    //
    // Persistent state variables
    let mut speed_current: i16 = 0;
    let mut heading_target: i16 = 0;
    let mut yaw_target: i16 = 0;
    let mut buf = [0u8; 64];
    let mut index = 0;

    // --- The Decoupler ---
    // This counter tracks how many times the fast loop has run
    let mut loop_counter: u32 = 0;

    loop {
        // ==========================================
        // 1. FAST SYSTEM: Read Serial (No delays!)
        // ==========================================
        while let Ok(byte) = serial.read() {
            if byte == b'\n' {
                let data = core::str::from_utf8(&buf[..index]).unwrap_or("");
                let mut parts = data.split(',');

                let p1 = parts.next();
                let p2 = parts.next();
                let p3 = parts.next();

                if let (Some(spd), Some(h), Some(y)) = (p1, p2, p3) {
                    // Update LCD
                    display.clear();
                    let _ = write!(
                        display,
                        "Spd:{} km/h \nH:{:>3} P:{:>3}   C1",
                        spd.trim(),
                        h.trim(),
                        y.trim()
                    );

                    // Update the targets for the motor system to chase
                    heading_target = h.trim().parse().unwrap_or(heading_target);
                    yaw_target = y.trim().parse().unwrap_or(yaw_target);
                }
                index = 0;
            } else if index < buf.len() {
                buf[index] = byte;
                index += 1;
            }
        }

        // ==========================================
        // 2. SLOW SYSTEM: Drive Motors
        // ==========================================
        loop_counter = loop_counter.wrapping_add(1);

        // MAGIC NUMBER: 1000
        // At 16MHz, the loop runs extremely fast. We only execute the motor math
        // every 1000th time through the loop. This simulates the 10ms delay
        // without actually freezing the CPU, allowing Serial to keep reading!
        if loop_counter % 1000 == 0 {
            let duty_h = motor_heading.drive_position(heading_target);
            pwm_heading.set_duty(duty_h);

            let duty_y = motor_yaw.drive_position(yaw_target);
            pwm_yaw.set_duty(duty_y);
        }
        // At the end of the loop, send the state back to Python
        // let _ = uwriteln!(serial, "{},{},{}", speed_current, heading_target, yaw_target);
    }
}
