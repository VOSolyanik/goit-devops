resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = var.storage_class_name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type = "gp3"
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = var.namespace
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = var.chart_version
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

  set_sensitive {
    name  = "controller.admin.username"
    value = local.jenkins_admin["username"]
  }

  set_sensitive {
    name  = "controller.admin.password"
    value = local.jenkins_admin["password"]
  }

  depends_on = [
    kubernetes_storage_class_v1.ebs_sc,
    kubernetes_service_account.jenkins_sa
  ]
}
