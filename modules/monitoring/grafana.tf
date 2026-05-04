resource "helm_release" "grafana" {
  name             = var.grafana_release_name
  namespace        = var.namespace
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = var.grafana_chart_version
  create_namespace = true
  timeout          = 1800

  set_sensitive {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }

  values = [
    yamlencode({
      resources = {
        requests = { cpu = "50m", memory = "128Mi" }
        limits   = { cpu = "200m", memory = "256Mi" }
      }
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://${var.prometheus_release_name}-server.${var.namespace}.svc:80"
              access    = "proxy"
              isDefault = true
            }
          ]
        }
      }
      dashboardProviders = {
        "dashboardproviders.yaml" = {
          apiVersion = 1
          providers = [
            {
              name            = "default"
              orgId           = 1
              folder          = ""
              type            = "file"
              disableDeletion = false
              editable        = true
              options         = { path = "/var/lib/grafana/dashboards/default" }
            }
          ]
        }
      }
      dashboards = {
        default = {
          node-exporter = {
            gnetId     = 1860
            revision   = 37
            datasource = "Prometheus"
          }
        }
      }
    })
  ]

  depends_on = [helm_release.prometheus]
}
