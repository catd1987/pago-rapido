CLUSTER_NAME ?= pagorapido
KIND_CONFIG  ?= infra/kind/cluster.yaml

.DEFAULT_GOAL := help
.PHONY: help cluster-up cluster-down cluster-status

help: ## Show available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "%-16s %s\n", $$1, $$2}'

cluster-up: ## Create the local kind cluster from infra/kind/cluster.yaml
	kind create cluster --config $(KIND_CONFIG)

cluster-down: ## Delete the local kind cluster
	kind delete cluster --name $(CLUSTER_NAME)

cluster-status: ## Show the cluster nodes
	kubectl --context kind-$(CLUSTER_NAME) get nodes
