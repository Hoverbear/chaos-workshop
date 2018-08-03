---
description: What kinds of failures can happen in a distributed system?
---

# Kinds of Failure

Computers in general are known to fail in spectacular and interesting ways. Some bugs are just a simple mistake while writing code, or [configuring an application](https://www.ibiblio.org/harris/500milemail.html). Others are much more complex.

Let's take a moment to review various kinds of failure.

## Disk/File

Many distributed systems ultimately rely on some form of physical storage \(SSDs, NVMe\) to keep their data safe. Like all hardware, these devices can fail due to age, wear, or misuse.

### Common Failures

* A file that was expected was not present. \(`open` fails\)
* A file that was not expected was present. \(`create` fails\)
* A file was removed after being opened. \(`read` / `write` fails\)
* A file contains data that is invalid to the reader. \(encoding mismatch, missing/extra data\)

## Network

Our nodes would exist in an isolated state if not for networks. Communicating with an external API could pass through hundreds of cables, routers, and switches, all of which \(including the API\) can fail in various ways.

Without a reliable network connection a node can be in the dark about the world. Perhaps it can only reach some of the nodes it expects, perhaps it can reach none.

### **Common Failures:**

* One node becomes isolated from the rest.
* A partition isolates two \(or more\) distinct node groups.
* Two particular nodes can no longer communicate.
* Malformed \(or outright hostile\) requests
* Increased probability of packet corruption \(forcing re-transmits\)
* The network becomes intolerably slow at some or all links.

## Scheduler

Events such as a network request, a file read, or even a thead context switch go through the scheduler. Depending on the state of the greater system\(s\) these events be scheduled in any number of different orders.

Even in a single-machine \(but multi-threaded\) system changing this schedule in subtle ways can expose interesting errors.

### Common Failures:

* The system expects to have events **ABC** in order and gets **ACB** instead.

## Power

Occasionally power grids \(or supplies\) hiccup or fail. This is different than just a network isolation, as the node may be in an unexpected state when it returns \(what if the filesystem has errors now? What if the system had to do a rollback?\)

### Common Failures

* A machine loses power, and is replaced some time later \(minutes, hours\) after being repaired. \(Try to find the worst cases possible for this, eg in the middle of a 2 phase commit.\)
* A machine reboots, disappearing and reappearing a minute later.
* A machine with persistent data reboots, and returns with corrupted data.

## Byzantine

Byzantine Fault Tolerance is described as the following:

> Trying to get a sufficiently large number of nodes to agree on something while a small number bad actors subvert the system.
>
> _Learn more at_ [_https://blog.cdemi.io/byzantine-fault-tolerance/_](https://blog.cdemi.io/byzantine-fault-tolerance/)_._

Byzantine fault tolerance is not relevant to most distributed systems, and introduces a significant amount of system complexity. Notable exceptions being things like Blockchains \(eg [Ethereum](https://www.ethereum.org/)\).

### Common Failures

* A node starts sending messages it shouldn't be, under the influence of a bad actor.
* A node is under the wrong impression about the state of the greater system due to some bug, and sends messages it shouldn't. \(Eg "I'm the master replica now, listen to me!"\)

## Data Center

In many distributed systems cross-datacenter deployments are used to help protect against regional failures. This is mostly just the "Big sister" of the above network and disk failures.

### Common Failures

* Data center\(s\) loses connectivity \(Eg an undersea fiber is cut\)
* Data center is lost entirely and a new one needs to be bootstrapped.

