# Backlog

Points are story points. Status: done, in progress, todo.

## Sprint 1: local foundation

| Story | Pts | Status |
| --- | --- | --- |
| PR-1 Reproducible kind cluster | 2 | done |
| PR-2 Repo and README | 2 | done |
| PR-3 Gateway API with Envoy Gateway and Helm (see [ADR 0002](adr/0002-gateway-api-with-envoy-gateway.md)) | 3 | in progress |

## Not yet estimated

- PR template and CODEOWNERS.
- Branch protection on `main`.
- CI/CD: approval chains, reusable workflows, ephemeral self-hosted runners.

## E7 (optional): Incident copilot with an LLM

Comes after the observability epic, which is not defined in this repo yet. Design and rules: [ADR 0003](adr/0003-incident-copilot-claude-api.md).

| Story | Pts | Description |
| --- | --- | --- |
| PR-12 | 5 | Summarise a Prometheus alert with a probable cause and runbook steps (Python). Steps come from the runbook, not invented |
| PR-13 | 3 | Evaluation set of 10 to 20 incidents with the expected answer |
| PR-14 | 3 | Metrics (latency, errors, tokens, cost per call), SLO, spending cap, timeout and fallback |
| PR-15 | 3 | Postmortem draft from the timeline, reviewed by a person before publishing |
