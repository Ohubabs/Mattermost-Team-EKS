resource "kubernetes_storage_class" "mattermost-sc" {
  metadata {
    name = "mattermost-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "Immediate"
  parameters = {
    type = "gp2"
  }
}

resource "kubernetes_storage_class" "mysql-sc" {
  metadata {
    name = "mysql-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "Immediate"
  parameters = {
    type = "gp2"
  }
}