# Homework: EKS + Helm (Lesson 7)

This branch provisions an EKS cluster with Terraform and deploys a Django application to Kubernetes via Helm.

## What is included

- Terraform modules: S3/DynamoDB remote state backend, VPC, ECR, EKS cluster
- Helm chart `django-app`: Django deployment (ECR image), PostgreSQL, ConfigMap, Service (LoadBalancer), HPA
- Helm chart `metrics-server`: Kubernetes Metrics Server (required for HPA)

## Documentation

- [terraform/README.md](terraform/README.md) — modules, bootstrap flow, outputs
- [charts/README.md](charts/README.md) — chart architecture, deploy instructions

## Quick start

```bash
# 1. Bootstrap S3 backend, then provision all infrastructure
cd terraform
terraform init -backend=false -reconfigure
terraform apply -target=module.s3_backend   # creates S3 + DynamoDB
terraform init -migrate-state               # migrates local state → S3
terraform apply                             # creates VPC, ECR, EKS (~15 min)

# 2. Build and push the Django image to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  $(terraform output -raw ecr_repository_url)

docker build --platform linux/amd64 \
  -t $(terraform output -raw ecr_repository_url):latest \
  ../django/
docker push $(terraform output -raw ecr_repository_url):latest

# Update image.repository in charts/django-app/values.yaml with the ECR URL

# 3. Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name lesson-7-eks

# 4. Deploy Helm charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

helm dependency update charts/metrics-server
helm upgrade --install metrics-server charts/metrics-server -n kube-system

helm dependency update charts/django-app
helm upgrade --install django-app charts/django-app
```

## Verify

```bash
kubectl get pods          # db-*, django-app-django-* all Running
kubectl get svc           # django-app-django EXTERNAL-IP = ELB DNS
kubectl get hpa           # min=2 max=6 CPU 70%
```

## Cleanup

```bash
helm uninstall django-app
helm uninstall metrics-server -n kube-system
cd terraform && terraform destroy
```
