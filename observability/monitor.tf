resource "helm_release" "prometheus" {
  name       = "prometheus"
  create_namespace = true
  namespace  = "monitor"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  values = [
    "${file("prom-values.yml")}"
  ]
}

#Ref: https://developer.hashicorp.com/terraform/tutorials/kubernetes/helm-provider
#https://github.com/dmeiners88/sonarqube-prometheus-exporter

resource "helm_release" "grafana" {
  name       = "grafana"
  create_namespace = true
  namespace  = "monitor"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  values = [
    "${file("graf-values.yml")}"
  ]
}