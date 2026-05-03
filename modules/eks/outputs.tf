output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_certificate_authority" {
  description = "Base64-encoded certificate authority data for the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "eks_configure_kubeconfig" {
  description = "AWS CLI command to configure kubectl for this cluster"
  value       = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.main.name}"
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value       = aws_iam_openid_connect_provider.oidc.arn
}

output "oidc_provider_url" {
  description = "OIDC provider URL for IRSA"
  value       = aws_iam_openid_connect_provider.oidc.url
}

output "ebs_csi_addon_version" {
  description = "Installed aws-ebs-csi-driver addon version"
  value       = aws_eks_addon.ebs_csi_driver.addon_version
}
