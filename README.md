---
description: A field guide.
---

# Surviving Chaos

{% hint style="info" %}
Psst! This guide is still in progress, and is not representative of the final product.
{% endhint %}

This repository contains the guide and content for the "Surviving Chaos: A Field Guide" workshop hosted at Linux Foundation Open Source Summit 2018 in Vancouver, BC, Canada on August 29-31, 2018.

## Who is this for?

This workshop is targetted towards people who want to:

* Hunt the most obscure and unexpected bugs.
* Improve their testing.
* Build more robust services.
* Find things they overlooked.
* Deploy with more confidence.
* Develop a deeper understanding of the sinister ways computers can fail.
* Sleep soundly at night, without worrying about getting a page.

## What do I need to know?

In for this workshop you are expected to be:

* Comfortable navigating a machine via console.
* Able to understand and work with simple `bash` scripts.
* Proficient with editing text on the console.  \(With `nvim`, `emacs`, or whatever\).
* Familiar with some supervisor. \(We'll use `systemd`\)
* Able to write code in some language. \(We'll be using some simple Rust for our demos\)
* Not afraid to kill processes.

## What's Inside?

* This guide.
* A copy of the `reveal.js` slides.
* A `terraform` script to provision a laboratory for you.
* A provisioning `bash` script for Ubuntu 18.04 that sets up all required tools.
* Demo programs to use in your exploration.

## Topics to be covered:

* What is Chaos Engineering?
  * What are the principles?
  * What kinds of failure should happen?
  * What does it help catch?
  * What does it not catch?
  * Where can I learn more?
* Operations Preparation
  * Knowing your infrastructure.
  * Service health checks and recovery with systemd.
  * Monitoring and log collection.
  * Generating simulated load.
* Basics of `kill`.
  * Manual chaos.
* Simulating a shoddy network with `ip link`.
  * Shakey latency, packet loss, and reordering.
* Injecting system faults with `systemtap`.
  * What can be injected.
  * Scripting methods
* Using fuzzy scheduling with `nmz`.
  * What it does.
  * How to use.
* Application level failure injection.
  * Example with `fail-rs`.
* Chaos in your CI/CD.
  * Avoiding unrelated failures in PRs.
  * Small Schrodinger Demo.

