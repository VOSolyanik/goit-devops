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

output "rds_standard_endpoint" {
  description = "RDS write endpoint (null when Aurora is used)"
  value       = module.rds.standard_endpoint
}

output "rds_standard_port" {
  description = "RDS port (null when Aurora is used)"
  value       = module.rds.standard_port
}

output "rds_aurora_writer_endpoint" {
  description = "Aurora writer endpoint (null when standard RDS is used)"
  value       = module.rds.aurora_cluster_endpoint
}

output "rds_aurora_reader_endpoint" {
  description = "Aurora reader endpoint (null when standard RDS is used)"
  value       = module.rds.aurora_reader_endpoint
}

output "rds_security_group_id" {
  description = "Security group ID attached to the database"
  value       = module.rds.security_group_id
}

output "monitoring_namespace" {
  description = "Namespace where Prometheus and Grafana are deployed"
  value       = module.monitoring.monitoring_namespace
}

output "grafana_port_forward_command" {
  description = "Command to access Grafana at http://localhost:3000"
  value       = module.monitoring.grafana_port_forward_command
}

output "prometheus_port_forward_command" {
  description = "Command to access Prometheus at http://localhost:9090"
  value       = module.monitoring.prometheus_port_forward_command
}
