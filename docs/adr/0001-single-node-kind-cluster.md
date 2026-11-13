# ADR 0001: Single-node kind cluster for local development

- Status: Accepted
- Date: 2026-11-06

## Context

PagoRápido runs locally on a MacBook Air (Apple Silicon, 16 GB of RAM) before moving to AWS. Docker Desktop's VM is capped at about 8 GB, and Docker Desktop is closed when not in use because it is heavy for the machine.

The cluster must be:
- reproducible from code, so it can be deleted and recreated with one command;
- light on memory and CPU;
- able to run a gateway controller, reached from the laptop (see ADR 0002).

A first cluster was created with the Kubernetes built into Docker Desktop.

## Decision

Use [kind](https://kind.sigs.k8s.io/) with a single `control-plane` node, defined in `infra/kind/cluster.yaml`:
- cluster name `pagorapido` (context `kind-pagorapido`);
- node label `ingress-ready=true`, added for ingress-nginx on kind. No longer needed since ADR 0002 replaced ingress-nginx; kept for now and to be revisited in PR-3;
- host ports 80 and 443 mapped to the node;
- node image pinned to `kindest/node:v1.37.0`, so the Kubernetes version does not depend on the installed kind version.

Create it with `kind create cluster --config infra/kind/cluster.yaml`.

## Alternatives considered

| Option | Why not (for now) |
| --- | --- |
| Docker Desktop Kubernetes | Not defined in code, tied to the Docker Desktop version, single fixed setup |
| k3d | Not evaluated. Candidate if kind turns out too heavy |
| minikube | Not evaluated |
| Multi-node kind (1 control-plane + 2 workers) | Extra nodes cost memory and add nothing for the current stories. Multi-node scheduling will be practiced later on EKS |

## Consequences

- Measured on 2026-11-06 with `docker stats`: the node used about 859 MiB of memory and about 10% CPU at idle.
- The cluster is cheap. The larger cost is Docker Desktop itself, which reserves VM memory while it is open.
- Scheduling behaviour that needs several nodes (anti-affinity, node failure) cannot be tested locally. Revisit when those stories appear, or test them on EKS.
- Possible improvements: lower Docker Desktop's memory limit, or replace it with a lighter engine such as Colima or OrbStack.
