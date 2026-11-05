# PagoRápido

Plataforma de pagos de práctica para entrevistas SRE de Carlos. Todo el proyecto es una historia para contar en entrevistas: cada decisión se documenta y cada épica termina con un resultado medible.

## Idioma y estilo
- Responder en español. Explicar el porqué de cada comando antes de pedir que lo ejecute.
- Carlos trabaja en una MacBook Air Apple Silicon con 8 GB de RAM: usar el mínimo de recursos.

## Diseño
- payments-api (Go) + worker (Python) + Postgres + cola con DLQ.
- Fase actual: local en kind, un solo nodo (cluster `pagorapido`, contexto `kind-pagorapido`), ingress-nginx en localhost:80.
- Después del examen CKAD (semana del 1 feb 2027): AWS con Terraform, EKS, RDS, SNS/SQS.
- Docs de referencia (borrador): https://claude.ai/artifact/VG9QvcSAwcH6TuzZSasyTu

## Decisiones tomadas (no reabrir sin que Carlos lo pida)
- GitHub Actions para el CI/CD del código. Jenkins solo para jobs de operación.
- Terraform para toda la IaC. Sin VMware. Sin Cribl.
- Monorepo: apps/, infra/, deploy/, docs/.

## Convenciones
- Una rama por historia, PR hacia main, commits claros (`feat: ingress-nginx con Helm (PR-3)`).
- Cada decisión importante va en docs/adr/000N-titulo.md.
- Al final de cada sesión, agregar una línea a docs/journal.md.
- Nunca subir claves, tokens ni credenciales.

## Backlog actual (Sprint 1)
- PR-1 cluster kind reproducible (2 pts), PR-2 repo y README (2 pts), PR-3 ingress-nginx con Helm (3 pts).
