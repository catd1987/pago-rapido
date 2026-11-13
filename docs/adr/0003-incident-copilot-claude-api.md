# ADR 0003: Incident copilot with the Claude API, not a local model

- Status: Proposed (optional epic E7, not started)
- Date: 2026-11-12

## Context

Epic E7 adds an optional incident copilot: it summarises a Prometheus alert with a probable cause and the matching runbook steps, and drafts postmortems.

The laptop has 16 GB of RAM, but Docker Desktop's VM is capped at about 8 GB and is the heaviest process (see ADR 0001). The kind node alone uses about 859 MiB. A local model would have to share that budget with the cluster, the apps and the observability stack.

## Decision

Call the Claude API from a small Python service instead of running a local model.

Rules:
- **Read-only.** The copilot has no write permissions on the cluster.
- **No secrets and no payment data** are ever sent to the model. Alert text and runbook content only.
- **API key in a Kubernetes Secret.** Never in git.
- **Prompts versioned in git**, reviewed like code.
- **Timeout and fallback.** If the call fails or times out, return the plain runbook.
- **Runbook-grounded.** Steps come from the runbook, not from the model's imagination.

## Alternatives considered

| Option | Why not |
| --- | --- |
| Local model | Competes for memory with the cluster on a machine where Docker is already the heaviest process |
| No LLM, runbook only | Remains the fallback, and is the baseline to compare against in PR-13 |

## Consequences

- Data leaves the laptop, which is why the no-secrets and no-payment-data rules are strict.
- Responses are not deterministic: an evaluation set (PR-13) is required before trusting the output.
- There is a per-call cost and latency. PR-14 adds metrics (latency, errors, tokens, cost), an SLO and a spending cap.
- A postmortem draft is always reviewed by a person before it is published (PR-15).
- Depends on the observability epic, which does not exist in the repo yet.
