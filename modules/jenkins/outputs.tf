output "jenkins_release_name" {
  description = "Jenkins Helm release name"
  value       = helm_release.jenkins.name
}

output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = helm_release.jenkins.namespace
}

output "jenkins_service_account" {
  description = "Service account used by Jenkins"
  value       = kubernetes_service_account.jenkins_sa.metadata[0].name
}
