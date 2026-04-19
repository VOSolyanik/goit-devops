# Terraform — Lesson 7: EKS + ECR + VPC

Provisions the AWS infrastructure for the lesson-7 Kubernetes deployment.

## Created resources

| Resource | Name | Notes |
|---|---|---|
| S3 bucket + DynamoDB | `goit-devops-lesson-7-tfstate-451790114144` / `terraform-locks-7` | Remote state backend |
| VPC | `lesson-7-vpc` | 10.0.0.0/16, 3 public + 3 private subnets, us-east-1a/b/c |
| ECR | `lesson-7-ecr` | scan-on-push enabled |
| EKS cluster | `lesson-7-eks` | Kubernetes 1.32, t3.small managed node group |

## Module layout

```
terraform/
├── backend.tf          # S3 remote state config
├── main.tf             # Module wiring + provider config
├── outputs.tf          # Key resource outputs
└── modules/
    ├── s3-backend/     # S3 bucket + DynamoDB table
    ├── vpc/            # VPC, subnets, IGW, NAT gateway, routes
    ├── ecr/            # ECR repository with policy
    └── eks/            # EKS cluster, IAM roles, managed node group, subnet tags
```

## Bootstrap and apply

The S3 bucket must exist before the backend can be enabled. Two-step process:

```bash
cd terraform

# Step 1: create S3 + DynamoDB with local state (backend.tf commented out)
terraform init -backend=false -reconfigure
terraform apply -target=module.s3_backend

# Step 2: enable backend and migrate local state to S3
# (uncomment/restore backend.tf first)
terraform init -migrate-state    # enter "yes" when prompted
terraform apply                  # provision VPC, ECR, EKS (~15 min)
```

### Re-apply after first bootstrap

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Configure kubectl

```bash
terraform output -raw eks_configure_kubeconfig | bash
# runs: aws eks update-kubeconfig --region us-east-1 --name lesson-7-eks
```

## Key outputs

| Output | Use |
|---|---|
| `ecr_repository_url` | Set as `image.repository` in `charts/django-app/values.yaml` |
| `eks_cluster_name` | `lesson-7-eks` |
| `eks_cluster_endpoint` | EKS API server URL |
| `eks_configure_kubeconfig` | Ready-to-run `aws eks update-kubeconfig` command |

## Cleanup

```bash
terraform destroy
```

> S3 bucket has `force_destroy = true` so it will be emptied and deleted automatically.
