resource "helm_release" "prometheus" {
  name             = var.prometheus_release_name
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = var.prometheus_chart_version
  create_namespace = true
  timeout          = 1800

  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "server.resources.requests.memory"
    value = "256Mi"
  }
  set {
    name  = "server.resources.limits.cpu"
    value = "300m"
  }
  set {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  }
  set {
    name  = "alertmanager.resources.requests.cpu"
    value = "50m"
  }
  set {
    name  = "alertmanager.resources.requests.memory"
    value = "64Mi"
  }
  set {
    name  = "alertmanager.resources.limits.cpu"
    value = "100m"
  }
  set {
    name  = "alertmanager.resources.limits.memory"
    value = "128Mi"
  }
}
