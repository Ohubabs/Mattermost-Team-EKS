module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0" #old version: 5.1.2
  
  name = "Mattermost_VPC"
  cidr = "10.0.0.0/16"

  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

  public_subnets = ["10.0.4.0/24", "10.0.6.0/24", "10.0.8.0/24"] #Necessary for Load Balancer
  map_public_ip_on_launch = true
  create_igw           = true
  enable_dns_hostnames = true #Required
  enable_dns_support = true #Required
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1 #Necessary for load balancer
  }
  
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] #Recommended for Nodes
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  private_subnet_tags = {
    
    "kubernetes.io/role/internal-elb" = 1
  }

  /*database_subnet_group_name = "mysql-rds-subnets"
  database_subnets = ["10.0.5.0/24", "10.0.7.0/24", "10.0.9.0/24"]

  create_database_subnet_group = true*/
  
  tags = {
    "kubernetes.io/cluster/Mattermost" = "owned"
    "kubernetes.io/cluster/Mattermost" = "shared"
    name = "kubernetes.io/cluster/Mattermost"
  }
}
