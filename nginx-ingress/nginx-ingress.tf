resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  create_namespace = true
  namespace = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  
  values = [
    "${file("nginx-values.yml")}"
  ]

}
#https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
#https://aws.amazon.com/blogs/containers/exposing-kubernetes-applications-part-3-nginx-ingress-controller/
#--set controller.ingressClassResource.default=true
#Not supported on Fargate