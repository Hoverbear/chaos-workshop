---
description: 'Without insight into the system, how can we know if and when it works?'
---

# Monitoring and Logging

Chaos engineering relies heavily on being able to understand and analyze the state of a whole system. Critically, we need to be able to analyze the **whole** state of the system.

In general, you should be able to answer the following questions about your system at any given point in time:

* How fast is it running?
* How many errors are occuring?
* What was logged on a particular node for a particular timespan, even if that machine is now destroyed?
* How many, and which, nodes are presently failing?
* 
