---
description: 'Learn to use Namazu, a fuzzy scheduler.'
---

# A Fuzzy Schedule \(\`nmz\`\)

Namazu is a fuzzy scheduler that mutates Ethernet packets, Filesystem events, and thread interleaving. As well as injected faults.

{% hint style="info" %}
Scheduling problems are often subtle and rare. Namazu works best with repeated testing.
{% endhint %}

Typically you'll work with it like a Docker container:

```text
nmz container run -it --rm ubuntu bash
```

Inside you can run, for example, async networking stack test suite:

```bash
apt update && apt install --yes build-essential git rustc cargo
git clone https://github.com/pingcap/tokio
cd tokio && cargo test --all
```

## Exercises

* Run your favorite projects test suite in Namazu.
* Explore the bugs discovered by Namazu that has recorded: [https://github.com/osrg/namazu/\#found-and-reproduced-bugs](https://github.com/osrg/namazu/#found-and-reproduced-bugs), try reproducing one.



