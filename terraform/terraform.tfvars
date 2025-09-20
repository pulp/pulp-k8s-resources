namespace = "test"
service_account = "pulp-test"
operator_image = "quay.io/pulp/pulp-operator:v1.0.0"

# Resource configuration for the pulp operator
resources = {
  limits = {
    cpu = "500m"
    memory = "128Mi"
  }
  requests = {
    cpu = "10m"
    memory = "64Mi"
  }
}

# Node selector constraints (empty by default)
node_selector = {}

# Affinity constraints (empty by default)
affinity = {}

# Tolerations (empty by default)
tolerations = []