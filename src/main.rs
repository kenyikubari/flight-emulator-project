
#![no_std]
#![no_main]
#![allow(unused)]

use panic_halt as _;
use arduino_hal::{
    port::{mode::Output, Pin, PinOps},
    simple_pwm::{IntoPwmPin, Prescaler, Timer1Pwm, Timer2Pwm},
};
use hd44780_driver::{
    HD44780,
    Cursor
};


// ── Types ──────────────────────────────────────────────────────────────────

/// Strongly-typed motor speed: -255..=255
#[derive(Clone, Copy)]
struct MotorSpeed(i16);

impl MotorSpeed {
    const ZERO: Self = Self(0);

    fn new(value: i16) -> Self {
        Self(value.clamp(-255, 255))
    }

    fn duty(self) -> u8 {
        self.0.unsigned_abs().min(255) as u8
    }

    fn direction(self) -> Direction {
        match self.0 {
            s if s > 0 => Direction::Forward,
            s if s < 0 => Direction::Reverse,
            _          => Direction::Brake,
        }
    }
}

#[derive(Clone, Copy, PartialEq)]
enum Direction { Forward, Reverse, Brake }

// ── Motor ──────────────────────────────────────────────────────────────────

struct Motor<P1, P2>
where
    P1: PinOps,
    P2: PinOps,
{
    ain1: Pin<Output, P1>,
    ain2: Pin<Output, P2>,
}

impl<P1: PinOps, P2: PinOps> Motor<P1, P2> {
    fn new(ain1: Pin<Output, P1>, ain2: Pin<Output, P2>) -> Self {
        Self { ain1, ain2 }
    }

    fn set_direction(&mut self, dir: Direction) {
        match dir {
            Direction::Forward => { self.ain1.set_high(); self.ain2.set_low(); }
            Direction::Reverse => { self.ain1.set_low();  self.ain2.set_high(); }
            Direction::Brake   => { self.ain1.set_low();  self.ain2.set_low(); }
        }
    }

    fn drive(&mut self, speed: MotorSpeed) -> u8 {
        self.set_direction(speed.direction());
        speed.duty()
    }
}

// ── Entry ──────────────────────────────────────────────────────────────────

#[arduino_hal::entry]
fn main() -> ! {
    let dp    = arduino_hal::Peripherals::take().unwrap();
    let pins  = arduino_hal::pins!(dp);

    // let timer1_pwm = Timer1Pwm::new(dp.TC1, Prescaler::Prescale64);  
    // let timer2_pwm = Timer2Pwm::new(dp.TC2, Prescaler::Prescale64);
   
    // let mut pwm_2 = pins.d11.into_output().into_pwm(&timer2_pwm);
    // pwm_2.enable();

 
    // let mut pwm_1 = pins.d10.into_output().into_pwm(&timer1_pwm);
    // pwm_1.enable();
    
    // let mut motor_1 = Motor::new(
    //     pins.d13.into_output(),
    //     pins.d12.into_output(),
    // );

    // let mut motor_2 = Motor::new(
    //     pins.d9.into_output(),
    //     pins.d8.into_output(),
    // );

    // let switch     = pins.d7.into_pull_up_input();
    // let full_speed = MotorSpeed::new(150);


    // // LCD pins (match Arduino wiring)
    // let rs = pins.d6.into_output();
    // let en = pins.d5.into_output();
    // let d4 = pins.d4.into_output();
    // let d5 = pins.d3.into_output();
    // let d6 = pins.d2.into_output();
    // let d7 = pins.d0.into_output();
    
    // LCD pins (match Arduino wiring)
    let rs = pins.d13.into_output();
    let en = pins.d12.into_output();
    let d4 = pins.d11.into_output();
    let d5 = pins.d10.into_output();
    let d6 = pins.d9.into_output();
    let d7 = pins.d8.into_output();

    // let mut delay = arduino_hal::Delay::new();
    // let mut lcd = HD44780::new_4bit(rs, en, d4, d5, d6, d7, &mut delay).unwrap();
    // lcd.reset(&mut delay);
    // lcd.clear(&mut delay);

    // let mut tick: u32 = 0;

    // loop {
    //     let speed = if switch.is_low() { full_speed } else { MotorSpeed::ZERO };
    //     pwm_1.set_duty(motor_1.drive(speed));
    //     pwm_2.set_duty(motor_2.drive(speed));
    //     arduino_hal::delay_ms(100);
    //     tick += 1;

    //     lcd.set_cursor_pos(0, &mut delay);
    //     lcd.write_str("Hello, world!", &mut delay);

    //     lcd.set_cursor_pos(40, &mut delay);

    //     let seconds = tick / 10;
    //     let mut buf = itoa::Buffer::new();
    //     let s = buf.format(seconds);
    //     lcd.write_str(s, &mut delay);
    // }

    let mut delay = arduino_hal::Delay::new();
    let mut lcd = HD44780::new_4bit(rs, en, d4, d5, d6, d7, &mut delay).unwrap();
    lcd.reset(&mut delay);
    lcd.clear(&mut delay);
    lcd.set_cursor_visibility(Cursor::Invisible, &mut delay);
    lcd.write_str("KENYI KUBARI", &mut delay);

    loop {
        arduino_hal::delay_ms(1000);
    }
 }
