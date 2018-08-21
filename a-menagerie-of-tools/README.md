---
description: >-
  We'll explore a variety of tools, feel free to pick and choose which interest
  you.
---

# A Menagerie of Tools

In the following section we'll talk about a group of tools which can be used for Chaos testing. Some, such as `kill` may already be familiar to you. Others like `pumba` may be entirely new.

These tools only represent some of the tools available. You may find others, or even make your own.

## Triggering Events

While you can run many of these commands in a manual way, you can also orchestrate running these commands by using an agent installed on your nodes.

You could also use the ideas below for some simple testing.

### Timers

You could also use things such as systemd [timers](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) \(utilizing `RandomizedDelaySec`\) like so:

{% code-tabs %}
{% code-tabs-item title="/etc/systemd/system/kill-postgres.timer" %}
```bash
[Unit]
Description = Kill postgres eventually.

[Timer]
OnActiveSec = 0
RandomizedDelaySec = 1000
Unit = kill-postgres.service

[Install]
WantedBy = timers.target
```
{% endcode-tabs-item %}
{% endcode-tabs %}

{% code-tabs %}
{% code-tabs-item title="/etc/systemd/system/kill-postgres.service" %}
```bash
[Unit]
Description = Kill postgres.

[Service]
ExecStart = /usr/bin/killall -s KILL postgres
```
{% endcode-tabs-item %}
{% endcode-tabs %}

### Socket Activation

You can alternatively trigger failures via systemd's [socket](https://www.freedesktop.org/software/systemd/man/systemd.socket.html) activation feature:

{% code-tabs %}
{% code-tabs-item title="/etc/systemd/system/kill-postgres.socket" %}
```bash
[Unit]
Description = Kill postgres on message.

[Socket]
ListenStream = 127.0.0.1:8000

[Install]
WantedBy = sockets.target
```
{% endcode-tabs-item %}
{% endcode-tabs %}



