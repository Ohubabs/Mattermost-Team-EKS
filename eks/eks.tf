#https://antonputra.com/amazon/create-aws-eks-fargate-using-terraform/#deploy-app-to-aws-fargate
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  enable_irsa = var.irsa
  cluster_addons = { #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon
    coredns = {
      most_recent = var.coredns
      timeouts = {
        create = "15m"
        delete = "15m"
      } 
    }
    kube-proxy = {
      most_recent = var.kube_proxy
    }
    vpc-cni = {
      most_recent = var.vpc_cni
      service_account_role_arn = module.vpc_cni.iam_role_arn
    }
    aws-ebs-csi-driver = { 
      most_recent = var.aws-ebs-csi-driver #Required to install EBS CSI Driver needed for provisioning EBS volumes for persistent volume storage config. This is also tied to the service account created separately
      service_account_role_arn = module.ebs_csi_role.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    Mattermost = {
      Name = "matter"
      instance_types = var.instance_types
      subnet_ids = module.vpc.public_subnets
      ebs_optimized = var.ebs_optimized
      disk_size = var.disk_size
      use_custom_launch_template = var.use_custom_launch_template
      remote_access = {
                        ec2_ssh_key  = var.key_name
                      }

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
      update_config = {
                        max_unavailable = var.max_unavailable
                      }
    }
  }

  enable_cluster_creator_admin_permissions = true
  
  tags = {
    "kubernetes.io/cluster/Mattermost" = "owned"
     name = "kubernetes.io/cluster/Mattermost"
  }
}

