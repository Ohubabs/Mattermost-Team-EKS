resource "helm_release" "external-dns" {
  name       = "external-dns"
  create_namespace = true
  namespace = "dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  values = [
    "${file("dns-values.yml")}"
  ]
}