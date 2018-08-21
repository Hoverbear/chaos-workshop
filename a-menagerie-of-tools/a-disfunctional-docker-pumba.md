---
description: Learn to create failures in docker containers with Pumba.
---

# A Disfunctional Docker \(\`pumba\`\)

Pumba lets you take ideas from previous tools and apply them in a container setting. This is useful since it can be used as part of existing tooling in your infrastructure.

Start off by spinning up some Docker containers to represent a system:

```bash
git clone https://github.com/pingcap/tidb-docker-compose
cd tidb-docker-compose
docker-compose up -d
```

Then you can access system:

```bash
mycli -h 127.0.0.1 -P 4000 -u root
```

At this point, you can use Pumba to apply some 'tweaks' to the system.

#### Pause a Container

Here we pause 2/3rds of the storage containers in a PingCAP's distributed database:

```bash
pumba pause -d 15s tidbdockercompose_tikv0_1 tidbdockercompose_tikv1_1
```

Prior to running this command running `CREATE DATABASE example;` will succeed nearly immediately. Running the same during the 15s failure window will delay this write operation until the system recovers.

#### Kill a Container

Send the main process inside a container the KILL signal:

```text
pumba kill tidbdockercompose_tikv0_1
```

#### Network Emulation

{% hint style="info" %}
If your **image doesn't have `tc` installed**, you need to run `docker pull gaiadocker/iproute2` and use `netem --tc-image gaiadocker/iproute2` instead of just `netem`.
{% endhint %}

Introducing a delay to two of the storage nodes:

```bash
pumba netem --tc-image gaiadocker/iproute2 \
    --duration 15s \
    delay \
      --time 3000 \
      --jitter 40 \
      --distribution normal \
    tidbdockercompose_tikv0_1 tidbdockercompose_tikv1_1
```

Introducing 99% packet loss on all three storage nodes:

```text
pumba netem --tc-image gaiadocker/iproute2 \
    --duration 15s \
    loss \
      --percent 99 \
    tidbdockercompose_tikv0_1 tidbdockercompose_tikv1_1 tidbdockercompose_tikv2_1
```

## Exercises

* Try using the `--random` parameter to randomly select a node from passed set.
* Try using the regex syntax to target specific nodes.
* Compare a true distributed system \(like TiDB\) against a traditional system \(Postgres + Client\).





