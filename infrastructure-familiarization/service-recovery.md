---
description: 'How to have services recovery from failure, and detect that they have failed.'
---

# Service Resilience

We're using systemd on our test VMs, and you are most likely using it in your production systems. If you''re using something like `runit` or `sysvinit` you will need to go do your own research.

{% hint style="info" %}
Psst, if you do that research a PR to add it here would be greatly appreciated!
{% endhint %}

## Automatic Recovery

The [service documentation](https://www.freedesktop.org/software/systemd/man/systemd.service.html) of systemd shows all the options for services. We are particularly interested in `Restart` and `RestartSec` .

Here is a example from the Arch Linux `sshd` service file, which will always restart the service if it exits:

{% code-tabs %}
{% code-tabs-item title="/usr/lib/systemd/system/sshd.service" %}
```bash
[Service]
ExecStart=/usr/bin/sshd -D
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always
```
{% endcode-tabs-item %}
{% endcode-tabs %}

Which setting you choose is dependent on the component you are considering. If a rails web service is failing, you can probably just restart it. If your master database has failed you may not be so eager to blindly restart it.

You can see the options and how they behave on the table below:

| Restart settings/Exit causes | `no` | `always` | `on-success` | `on-failure` | `on-abnormal` | `on-abort` | `on-watchdog` |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Clean exit code or signal |   | X | X |   |   |   |   |
| Unclean exit code |   | X |   | X |   |   |   |
| Unclean signal |   | X |   | X | X | X |   |
| Timeout |   | X |   | X | X |   |   |
| Watchdog |   | X |   | X | X |   | X |

Using `RestartSecs` you can cause your system to wait a bit before restarting the service. This may be useful if you'd like to limit the frequency of restarts to prevent destabilization of the system. \(Your service may have some expensive startup cost and then fail afterwards, infinitely restarting only to fail\)

## Watchdogs

It's not always the case that a failed service will exit uncleanly. Sometimes it will hang otherwise silently. One way to detect this kind of failure is to use a watchdog system.

One common way to do this is to ping the socket the service is on regularly. The way systemd implements this is via the `sd_notify` call provided by `libsystemd`. 

**The upside?** This allows systems to have their own self-test logic. Meaning you can test more than just if the service is responding to pings.

**The downside?** Applications need to implement this logic.

By having `WatchdogSec` supported by a service you can have rich self-test logic. Here's an example Rust program and service file with watchdog support:

{% code-tabs %}
{% code-tabs-item title="examples/watchdogged/watchdogged.service" %}
```bash
[Unit]
Description=Watchdogged

[Service]
Type=notify
ExecStart=usr/bin/watchdogged
Restart=on-failure
TimeoutStartSec=1s
WatchdogSec=10s
StartLimitInterval=5min
StartLimitBurst=4
StartLimitAction=stop
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% code-tabs %}
{% code-tabs-item title="examples/watchdogged/src/main.rs" %}
```rust
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
```
{% endcode-tabs-item %}
{% endcode-tabs %}



