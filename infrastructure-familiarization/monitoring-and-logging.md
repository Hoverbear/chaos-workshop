---
description: 'Without insight into the system, how can we know if and when it works?'
---

# Monitoring and Logging

Chaos engineering relies heavily on being able to understand and analyze the state of a whole system. Critically, we need to be able to analyze the **whole** state of the system.

In general, you should be able to answer the following questions about your system at any given point in time:

* How fast is it running?
* How many errors are occurring?
* What was logged on a particular node for a particular time span, even if that machine is now destroyed?
* How many, and which, nodes are presently failing?

If you do not have such infrastructure in place, or are not familiar with the infrastructure you have, this is the perfect opportunity.

One common way to do this is to deploy [Prometheus](https://prometheus.io/) with [Grafana](https://grafana.com/) and [Kibana](https://www.elastic.co/products/kibana). It will take some time and work to get this infrastructure in place, and even more to correctly configure your dashboards.

**It will be worth it.**



