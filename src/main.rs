//! A simple hello world application
//!
//! Uses some common app-logging crates to demonstrate
//! 1. how to use them in an application, and
//! 2. how to build and bundle them as an application.

use log::info;

fn main() {
    app_logging::init_logger();
    info!("Hello World!");
}

#[cfg(test)]
mod tests {
    #[test]
    fn tautology() {
        assert!(true)
    }

    #[test]
    #[ignore]
    fn contradiction() {
        assert!(true)
    }
}
