variable "namespace" {
  description = "Kubernetes namespace for Prometheus and Grafana"
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Helm chart version for prometheus-community/prometheus"
  type        = string
  default     = "25.21.0"
}

variable "grafana_chart_version" {
  description = "Helm chart version for grafana/grafana"
  type        = string
  default     = "7.3.7"
}

variable "grafana_admin_password" {
  description = "Grafana admin password (sensitive)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Map of tags (unused by Helm resources but kept for consistency)"
  type        = map(string)
  default     = {}
}
