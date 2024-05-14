resource "kubernetes_secret_v1" "aws-auth" {
  metadata {
    name = "konoha"
    namespace = "cert-manager"
  }

  data = {
    ichiraku = var.ichiraku
    ramen = var.ramen
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "graf-auth" {
  metadata {
    name = "food"
    namespace = "apm"
  }

  data = {
    spicy = var.spicy
    noodles = var.noodles
  }

  type = "Opaque"
} 