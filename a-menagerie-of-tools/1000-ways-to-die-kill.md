---
description: >-
  Learn about the `kill` command and how you can use it to do some basic
  testing.
---

# 1000 Ways to Die \(\`kill\`\)

`kill`, and its sister `killall`, are likely familiar to you already. They are simple tools to send **signals** to a **process**. Most commonly they are used to end processes with the `TERM` signal.

#### Signals we care about:

* `TERM`: Cleanly exit a process, like a CTL+C.
* `HUP`: 'Hang up,' many services such as databases use this signal as a notice to restart without terminating. Eg, for a configuration change.
* `KILL`: Harshly exit a process, without allowing graceful shutdown.
* `STOP`: Pause a process, like a CTL+Z.
* `CONT`: Resume a process.

`kill` requires a PID \(such as from `ps`\), while `killall` supports process names.

**Terminating a process:**

```bash
killall apache
```

#### Sending a specific signal:

```bash
killall -s HUP postgres
```

#### Pausing a process for several seconds:

```bash
killall -s STOP tikv-server
sleep `shuf -i 1000-10000 -n 1`
killall -s CONT tikv-server
```



