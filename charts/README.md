# Helm Charts — Lesson 7

Two charts for deploying the Django application to EKS.

## Chart overview

| Chart | Namespace | Purpose |
|---|---|---|
| `metrics-server` | `kube-system` | Kubernetes Metrics Server — required for HPA CPU metrics |
| `django-app` | `default` | Django app, PostgreSQL, ConfigMap, LoadBalancer Service, HPA |

## django-app architecture

```
charts/django-app/
├── Chart.yaml              # chart metadata; postgresql subchart disabled
├── values.yaml             # all configurable parameters
└── templates/
    ├── configmap.yaml      # env vars (POSTGRES_*, DJANGO_*)
    ├── deployment.yaml     # Django; 2 replicas; envFrom ConfigMap; ECR image
    ├── service.yaml        # LoadBalancer port 80 → 8000
    ├── hpa.yaml            # autoscaling/v2; min=2 max=6; targetCPU=70%
    └── postgres.yaml       # postgres:17-alpine Deployment + ClusterIP Service "db"
```

> **Why `postgres:17-alpine` instead of Bitnami subchart?**  
> Bitnami stopped publishing images to Docker Hub. EKS nodes cannot pull `bitnami/postgresql` without a Docker Hub subscription. The official `postgres` image is always freely available and uses the same env vars (`POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`).

## Prerequisites

```bash
# metrics-server repo only — no Bitnami repo needed
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
```

## Deploy

```bash
# 1. Metrics Server (install first — HPA depends on it)
helm dependency update charts/metrics-server
helm upgrade --install metrics-server charts/metrics-server -n kube-system

# 2. Django app
# Update image.repository in charts/django-app/values.yaml with your ECR URL:
#   terraform -chdir=terraform output -raw ecr_repository_url
helm dependency update charts/django-app
helm upgrade --install django-app charts/django-app
```

## Verify

```bash
kubectl get pods                     # db-*, django-app-django-* → Running
kubectl get svc django-app-django    # EXTERNAL-IP = ELB DNS name
kubectl get hpa django-app-django    # MINPODS=2 MAXPODS=6 CPU=70%
```

## Cleanup

```bash
helm uninstall django-app
helm uninstall metrics-server -n kube-system
```
```
