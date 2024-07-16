init-argo-git:
	@helm template charts/_setup-root | kubectl apply -f -
