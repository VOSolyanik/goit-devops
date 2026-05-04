resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  namespace        = "kube-system"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = "3.12.2"
  create_namespace = false
  timeout          = 300

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}
