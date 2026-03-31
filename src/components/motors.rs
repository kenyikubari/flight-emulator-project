use arduino_hal::port::{mode::Output, Pin, PinOps};

/// A signed motor speed in the range `-255..=255`.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct MotorSpeed(i16);

impl MotorSpeed {
    pub const ZERO: Self = Self(0);

    #[inline]
    pub const fn new(value: i16) -> Self {
        Self(if value > 255 {
            255
        } else if value < -255 {
            -255
        } else {
            value
        })
    }

    #[inline]
    pub fn duty(self) -> u8 {
        self.0.unsigned_abs().min(255) as u8
    }

    #[inline]
    pub fn direction(self) -> Direction {
        match self.0 {
            s if s > 0 => Direction::Forward,
            s if s < 0 => Direction::Reverse,
            _ => Direction::Brake,
        }
    }
}

/// Motor rotation direction.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Direction {
    Forward,
    Reverse,
    Brake,
}

/// A motor driven via two H-bridge direction pins.
pub struct Motor<P1, P2>
where
    P1: PinOps,
    P2: PinOps,
{
    ain1: Pin<Output, P1>,
    ain2: Pin<Output, P2>,
    position: i16, // degrees (assumed)
}

impl<P1: PinOps, P2: PinOps> Motor<P1, P2> {
    /// Creates a new motor. Initial position is assumed to be 0°.
    pub fn new(ain1: Pin<Output, P1>, ain2: Pin<Output, P2>) -> Self {
        Self {
            ain1,
            ain2,
            position: 0,
        }
    }

    /// Returns current estimated position (degrees).
    pub fn position(&self) -> i16 {
        self.position
    }

    /// Sets motor direction via H-bridge pins.
    #[inline]
    pub fn set_direction(&mut self, dir: Direction) {
        match dir {
            Direction::Forward => {
                self.ain1.set_high();
                self.ain2.set_low();
            }
            Direction::Reverse => {
                self.ain1.set_low();
                self.ain2.set_high();
            }
            Direction::Brake => {
                self.ain1.set_low();
                self.ain2.set_low();
            }
        }
    }

    /// Drives the motor and returns the PWM duty cycle.
    #[inline]
    pub fn drive_speed(&mut self, speed: MotorSpeed) -> u8 {
        self.set_direction(speed.direction());
        speed.duty()
    }

    /// Moves motor toward a target position.
    pub fn drive_position(&mut self, target: i16) -> u8 {
        let error = target - self.position;
        let tolerance = 2;

        if error.abs() <= tolerance {
            self.set_direction(Direction::Brake);
            return 0;
        }

        // 1. Proportional Gain
        let k = 5; // Increased gain for faster response
        let mut speed_val = (error * k).clamp(-255, 255);

        // 2. Deadzone Compensation
        // Most small DC motors need at least 70/255 duty cycle to start spinning
        let min_voltage = 80;
        if speed_val.abs() < min_voltage && speed_val != 0 {
            speed_val = min_voltage * speed_val.signum();
        }

        // 3. Position Integration (The "Rough Estimate")
        // If this loop runs every 10ms:
        // At speed_val 255, we move roughly 5 degrees.
        // At speed_val 100, we move roughly 2 degrees.
        let delta_pos = speed_val / 30;
        if delta_pos == 0 && speed_val != 0 {
            self.position += speed_val.signum(); // Move by at least 1
        } else {
            self.position += delta_pos;
        }

        self.drive_speed(MotorSpeed::new(speed_val))
    }
}
