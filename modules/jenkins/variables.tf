variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Helm chart version for Jenkins"
  type        = string
  default     = "5.8.27"
}

variable "service_account_name" {
  description = "Kubernetes service account name for Jenkins controller and agents"
  type        = string
  default     = "jenkins-sa"
}

variable "storage_class_name" {
  description = "Default StorageClass name for Jenkins PVC"
  type        = string
  default     = "ebs-sc"
}

variable "storage_size" {
  description = "Persistent volume size for Jenkins controller"
  type        = string
  default     = "10Gi"
}

variable "admin_secret_name" {
  description = "AWS Secrets Manager secret ID containing Jenkins admin credentials JSON: {\"username\":\"...\",\"password\":\"...\"}"
  type        = string
  default     = "jenkins/admin"
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for IRSA"
  type        = string
}
