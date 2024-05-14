resource "helm_release" "mattermost" {
  name       = "mattermost"
  namespace = "mattermost"
  repository = "https://helm.mattermost.com"
  chart      = "mattermost-team-edition"

  values = [
    "${file("mattermost-values.yml")}"
  ]
}

#ref: https://github.com/mattermost/mattermost-helm/blob/master/README.md

