# Kind Project with ArgoCD

This repository contains scripts and configuration files to set up a test cluster using Kind and deploy

- ArgoCD
- Gitea
- CertManager
- A self signed certificate
- External Secrets Operator

## Prerequisites

Before getting started, make sure you have the following prerequisites installed:

- Docker or DockerWrapper
- Kind
- kubectl
- Helm
- make

## Getting Started

To create the test cluster and deploy ArgoCD, follow these steps:

```bash
make setup-all
```

This Makefile target is responsible for creating a test cluster, deploying the Ingress-Nginx controller, adding the Argo CD Helm repository, installing the Argo CD chart onto the cluster and finally setup the tools in a pre-configured way.

That's it! Now you can start and stop the test cluster as needed. Happy coding!

## Usage

For more advanced usage and customization, you can modify the helm values.

### Useful tasks

Inspect the Makefile to get an impression and overview of all targets.

```bash
make recreate-cluster
```

Running this command will recreate the test cluster, ensuring a fresh setup for further testing and deployment.

```bash
make get-initial-argo-password
```

Getting the Initial ArgoCD admin Password

```bash
make reinstall-argocd
```

Reinstall ArgoCD. Useful if you unintentionally delete the ArgoCD part.

```bash
make start
```

Starts the kind docker container.

```bash
make stop
```

Stops the running kind cluster without deletion.

```bash
make clean
```

Warning, this is a destructive action. It will delete the cluster container.

### Example: Passing a Different REPO_URL

You can pass a different `REPO_URL` when invoking `make` by setting the environment variable `REPO_URL`. For example:

```sh
make REPO_URL="http://gitea-http:3000/kindpro/kindpro" inital-deploy-root-app
```

This will deploy the root application with the `REPO_URL` set to a local dev repository.
