---
description: 'While the network is just a series of tubes, these tubes are unreliable.'
---

# Controlling Traffic \(\`tc\`\)

While the `ip` tool gave us a way to fiddle with network links, it didn't really give us any good abilities to fiddle with the network.

`tc` fixes that by allowing you to tinker to your hearts content with the quality and characteristics of a link. You can do things like subtly corrupt, delay, reorder, or outright drop packets.

{% hint style="danger" %}
Be very careful using `tc` commands on a link you're SSH'd over. **You could lock yourself out!**
{% endhint %}

#### Causing a Delay on a Link:

```bash
tc qdisc add dev lo root netem delay 200ms
# qdisc: Queuing discipline
# dev: Device
# root: Modify egress
# netem: Network emulation
```

#### Show Rules on a Link:

```bash
tc qdisc show dev lo
```

Try it on a link with no settings, you can see the default Kernel settings!

#### Delete Rule on a Link

```bash
tc qdisc del dev lo root
```

#### Introduce Loss on a Link:

```text
tc qdisc add dev lo root netem loss 10%
```

{% hint style="warning" %}
Try to avoid going over 15% packet loss, TCP starts to seriously degrade at that point.
{% endhint %}

#### Twins! Duplicate on a Link:

```bash
tc qdisc change dev lo root netem duplicate 1%
```

#### Packets can also be corrupted:

```bash
tc qdisc change dev lo root netem corrupt 5%
```

_Note that TCP has a checksum built in, and corruptions commonly cause a retransmit. Most user level applications do not see this._

## Exercises

* See how much packet loss you can introduce before a connection between a database and a REPL \(eg `psql`\) starts failing.
* If you introduce, say 2%, corruption to a web server, does it still work? Are the pages reliably what they should be? Why? \(Hint: Checksums\)

