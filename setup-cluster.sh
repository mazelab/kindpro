#!/bin/bash

# Replace __HOME__ with the actual home directory in kind-config.yaml and create the cluster
sed "s|__HOME__|$HOME|g" kind-config.yaml | kind create cluster --name kindpro --config=-

# Check if the current context is the kindpro cluster
CURRENT_CONTEXT=$(kubectl config current-context)
if [ "$CURRENT_CONTEXT" != "kind-kindpro" ]; then
  echo "Current context is not kind-kindpro. Exiting."
  exit 1
fi

# Apply the ingress-nginx controller manifest
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for the ingress-nginx controller to be ready
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

# Install a minimal Argo CD version using the inline Helm chart
helm dependency build charts/_init &&
kubectl create namespace argocd &&
helm install argo-cd charts/_init/

