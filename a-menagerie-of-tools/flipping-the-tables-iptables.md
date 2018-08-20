---
description: 'Walls of fire are quite chaotic, aren''t they?'
---

# Isolating and Parititioning \(\`iptables\`\)

You can use `iptables` to simulate things like network partitions or isolation. It works great along with `tc` for creating hazardous network situations.

You can also use iptables to do some simulations of link related failure, for example, to drop 10% of all incoming packets.  You can use whichever you prefer.

{% hint style="danger" %}
Be careful, you could accidentally lock yourself out if you're over SSH!
{% endhint %}

`iptables` works on the concept of "chains". As a packet travels through your system it will be processed by these chains in a given order. The [Arch Linux guide on IP tables](https://wiki.archlinux.org/index.php/iptables#Basic_concepts) has a great diagram:

```text
                               XXXXXXXXXXXXXXXXXX
                             XXX     Network    XXX
                               XXXXXXXXXXXXXXXXXX
                                       +
                                       |
                                       v
 +-------------+              +------------------+
 |table: filter| <---+        | table: nat       |
 |chain: INPUT |     |        | chain: PREROUTING|
 +-----+-------+     |        +--------+---------+
       |             |                 |
       v             |                 v
 [local process]     |           ****************          +--------------+
       |             +---------+ Routing decision +------> |table: filter |
       v                         ****************          |chain: FORWARD|
****************                                           +------+-------+
Routing decision                                                  |
****************                                                  |
       |                                                          |
       v                        ****************                  |
+-------------+       +------>  Routing decision  <---------------+
|table: nat   |       |         ****************
|chain: OUTPUT|       |               +
+-----+-------+       |               |
      |               |               v
      v               |      +-------------------+
+--------------+      |      | table: nat        |
|table: filter | +----+      | chain: POSTROUTING|
|chain: OUTPUT |             +--------+----------+
+--------------+                      |
                                      v
                               XXXXXXXXXXXXXXXXXX
                             XXX    Network     XXX
                               XXXXXXXXXXXXXXXXXX

```

#### Prevent Ingress by IP/Port:

```bash
iptables -A INPUT -s 8.8.8.8 -p tcp --dport 25 -j DROP
```

You can remove the `-s 8.8.8.8` or `-dport 25` to have the rule apply more generally.

#### Allow It Again:

```bash
iptables -D INPUT -s 8.8.8.8 -p tcp --dport 25 -j DROP
```

#### Prevent Egress by IP/Port:

```bash
iptables -A OUTPUT -p tcp -d 8.8.8.8 --dport 25 -j DROP
```

#### Drop 10% of Ingress Packets

```text
iptables -A INPUT -m statistic --mode random --probability 0.1 -j DROP
```

{% hint style="warning" %}
Try to avoid going over 15% packet loss, TCP starts to seriously degrade at that point.
{% endhint %}

#### List All Chains and Rules

```bash
iptables --list
```

## Exercises

* Check the DNS provider of `eth0`\(with `systemd-resolve --status`\) Try preventing outgoing DNS requests \(UDP port 25\), does `nslookup` work with Github.com? What about if you only block one of the DNS servers?
* Isolate a client \(such as `psql`\) from communicating with a server. Too easy? Try isolating a master from a replica.
* Use `tc` and `iptables` both to introduce packet loss, which is easier?



