init-argo-git:
	@helm template charts/argocd-git | kubectl apply -f -
