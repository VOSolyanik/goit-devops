output "monitoring_namespace" {
  description = "Namespace where Prometheus and Grafana are deployed"
  value       = var.namespace
}

output "prometheus_release_name" {
  description = "Helm release name for Prometheus"
  value       = helm_release.prometheus.name
}

output "grafana_release_name" {
  description = "Helm release name for Grafana"
  value       = helm_release.grafana.name
}

output "grafana_port_forward_command" {
  description = "Port-forward command to access Grafana at http://localhost:3000"
  value       = "kubectl port-forward svc/${var.grafana_release_name} 3000:80 -n ${var.namespace}"
}

output "prometheus_port_forward_command" {
  description = "Port-forward command to access Prometheus at http://localhost:9090"
  value       = "kubectl port-forward svc/${var.prometheus_release_name}-server 9090:80 -n ${var.namespace}"
}

output "grafana_admin_password_command" {
  description = "Command to retrieve the Grafana admin password from the Kubernetes secret"
  value       = "kubectl get secret --namespace ${var.namespace} ${var.grafana_release_name} -o jsonpath='{.data.admin-password}' | base64 --decode"
}
