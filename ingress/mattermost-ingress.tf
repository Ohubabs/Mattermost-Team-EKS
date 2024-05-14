/*resource "kubernetes_ingress_v1" "mattermost-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "mattermost-ingress"
    namespace = "mattermost"
    annotations = {
        "alb.ingress.kubernetes.io/load-balancer-name" = "mattermost-1"
        "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
        "alb.ingress.kubernetes.io/target-type"        = "ip"                                     
        "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:us-east-2:083772204804:certificate/817e3cbf-a40d-4c9d-a1f1-0acff35ad9c1"
  }
  }
  spec {
    ingress_class_name = "alb"
    default_backend {
      service {
        name = "mattermost-team-edition"
        port {
          number = 80
        }
      }
    }
    rule {
      host = "mattermost.devopsnetwork.net"  
      http {
        path {
          path = "/"
          path_type = "Exact"
          backend {
            service {
              name = "mattermost-team-edition"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}*/

resource "kubernetes_ingress_v1" "matter-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "matter"
    namespace = "mattermost"
    annotations = {
        "cert-manager.io/cluster-issuer" = "matter-issuer"
  }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      secret_name = "matter-secret"
      hosts = ["matter.devopsnetwork.net"] 
    }
    rule {
      host = "matter.devopsnetwork.net"  
      http {
        path {
          path = "/"
          backend {
            service {
              name = "mattermost-team-edition"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}