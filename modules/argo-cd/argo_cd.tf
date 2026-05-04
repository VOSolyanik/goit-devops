resource "helm_release" "argo_cd" {
  name             = var.name
  namespace        = var.namespace
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  create_namespace = true
  timeout          = 1800

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "argo_apps" {
  name             = "${var.name}-apps"
  chart            = "${path.module}/charts"
  namespace        = var.namespace
  create_namespace = false
  timeout          = 1800

  values = [
    yamlencode({
      applications = [
        {
          name      = var.application_name
          namespace = var.application_namespace
          project   = var.project
          source = {
            repoURL        = var.gitops_repo_url
            path           = var.gitops_chart_path
            targetRevision = var.gitops_target_revision
            helm = {
              valueFiles = ["values.yaml"]
              values = yamlencode({
                config = {
                  POSTGRES_HOST = var.rds_endpoint
                  POSTGRES_USER = var.rds_username
                  POSTGRES_DB   = var.rds_db_name
                }
                secrets = {
                  postgresPassword = var.rds_password
                }
              })
            }
          }
          destination = {
            server    = "https://kubernetes.default.svc"
            namespace = var.application_namespace
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeal = true
            }
          }
        }
      ]
      repositories = [
        {
          name = var.application_name
          url  = var.gitops_repo_url
        }
      ]
    })
  ]

  depends_on = [helm_release.argo_cd]
}
