
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat Large Number of Suspended Threads Incident.
---

In software engineering, a large number of suspended threads in Tomcat is an incident type that occurs when a high number of threads are created but are blocked from executing. This can happen due to a variety of reasons, such as slow database queries, network latency, or resource contention. When this occurs, the system may become unresponsive or slow, causing a degradation in performance or even a complete system failure. It is important to investigate and resolve this issue as quickly as possible to ensure the system can continue to function properly.

### Parameters
```shell
export PORT_NUMBER="PLACEHOLDER"

export PID="PLACEHOLDER"

export MAX_THREADS="PLACEHOLDER"

export MAX_IDLE_TIME="PLACEHOLDER"
```

## Debug

### Next Step
```shell
sh
```

### Identify the PID of the Tomcat process
```shell
PID=$(sudo lsof -t -i:${PORT_NUMBER})
```

### Check the number of threads blocked in the JVM
```shell
sudo jstack -l $PID | grep "java.lang.Thread.State" | grep -c "BLOCKED"
```

### Check the number of threads waiting on a monitor lock
```shell
sudo jstack -l $PID | grep "java.lang.Thread.State" | grep -c "WAITING"
```

### Check the number of threads in the "TIMED_WAITING" state
```shell
sudo jstack -l $PID | grep "java.lang.Thread.State" | grep -c "TIMED_WAITING"
```

### Check the number of threads in the "RUNNABLE" state
```shell
sudo jstack -l $PID | grep "java.lang.Thread.State" | grep -c "RUNNABLE"
```

### Check the current heap usage of the Tomcat JVM
```shell
sudo jmap -heap $PID | grep -A 1 "used" | tail -n 1 | awk '{print $1}'
```

### Check the current CPU usage for the Tomcat process
```shell
sudo top -p $PID -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}'
```

## Repair


### Tune the thread pool settings in Tomcat to prevent the creation of too many threads and limit the amount of time a thread is allowed to remain suspended.
```shell


#!/bin/bash

# Set the thread pool settings in Tomcat configuration

sed -i 's/<Connector port="8080"/<Connector port="8080" maxThreads="${MAX_THREADS}" maxIdleTime="${MAX_IDLE_TIME}"/' /path/to/your/server.xml


# Restart Tomcat service

systemctl restart tomcat


```