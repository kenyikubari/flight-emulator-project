#![no_std]
#![no_main]

use panic_halt as _;

#[arduino_hal::entry]
fn main() -> ! {
    let dp = arduino_hal::Peripherals::take().unwrap();
    let pins = arduino_hal::pins!(dp);

  
    let mut led13 = pins.d13.into_output();
    let mut led12 = pins.d12.into_output();
    
    loop {
        led13.toggle();
        arduino_hal::delay_ms(1000);
        led12.toggle();
    }
}
