# PagoRápido

A practice payments platform built for SRE interview preparation. The product is not the point, the path is: every technical decision is documented and every epic ends with a measurable result.

## Architecture (target design)

- **payments-api** (Go): receives and records payments.
- **worker** (Python): processes payments from the queue.
- **Postgres**: storage.
- **Queue with DLQ**: messages that keep failing go to a dead-letter queue for analysis.

> Status: only the local cluster exists. The applications are not implemented yet.

## Repository layout

| Folder | Contents |
| --- | --- |
| `apps/` | payments-api and worker code (pending) |
| `infra/` | Infrastructure as code. Today: the kind cluster |
| `deploy/` | Deployment manifests and charts (pending) |
| `docs/` | Decisions (`docs/adr/`) and journal (`docs/journal.md`) |

## Local cluster

Requirements: Docker, [kind](https://kind.sigs.k8s.io/), kubectl and make.

```bash
make help            # list available targets
make cluster-up      # create the cluster
make cluster-status  # check that the node is Ready
```

`make cluster-up` runs `kind create cluster --config infra/kind/cluster.yaml`.

This creates the `pagorapido` cluster (context `kind-pagorapido`) with a single node and maps host ports 80 and 443 for the ingress. A single node is intentional, to keep resource usage low on a laptop: the node uses about 0.85 GB of memory (measured with `docker stats`).

To delete it:

```bash
make cluster-down
```

## CI/CD goals

The pipeline is part of what this project demonstrates:

- **Approval chains:** gated deployments with GitHub Environments (required reviewers), CODEOWNERS and branch protection.
- **Reusable workflows:** shared pipeline logic published with `workflow_call` and reused by every app pipeline.
- **Ephemeral self-hosted runners:** runners are created when a job starts and destroyed when it finishes, so no idle runner sits waiting and wastes resources.

## Roadmap

1. **Local (now):** kind, ingress-nginx with Helm, apps and database.
2. **CI/CD:** approval chains, reusable workflows, ephemeral runners.
3. **Cloud (after the CKAD exam, February 2027):** AWS with Terraform, EKS, RDS, SNS/SQS.

## Technical decisions

- GitHub Actions for application CI/CD; Jenkins only for operational jobs.
- Terraform for all infrastructure as code.
- Monorepo.

Important decisions are recorded as ADRs in [`docs/adr/`](docs/adr/). Day-to-day progress is in the [journal](docs/journal.md).
