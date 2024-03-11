# Chapter 3: Kubernetes

We will also learn about the Cloud Native Computing Foundation (CNCF), which currently hosts the Kubernetes project, along with other popular cloud-native projects, such as Prometheus, Fluentd, cri-o, containerd, Helm, Envoy, and Contour, just to name a few.

Kubernetes was started by Google and, with its v1.0 release in July 2015, Google donated it to the Cloud Native Computing Foundation (CNCF), one of the largest sub-foundations of the Linux Foundation.

Started with Google's "Borg": [https://research.google/pubs/pub43438/]

Lessons learnt from Borg:

- API servers
- Pods
- IP-per-Pod
- Services
- Labels

### K8S Features:


**Automatic bin packing**
Kubernetes automatically schedules containers based on resource needs and constraints, to maximize utilization without sacrificing availability.

**Designed for extensibility**
A Kubernetes cluster can be extended with new custom features without modifying the upstream source code.

**Self-healing**
Kubernetes automatically replaces and reschedules containers from failed nodes. It terminates and then restarts containers that become unresponsive to health checks, based on existing rules/policy. It also prevents traffic from being routed to unresponsive containers.

**Horizontal scaling**
With Kubernetes applications are scaled manually or automatically based on CPU or custom metrics utilization.

**Service discovery and load balancing**
Containers receive IP addresses from Kubernetes, while it assigns a single Domain Name System (DNS) name to a set of containers to aid in load-balancing requests across the containers of the set.

### Additional features

**Automated rollouts and rollbacks**
Kubernetes seamlessly rolls out and rolls back application updates and configuration changes, constantly monitoring the application's health to prevent any downtime.

**Secret and configuration management**
Kubernetes manages sensitive data and configuration details for an application separately from the container image, in order to avoid a rebuild of the respective image. Secrets consist of sensitive/confidential information passed to the application without revealing the sensitive content to the stack configuration, like on GitHub.

**Storage orchestration**
Kubernetes automatically mounts software-defined storage (SDS) solutions to containers from local storage, external cloud providers, distributed storage, or network storage systems.

**Batch execution**
Kubernetes supports batch execution, long-running jobs, and replaces failed containers.

**IPv4/IPv6 dual-stack**
Kubernetes supports both IPv4 and IPv6 addresses.
