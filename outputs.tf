output "s3_bucket_url" {
  description = "URL of the S3 bucket for Terraform state"
  value       = module.s3_backend.s3_bucket_url
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locks"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_configure_kubeconfig" {
  description = "Run this command to configure kubectl"
  value       = module.eks.eks_configure_kubeconfig
}

output "eks_ebs_csi_addon_version" {
  description = "Installed aws-ebs-csi-driver addon version"
  value       = module.eks.ebs_csi_addon_version
}

output "jenkins_namespace" {
  description = "Namespace where Jenkins is deployed"
  value       = module.jenkins.jenkins_namespace
}

output "jenkins_release_name" {
  description = "Helm release name for Jenkins"
  value       = module.jenkins.jenkins_release_name
}

output "argo_cd_namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = module.argo_cd.argo_cd_namespace
}

output "argo_cd_admin_password_command" {
  description = "Command to fetch the initial Argo CD admin password"
  value       = module.argo_cd.argo_cd_admin_password_command
}
