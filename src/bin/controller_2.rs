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
    let mut pwm_pitch = pins.d10.into_output().into_pwm(&timer1);
    pwm_pitch.enable();
    let mut motor_pitch = Motor::new(pins.d8.into_output(), pins.d9.into_output());

    // Roll: PWM D11, DIR D13/D12
    let timer2 = Timer2Pwm::new(dp.TC2, Prescaler::Prescale64);
    let mut pwm_roll = pins.d11.into_output().into_pwm(&timer2);
    pwm_roll.enable();
    let mut motor_roll = Motor::new(pins.d13.into_output(), pins.d12.into_output());

    // State Variables
    let mut pitch_target: i16 = 0;
    let mut roll_target: i16 = 0;
    let mut buf = [0u8; 64];
    let mut index = 0;
    let mut motor_tick: u8 = 0;

    // loop {
    //     // 1. Read Serial (Non-blocking)
    //     while let Ok(byte) = serial.read() {
    //         if byte == b'\n' {
    //             let data = core::str::from_utf8(&buf[..index]).unwrap_or("");
    //             let mut parts = data.split(',');

    //             let p1 = parts.next(); // Altitude
    //             let p2 = parts.next(); // Pitch
    //             let p3 = parts.next(); // Roll

    //             if let (Some(alt), Some(p), Some(r)) = (p1, p2, p3) {
    //                 // Update LCD sparingly (it's slow!)
    //                 display.clear();
    //                 let _ = write!(
    //                     display,
    //                     "Alt:{}m\nP:{} R:{}",
    //                     alt.trim(),
    //                     p.trim(),
    //                     r.trim()
    //                 );

    //                 pitch_target = p.trim().parse().unwrap_or(pitch_target);
    //                 roll_target = r.trim().parse().unwrap_or(roll_target);
    //             }
    //             index = 0;
    //         } else if index < buf.len() {
    //             buf[index] = byte;
    //             index += 1;
    //         }
    //     }

    //     // 2. Drive Motors using Position Integration
    //     // We calculate the PWM duty cycle and update internal position
    //     motor_tick = motor_tick.wrapping_add(1);
    //     if motor_tick % 50 == 0 {
    //         let duty_p = motor_pitch.drive_position(pitch_target);
    //         pwm_pitch.set_duty(duty_p);

    //         let duty_r = motor_roll.drive_position(roll_target);
    //         pwm_roll.set_duty(duty_r);
    //     }

    //     // 3. Fixed Time Step (100Hz)
    //     // This makes the motor estimation 'self.position' realistic.
    //     // arduino_hal::delay_ms(10);
    // }
    //
    // Persistent state variables
    let mut altitude_current: i16 = 0;
    let mut pitch_target: i16 = 0;
    let mut roll_target: i16 = 0;
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

                if let (Some(alt), Some(p), Some(r)) = (p1, p2, p3) {
                    // Update LCD
                    display.clear();
                    let _ = write!(
                        display,
                        "Alt:{:>4}m\nP:{:>3} R:{:>3}   C2",
                        alt.trim(),
                        p.trim(),
                        r.trim()
                    );

                    // Update the targets for the motor system to chase
                    pitch_target = p.trim().parse().unwrap_or(pitch_target);
                    roll_target = r.trim().parse().unwrap_or(roll_target);
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
            let duty_p = motor_pitch.drive_position(pitch_target);
            pwm_pitch.set_duty(duty_p);

            let duty_r = motor_roll.drive_position(roll_target);
            pwm_roll.set_duty(duty_r);
        }
        // // At the end of the loop, send the state back to Python
        // let _ = uwriteln!(
        //     serial,
        //     "{},{},{}\n",
        //     altitude_current,
        //     pitch_target,
        //     roll_target
        // );
    }
}
