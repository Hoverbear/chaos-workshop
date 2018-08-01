---
description: >-
  You cannot safely, coherently, or usefully introduce chaos to your testing
  without understanding your infrastructure. Let's take a moment to review some
  things.
---

# Infrastructure Familiarization

## Setting a Baseline

Before we start introducing chaos let's take a bit of time to ensure we are meeting a baseline of:

* Service failures can be detected.
* Failed services should restart automatically.
* Logs are collected. \(preferably we can collect all debug logs as well\)
* Metrics are collected.
* There is some way to view system wide logs and metrics. \(Eg Kibana/Grafana\)

If you're already doing these things feel free to skip the pages related to them.

## Understanding Your System

Try to collect some information about **each component in the system**:

* What is the minimum number of nodes fulfilling this role that need to be in a healthy state in order to function? \(For example, a raft group requires a majority online\)
* Is the component stateful? If so, where is state saved? Which data is required by the system to not be lost/corrupted?
* Is the component mission critical? If it entirely fails should the system still work? \(albeit in a degraded state\)
* Are there any metrics you should be monitoring on this component during your testing? \(Eg QPS on a SQL database\)

Additionally, from the perspective of **the entire system**:

* What are the main metrics of the system?
* What is a realistic workload for the system? How can you reproduce this?
* At what point do you expect the system to fail? \(Eg if you switch off the SQL databases entirely the system should break\)
* What is the average cluster topology and size of the system? What is the breaking point of this system? \(Eg the majority of nodes of each component is alive\)

## 

