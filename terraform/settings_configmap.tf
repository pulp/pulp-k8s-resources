resource "kubernetes_config_map" "settings_cm" {
  count = var.deploy_settings_cm ? 1 : 0
  metadata {
    name = "settings"
    namespace = var.namespace
  }

  data = {
    TELEMETRY = "False"
  }
}