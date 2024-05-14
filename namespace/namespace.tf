resource "kubernetes_namespace_v1" "mattermost-namespace" {
  metadata {
    name = "mattermost"
  }
}

resource "kubernetes_namespace_v1" "cert-namespace" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace_v1" "monitor" {
  metadata {
    name = "monitor"
  }
}









