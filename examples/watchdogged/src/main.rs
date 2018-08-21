extern crate libsystemd;
extern crate gotham;
extern crate hyper;
extern crate mime;

use libsystemd::daemon::{self, NotifyState};
use hyper::{Response, StatusCode};

use gotham::{
    http::response::create_response,
    state::State,
};
use std::{
    thread,
};

fn main() {
    if !daemon::booted() {
        panic!("Not running systemd, early exit.");
    };
    if daemon::watchdog_enabled(false).is_none() {
        panic!("Not watchdogged.");
    }
    assert_eq!(true, daemon::notify(false, &[NotifyState::Ready]).unwrap());

    thread::spawn(|| while let Some(duration) = daemon::watchdog_enabled(false) {
        println!("Watchdog in {:?}, sleeping {:?}...", duration, duration / 2);
        thread::sleep(duration / 2);
        println!("Watchdog notified");
        assert_eq!(true, daemon::notify(false, &[NotifyState::Watchdog]).unwrap());
    });

    let addr = "127.0.0.1:7878";
    println!("Listening for requests at http://{}", addr);
    gotham::start(addr, || Ok(handle))
}

pub fn handle(state: State) -> (State, Response) {
    let res = create_response(
        &state,
        StatusCode::Ok,
        Some((String::from("Hello World!").into_bytes(), mime::TEXT_PLAIN)),
    );

    (state, res)
}
