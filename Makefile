.PHONY: create-dirs create-cluster start stop clean setup-all check-context
BRANCH ?= main
REPO_URL ?= https://github.com/mazelab/kindpro.git
NAMESPACE ?= default

check-context:
	@CURRENT_CONTEXT=$$(kubectl config current-context); \
	if [ "$$CURRENT_CONTEXT" != "kind-kindpro" ]; then \
		echo "Current context is not kind-kindpro. Exiting."; \
		exit 1; \
	fi

create-dirs:
	mkdir -p $(shell echo $$HOME)/.kindpro/data

create-cluster: create-dirs ## (re)create a test cluster with kind
	@./setup-cluster.sh

recreate-cluster: clean setup-all ## delete and create a test cluster with kind

start: ## start the test cluster
	@docker start kind-control-plane kind-worker2 kind-worker
	@echo "Cluster started"

stop: ## stop the test cluster
	@docker stop kind-worker2 kind-worker kind-control-plane
	@echo "Cluster stopped"

clean: ## delete the test cluster
	@kind delete cluster
	@echo "Cluster deleted"

reinstall-argocd: check-context
	@helm install argo-cd charts/argo-cd/

deploy-root-app: check-context
	@helm template charts/_setup-basics --set branch=$(BRANCH),repoUrl=$(REPO_URL),namespace=$(NAMESPACE) | kubectl apply -f - --namespace=$(NAMESPACE)

delete-root-app: check-context
	@helm template charts/_setup-basics --set branch=$(BRANCH),repoUrl=$(REPO_URL),namespace=$(NAMESPACE) | kubectl delete -f - --namespace=$(NAMESPACE)

get-self-signed-ca-certificate: check-context
	kubectl get secret root-secret -n certmanager -o jsonpath="{.data.ca\.crt}" | base64 --decode > rootCA.pem

import-self-signed-ca-certificate-mac: get-self-signed-ca-certificate
	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain rootCA.pem

remove-self-signed-ca-certificate-mac:
	sudo security delete-certificate -c "my-selfsigned-ca" /Library/Keychains/System.keychain

get-initial-argo-password: check-context
	kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" --namespace=$(NAMESPACE) | base64 -d

setup-all: create-cluster deploy-root-app ## Set up the entire environment
	@echo "All setup tasks completed."
