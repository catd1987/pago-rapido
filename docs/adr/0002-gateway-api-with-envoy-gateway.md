# ADR 0002: Gateway API with Envoy Gateway instead of ingress-nginx

- Status: Accepted (installation and validation happen in PR-3)
- Date: 2026-11-12

## Context

PR-3 needs a way to route external traffic into the local kind cluster. The default choice for kind has been ingress-nginx, but:

- ingress-nginx was retired by the Kubernetes project: best-effort maintenance ended in March 2026 and it receives no further releases or security fixes ([retirement announcement](https://kubernetes.io/blog/2025/11/11/ingress-nginx-retirement/)).
- CVE-2026-116472 (`mirror-target` annotation, low severity) has no upstream fix for that reason ([advisory](https://discuss.kubernetes.io/t/security-advisory-cve-2026-116472-ingress-nginx-mirror-target-self-dos/35554)).
- Starting a new project on an unmaintained component is not a defensible choice, and the same decision will be needed again on EKS.

kind has no cloud load balancer, so a `LoadBalancer` Service never gets an external address locally.

## Decision

Use the Gateway API (the successor of the Ingress API) with [Envoy Gateway](https://gateway.envoyproxy.io/) v1.10.0.

- Per the Envoy Gateway compatibility matrix, v1.10 is tested with Gateway API v1.6.1 and Kubernetes v1.34 to v1.37. The cluster runs Kubernetes v1.37.0 (see ADR 0001).
- Install it with Helm in PR-3.
- Because kind has no load balancer, reach the gateway locally with `kubectl port-forward` to the Envoy proxy Service.

## Alternatives considered

| Option | Why not (for now) |
| --- | --- |
| ingress-nginx | Retired, unfixed CVE, no future releases |
| Other Gateway API implementations (for example Traefik, NGINX Gateway Fabric) | Not evaluated. Candidates if Envoy Gateway proves too heavy or hard to operate |

## Consequences

- The Ingress object is replaced by `GatewayClass`, `Gateway` and `HTTPRoute`. These resources are also what a production setup on EKS would use.
- Access from the laptop needs a running `port-forward` instead of `localhost:80`.
- The `ingress-ready=true` node label and the host port mappings 80 and 443 in `infra/kind/cluster.yaml` were added for ingress-nginx. They are not needed with `port-forward` and are left unchanged in this PR. Revisit them in PR-3.
- Envoy Gateway's memory footprint has not been measured yet. Measure it with `docker stats` in PR-3 and record it here, because the single-node cluster is memory-constrained.
