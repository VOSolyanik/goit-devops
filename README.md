# Homework: IaC (Terraform)

This repository branch contains lesson-5 homework for AWS Infrastructure as Code with Terraform.

## What is included

- Remote Terraform state backend in S3 with DynamoDB locking.
- AWS VPC with public/private subnets, IGW, NAT, and routing.
- AWS ECR repository with scan-on-push.

## Main documentation

Detailed implementation notes, module breakdown, execution flow, and troubleshooting are in:

- [lesson-5/README.md](lesson-5/README.md)

## Quick start

```bash
cd lesson-5
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
cd lesson-5
terraform destroy
```
