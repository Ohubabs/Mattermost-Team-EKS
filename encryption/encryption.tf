resource "helm_release" "cert-manger" {
  name       = "cert-manager"
  create_namespace = true
  namespace = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name = "installCRDs"
    value = true
  }

  set {
    name = "serviceAccount.annotations.eks\\amazonaws\\.com\\/role-arn"
    value = "arn:aws:iam::083772204804:role/Mattermost-cert-manager"
  }
}


