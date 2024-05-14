resource "helm_release" "alb" {
  name       = "alb"
  create_namespace = true
  namespace  = "alb"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  values = [
    "${file("alb-values.yml")}"
  ]

  set {
    name = "clusterName"
    value = "Mattermost" 
  }
}

#module.load_balancer_controller_irsa_role.aws_iam_policy.load_balancer_controller.id create an output for this
#Fargate does not work well with ALB and nginx ingress controllers so launch with managed node groups
#To sync ALB with cert-manager you might need to make a certificate on the console, then use an annotation to 
#refernce the certificate arn which ALB tls will use. For this reason, it may be better to use NLB.
