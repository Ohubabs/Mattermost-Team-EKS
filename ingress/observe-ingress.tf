resource "kubernetes_ingress_v1" "observe" {
  wait_for_load_balancer = true
  metadata {
    name = "observe"
    namespace = "monitor"
    annotations = {
        "cert-manager.io/cluster-issuer" = "observe-issuer"
  }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      secret_name = "observe-secret"
      hosts = ["matter-monitor.devopsnetwork.net","matter-dashboard.devopsnetwork.net"] 
    }
    rule {
      host = "matter-monitor.devopsnetwork.net"  
      http {
        path {
          path = "/"
          backend {
            service {
              name = "prometheus-server"
              port {
                number = 443
              }
            }
          }
        }
      }
    }
    rule {
      host = "matter-dashboard.devopsnetwork.net"  
      http {
        path {
          path = "/"
          backend {
            service {
              name = "grafana"
              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }
}