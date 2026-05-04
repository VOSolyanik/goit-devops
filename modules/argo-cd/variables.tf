variable "name" {
  description = "Helm release name for Argo CD"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Helm chart version for Argo CD"
  type        = string
  default     = "5.46.4"
}

variable "gitops_repo_url" {
  description = "Git repository URL that Argo CD watches"
  type        = string
}

variable "gitops_chart_path" {
  description = "Path to the Helm chart inside the GitOps repo"
  type        = string
  default     = "charts/django-app"
}

variable "gitops_target_revision" {
  description = "Git revision (branch or tag) for Argo CD to track"
  type        = string
  default     = "main"
}

variable "application_name" {
  description = "Argo CD Application name"
  type        = string
  default     = "django-app"
}

variable "application_namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "default"
}

variable "project" {
  description = "Argo CD project name"
  type        = string
  default     = "default"
}
