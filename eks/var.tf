variable "cluster_name" {
  type        = string
  description = "Cluster Name"
  default     = "Mattermost"
}

variable "cluster_version" {
  type        = number
  description = "Cluster Version"
  default     = "1.29"
}

variable "cluster_vpc_id" {
  type        = string
  description = "Cluster VPC_ID"
  default     = ""
}

variable "cluster_subnet_ids" {
  type        = list(string)
  description = "Private and Public Subset IDs for Cluster Nodegroups and Load Balancers"
  default     = ["","","",
                 "","",""]
  
}

variable "cluster_private_subnet_ids" {
  type        = list(string)
  description = "Private and Public Subset IDs for Cluster Nodegroups and Load Balancers"
  default     = ["","",""]
  
}

variable "cluster_public_subnet_ids" {
  type        = list(string)
  description = "Public Subset IDs for Cluster Nodegroups and Load Balancers"
  default     = ["","",""]
  
}
variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Set to true to enable public access for the EKS Cluster"
  default     = true
}

variable "irsa" {
  type        = bool
  description = "Set to true to enable service accounts for EBS, Application Load Balancer, etc..."
  default     = true
}

variable "coredns" {
  type        = bool
  description = "Set to true to install coredns addon"
  default     = true
}

variable "vpc_cni" {
  type        = bool
  description = "Set to true to install VPC-CNI addon"
  default     = true
}

variable "kube_proxy" {
  type        = bool
  description = "Set to true to install kube_proxy addon"
  default     = true
}

variable "aws-ebs-csi-driver" {
  type        = bool
  description = "Set to true to install AWS EBS CSI Driver addon"
  default     = true
} 

variable "aws-efs-csi-driver" {
  type        = bool
  description = "Set to true to install AWS EBS CSI Driver addon"
  default     = true
}

variable "aws-load-balancer-controller" {
  type        = bool
  description = "Set to true to install aws-load-balancer-controller addon"
  default     = true
}

#Managed NodeGroup
variable "instance_types" {
  type        = list(string)
  description = "Instance types for Managed Node Group"
  default     = ["t3.medium", "t3.medium", "t3.medium"]
}

variable "ebs_optimized" {
  type        = bool
  description = "Set to true to attach an ebs volume to instances"
  default     = true
}

variable "use_custom_launch_template" {
  type        = bool
  description = "Set to false to use remote key"
  default     = false
}

variable "disk_size" {
  type        = number
  description = "EBS Volume size to attach to Nodes"
  default     = 20
}

variable "min_size" {
  type        = number
  description = "Mininum number of instances required"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances required"
  default     = 3
}

variable "desired_size" {
  type        = number
  description = "Desired number of instances"
  default     = 2
}

variable "max_unavailable" {
  type        = number
  description = "Max number of unavailable instances allowed"
  default     = 1
}

variable "key_name" {
  type        = string
  description = "ssh key name for Nodegroups"
  default     = "pipeline"
}



