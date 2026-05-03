variable "jenkins_admin_secret_name" {
  description = "AWS Secrets Manager secret ID for Jenkins admin credentials. Must contain JSON: {\"username\":\"...\",\"password\":\"...\"}"
  type        = string
  default     = "jenkins/admin"
}

variable "gitops_repo_url" {
  description = "Git repository URL that Argo CD watches and Jenkins updates"
  type        = string
  default     = "https://github.com/VOSolyanik/goit-devops.git"
}

variable "gitops_chart_path" {
  description = "Path to the Helm chart inside the GitOps repo"
  type        = string
  default     = "charts/django-app"
}

variable "gitops_target_revision" {
  description = "Git revision (branch or tag) for Argo CD to track"
  type        = string
  default     = "lesson-8-9"
}
