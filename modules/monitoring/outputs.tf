output "monitoring_namespace" {
  description = "Namespace where Prometheus and Grafana are deployed"
  value       = var.namespace
}

output "grafana_port_forward_command" {
  description = "Port-forward command to access Grafana at http://localhost:3000"
  value       = "kubectl port-forward svc/grafana 3000:80 -n ${var.namespace}"
}

output "prometheus_port_forward_command" {
  description = "Port-forward command to access Prometheus at http://localhost:9090"
  value       = "kubectl port-forward svc/prometheus-server 9090:80 -n ${var.namespace}"
}
