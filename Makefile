init-argo-git:
	@helm template charts/_setup-root | kubectl apply -f -
get-self-signed-ca-certificate:
	kubectl get secret root-secret -n certmanager -o jsonpath="{.data.ca\.crt}" | base64 --decode > rootCA.pem
