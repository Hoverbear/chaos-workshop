---
description: >-
  Distributed systems naturally depend on networks. Let's learn some ways to
  create kinks in the network.
---

# Failing the Network \(\`ip\`\)

The `ip` tool lets you manage network links on your system. It also allows you to manipulate some settings related to the links.

Typically, your main Ethernet link is `eth0`, along with a loopback on `lo`. If it's not you can use `ip address` to discover which link is of interest to you. On machines with `docker` installed you'll also see a `docker0` link.

{% hint style="danger" %}
If you're shelled into a machine on a particular link \(like `eth0`\) you should **avoid taking it down.**
{% endhint %}

#### Changing the State of a Link

Turn it on:

```bash
ip link set docker0 up
```

Turn it off:

```bash
ip link set docker0 down
```

#### Determine the Link Used for an Address

```bash
ip route get 127.0.0.1
# local 127.0.0.1 dev lo src 127.0.0.1 uid 0 
#    cache <local> 
```

```bash
ip route get 8.8.8.8
# 8.8.8.8 via 138.197.128.1 dev eth0 src 138.197.129.130 uid 0 
#    cache
```

## Exercises

* Interrupt a network link where a client such as `psql` is running. \(Connect via the `lo` link`sudo -u postgres psql -h 127.0.0.1`\)
* Change the MTU size of a link with an active daemon connection to something ridicululous, simulating an strange error.



