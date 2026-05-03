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
  default     = "lesson-10"
}

variable "rds_master_password" {
  description = "Master password for RDS/Aurora (pass via -var or TF_VAR_rds_master_password; never commit)"
  type        = string
  sensitive   = true
}

variable "rds_db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "rds_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
}

variable "rds_use_aurora" {
  description = "true = Aurora cluster + writer + reader, false = single RDS instance"
  type        = bool
  default     = false
}
