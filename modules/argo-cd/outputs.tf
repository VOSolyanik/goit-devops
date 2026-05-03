output "argo_cd_namespace" {
  description = "Namespace where Argo CD is deployed"
  value       = helm_release.argo_cd.namespace
}

output "argo_cd_admin_password_command" {
  description = "Command to fetch the initial Argo CD admin password"
  value       = "kubectl -n ${helm_release.argo_cd.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
}
