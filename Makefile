.PHONY: create-dirs create-cluster start stop clean  setup-all
BRANCH ?= main
REPO_URL ?= "https://github.com/mazelab/kindpro.git"

create-dirs:
	mkdir -p $(shell echo $$HOME)/.kindpro/data

create-cluster: create-dirs ## (re)create a test cluster with kind
	@./setup-cluster.sh

recreate-cluster: clean create-cluster ## delete and create a test cluster with kind

start: ## start the test cluster
	@docker start kind-control-plane kind-worker2 kind-worker
	@echo "Cluster started"

stop: ## stop the test cluster
	@docker stop kind-worker2 kind-worker kind-control-plane
	@echo "Cluster stopped"

clean: ## delete the test cluster
	@kind delete cluster --name kindpro
	@echo "Cluster deleted"

generate-root-ca: ## generate ca file and write to ~/.kindpro/.ssl
	@./generateRootCa.sh

set-root-secret-ca: ## write root-ca-secret for the cert-manager
	@./setup-root-ca-secret.sh

reinstall-argocd:
	@helm delete argo-cd
	@helm install argo-cd charts/_init/

inital-deploy-root-app:
	@helm template charts/_setup-basics --set branch=$(BRANCH),repoUrl=$(REPO_URL) | kubectl apply -f -

delete-root-app:
	@helm template charts/_setup-basics --set branch=$(BRANCH),repoUrl=$(REPO_URL) | kubectl delete -f -

get-self-signed-ca-certificate:
	kubectl get configmap kube-root-ca.crt -n cert-manager -o jsonpath="{.data.ca\.crt}" > rootCA.pem
import-self-signed-ca-certificate-mac: get-self-signed-ca-certificate
	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain rootCA.pem
remove-self-signed-ca-certificate-mac:
	sudo security delete-certificate -c "my-selfsigned-ca" /Library/Keychains/System.keychain

get-initial-argo-password:
	kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

setup-all: create-cluster set-root-secret-ca inital-deploy-root-app ## Set up the entire environment
	@echo "All setup tasks completed."
