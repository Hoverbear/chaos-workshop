---
description: The pillars of chaos.
---

# Principles of Chaos

## Basic Principles

### Determine Metrics to Measure, or a 'Steady State'

Since the goal is to compare the system in chaos with a system under normal circumstances, we first need a way to compare a **control** and an **experiment**.

For a database this could be the QPS while running the TPC-H benchmarks. For a REST API it could be the average response time of a bank of calls.

### Hypothesize how Failures Might Impact the Steady State

Determine which kinds, and what level, of failure your system should be able to withstand before degrading or failing completely.

Try to reflect real world scenarios, but don't stop yourself from imagining even the most extreme or perverse situations. 

In a PostgreSQL cluster failing a replica shouldn't impact the performance of a master, but failing a lone master will certainly cause downtime.

Have a system that spans multiple data centers? What happens if one of them is [immersed in floodwater](https://www.datacenterknowledge.com/archives/2012/10/30/major-flooding-nyc-data-centers)? What if the fiber between continents is [mistakenly severed](https://www.independent.co.uk/news/world/africa/mauritiana-internet-cut-underwater-cable-offline-days-west-africa-a8298551.html)?

Only worried about one datacenter? What happens if someone accidently unplugs the wrong drive during maintenance? Or an administrator accidentally evicts one of your load balancers?

What about how the system will behave using preemptive machines on your favorite cloud provider?

Don't forget that partial failures exist too. What happens if there is a network partition, and the nodes are in two distinct groups? What if one node dramatically slows down?

### Introduce Failures

Using a variety of tools and techniques you can simulate many of the above failures. In some situations even multiple separately harmless failures can cause a cascade.

### Try to Disprove your Previous Hypothesis

If any of the failures you introduced disproves your hypothesis it means one of three things:

* Your test isn't correctly producting the failure. \(Check it and try again!\)
* Your hypothesis was not correct. \(Verify your assumptions about the system.\)
* Your system failed when it shouldn't have. \(You have a bug! Try to build a reproduction case\)

## Advanced Principles

This principles are outlined by the [Principles of Chaos](https://principlesofchaos.org/).

### **Build a Hypothesis Around Steady State Behavior**

Focus on the measurable output of a system, rather than internal attributes of the system.  Measurements of that output over a short period of time constitute a proxy for the system’s steady state.  The overall system’s throughput, error rates, latency percentiles, etc. could all be metrics of interest representing steady state behavior.  By focusing on systemic behavior patterns during experiments, Chaos verifies that the system does work, rather than trying to validate how it works.

### **Vary Real-world Events**

Chaos variables reflect real-world events.  Prioritize events either by potential impact or estimated frequency.  Consider events that correspond to hardware failures like servers dying, software failures like malformed responses, and non-failure events like a spike in traffic or a scaling event.  Any event capable of disrupting steady state is a potential variable in a Chaos experiment.

### **Run Experiments in Production**

Systems behave differently depending on environment and traffic patterns.  Since the behavior of utilization can change at any time, sampling real traffic is the only way to reliably capture the request path.  To guarantee both authenticity of the way in which the system is exercised and relevance to the current deployed system, Chaos strongly prefers to experiment directly on production traffic.

### **Automate Experiments to Run Continuously**

Running experiments manually is labor-intensive and ultimately unsustainable.  Automate experiments and run them continuously.  Chaos Engineering builds automation into the system to drive both orchestration and analysis.

### **Minimize Blast Radius**

Experimenting in production has the potential to cause unnecessary customer pain. While there must be an allowance for some short-term negative impact, it is the responsibility and obligation of the Chaos Engineer to ensure the fallout from experiments are minimized and contained.



