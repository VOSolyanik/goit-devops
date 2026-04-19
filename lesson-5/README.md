# lesson-5 - Terraform (AWS)

Infrastructure in `us-east-1` with remote Terraform state in S3, lock table in DynamoDB, VPC networking, and ECR repository.

## Structure

```text
lesson-5/
├── main.tf
├── backend.tf
├── outputs.tf
├── README.md
└── modules/
    ├── s3-backend/   # S3 + DynamoDB
    ├── vpc/          # VPC, subnets, IGW, NAT, routes
    └── ecr/          # ECR repository and policy
```

## Commands

Run from `lesson-5/`:

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

After any module/backend config change, run `terraform init` again.

## Modules

1. `s3-backend`
- Creates S3 bucket for Terraform state.
- Enables bucket versioning.
- Creates DynamoDB lock table.
- Outputs only required values: S3 bucket URL and DynamoDB table name.

2. `vpc`
- Creates VPC `10.0.0.0/16`.
- Creates 3 public and 3 private subnets.
- Creates Internet Gateway, NAT Gateway, route tables, and associations.

3. `ecr`
- Creates ECR repository.
- Enables image scanning on push.
- Applies same-account repository policy.

## Backend Bootstrap Flow

Because the backend resources are also managed by Terraform, bootstrap in two phases:

```bash
terraform init -backend=false
terraform apply -target=module.s3_backend
terraform init -migrate-state
```

## Notes

1. NAT Gateway and Elastic IP (public IPv4) are billable resources.
2. After verification, run `terraform destroy` to avoid extra charges.
3. Full destroy also removes backend resources (S3 + DynamoDB), so for re-apply use backend bootstrap flow again.
4. `force_destroy = true` is enabled for the state bucket; with versioning, old object versions/delete markers can still require explicit cleanup in some failure scenarios.
5. If destroy fails with state lock errors and DynamoDB lock table was already removed, use `terraform force-unlock <LOCK_ID>` only when no other Terraform run is active.
