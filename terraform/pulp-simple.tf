resource "kubernetes_manifest" "pulp_pulp" {
  count = var.deploy_simple ? 1 : 0
  depends_on = [ kubernetes_manifest.roles ]
  manifest = {
    "apiVersion" = "repo-manager.pulpproject.org/v1"
    "kind" = "Pulp"
    "metadata" = {
      "name" = "pulp"
      "namespace" = var.namespace
    }
    "spec" = {
      "api" = {
        "replicas" = 1
      }
      "content" = {
        "replicas" = 1
      }
      "web" = {
        "replicas" = 1
      }
      "worker" = {
        "replicas" = 1
      }
      #"pulp_settings" = {
      #  "TELEMETRY" = false
      #  "ANALYTICS" = false
      #}
      "custom_pulp_settings" = "settings"
    }
  }
}
