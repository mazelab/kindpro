init-argo-git:
	@helm template charts/_setup-root | kubectl apply -f -
delete-argo-git:
	@helm template charts/_setup-root | kubectl delete -f -
get-self-signed-ca-certificate:
	kubectl get secret root-secret -n certmanager -o jsonpath="{.data.ca\.crt}" | base64 --decode > rootCA.pem
import-self-signed-ca-certificate-mac:
	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain rootCA.pem
remove-self-signed-ca-certificate-mac:
	sudo security delete-certificate -c "my-selfsigned-ca" /Library/Keychains/System.keychain
