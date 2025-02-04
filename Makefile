.PHONY: create-dirs create-cluster start stop clean  setup-all

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
	@kind delete cluster
	@echo "Cluster deleted"

reinstall-argocd:
	@helm install argo-cd charts/argo-cd/

inital-deploy-root-app:
	@helm template charts/_setup-basics | kubectl apply -f -
delete-root-app:
	@helm template charts/_setup-basics | kubectl delete -f -
get-self-signed-ca-certificate:
	kubectl get secret root-secret -n certmanager -o jsonpath="{.data.ca\.crt}" | base64 --decode > rootCA.pem
import-self-signed-ca-certificate-mac: get-self-signed-ca-certificate
	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain rootCA.pem
remove-self-signed-ca-certificate-mac:
	sudo security delete-certificate -c "my-selfsigned-ca" /Library/Keychains/System.keychain

get-initial-argo-password:
	kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

setup-all: create-cluster inital-deploy-root-app ## Set up the entire environment
    @echo "All setup tasks completed."
