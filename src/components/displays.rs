use arduino_hal::port::{mode::Output, Pin, PinOps};
use arduino_hal::Delay;
use core::fmt;
use hd44780_driver::{bus::FourBitBus, Cursor, HD44780};

/// Display trait for different LCD implementations
pub trait Display {
    fn write_str(&mut self, s: &str) -> fmt::Result;
    fn clear(&mut self);
    fn set_cursor(&mut self, col: u8, row: u8);
}

pub struct LcdDisplay<RS, EN, D4, D5, D6, D7>
where
    RS: PinOps,
    EN: PinOps,
    D4: PinOps,
    D5: PinOps,
    D6: PinOps,
    D7: PinOps,
{
    lcd: HD44780<
        FourBitBus<
            Pin<Output, RS>,
            Pin<Output, EN>,
            Pin<Output, D4>,
            Pin<Output, D5>,
            Pin<Output, D6>,
            Pin<Output, D7>,
        >,
    >,
    delay: Delay,
}

impl<RS, EN, D4, D5, D6, D7> LcdDisplay<RS, EN, D4, D5, D6, D7>
where
    RS: PinOps,
    EN: PinOps,
    D4: PinOps,
    D5: PinOps,
    D6: PinOps,
    D7: PinOps,
{
    pub fn new(
        rs: Pin<Output, RS>,
        en: Pin<Output, EN>,
        d4: Pin<Output, D4>,
        d5: Pin<Output, D5>,
        d6: Pin<Output, D6>,
        d7: Pin<Output, D7>,
    ) -> Result<Self, hd44780_driver::error::Error> {
        let mut delay = Delay::new();
        let lcd = HD44780::new_4bit(rs, en, d4, d5, d6, d7, &mut delay)?;
        let mut display = Self { lcd, delay };

        let _ = display.lcd.reset(&mut display.delay);
        let _ = display.lcd.clear(&mut display.delay);
        let _ = display
            .lcd
            .set_cursor_visibility(Cursor::Invisible, &mut display.delay);
        Ok(display)
    }
}

// Implement our custom trait
impl<RS, EN, D4, D5, D6, D7> Display for LcdDisplay<RS, EN, D4, D5, D6, D7>
where
    RS: PinOps,
    EN: PinOps,
    D4: PinOps,
    D5: PinOps,
    D6: PinOps,
    D7: PinOps,
{
    fn write_str(&mut self, s: &str) -> fmt::Result {
        let mut lines = s.split('\n');
        if let Some(first) = lines.next() {
            let _ = self.lcd.write_str(first, &mut self.delay);
        }
        if let Some(second) = lines.next() {
            // Jump to second row (address 40)
            let _ = self.lcd.set_cursor_pos(40, &mut self.delay);
            let _ = self.lcd.write_str(second, &mut self.delay);
        }
        Ok(())
    }

    fn clear(&mut self) {
        let _ = self.lcd.clear(&mut self.delay);
    }

    fn set_cursor(&mut self, col: u8, row: u8) {
        let pos = if row == 0 { col } else { 40 + col };
        let _ = self.lcd.set_cursor_pos(pos, &mut self.delay);
    }
}

// Implement core::fmt::Write so write! macro works
impl<RS, EN, D4, D5, D6, D7> fmt::Write for LcdDisplay<RS, EN, D4, D5, D6, D7>
where
    RS: PinOps,
    EN: PinOps,
    D4: PinOps,
    D5: PinOps,
    D6: PinOps,
    D7: PinOps,
{
    fn write_str(&mut self, s: &str) -> fmt::Result {
        // Call the method from our Display trait
        Display::write_str(self, s)
    }
}

