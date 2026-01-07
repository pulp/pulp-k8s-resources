# Pulp K8s Resources

## Pulp Operator Helm Chart

This Helm chart deploys the Pulp Operator and related resources to manage Pulp clusters on Kubernetes.

### Features
- Installs the Pulp Operator and its RBAC resources
- Supports custom namespaces for operator and managed clusters
- Configurable images, resource limits, and security contexts
- Deploys required ServiceAccounts, Roles, RoleBindings, ClusterRoles, and ClusterRoleBindings

### Chart Options
All options can be set in your `values.yaml` or via `--set` on the Helm CLI.

| Value                        | Description                                              | Default                      |
|------------------------------|----------------------------------------------------------|------------------------------|
| `fullnameOverride`           | Override generated resource names                        | `pulp-operator`              |
| `image`                      | Operator container image                                 | `quay.io/pulp/pulp-operator:v1.0.0` |
| `namespace`                  | Namespace for managed Pulp cluster resources             | `pulp`                       |
| `operatorNamespace`          | Namespace for operator resources                         | `.Values.namespace`          |
| `podSecurityContext`         | Pod security context for operator pods                   | See values.yaml              |
| `imagePullSecrets`           | List of image pull secrets                               | See values.yaml              |
| `operator.securityContext`   | Security context for operator container                  | See values.yaml              |
| `operator.resources`         | Resource requests/limits for operator container          | See values.yaml              |
| `operator.relatedImages`     | Images for pulp, pulpWeb, redis, postgres                | See values.yaml              |
| `kubeProxy.image`            | Image for kube-rbac-proxy                                | See values.yaml              |
| `kubeProxy.securityContext`  | Security context for kube-rbac-proxy                     | See values.yaml              |
| `kubeProxy.resources`        | Resource requests/limits for kube-rbac-proxy             | See values.yaml              |

#### Installation

1. Create the target namespaces (or use `--create-namespace`):
   ```sh
   kubectl create namespace <operatorNamespace>
   kubectl create namespace <namespace>
   # Or let Helm create them:
   helm install <release> ./helm-charts/chart -n <operatorNamespace> --create-namespace -f my-values.yaml
   ```

2. Install the chart:
   ```sh
   helm install <release> ./helm-charts/chart -n <operatorNamespace> --create-namespace -f my-values.yaml
   ```

### Example values.yaml
```yaml
namespace: pulp
operatorNamespace: pulp-operator
image: quay.io/pulp/pulp-operator:v1.0.0
# ...other options...
```

### After Installation
- The operator will be running in `<operatorNamespace>`.
- Managed Pulp resources will be created in `<namespace>`.
- Check the operator manager pod status:
  ```sh
  kubectl get pods -n <operatorNamespace>
  ```
- View operator logs:
  ```sh
  kubectl logs -n <operatorNamespace> deployment/pulp-operator-controller-manager
  ```
- To uninstall:
  ```sh
  helm uninstall <release> -n <operatorNamespace>
  ```

### Deploying a Pulp Cluster

After installing the operator, you must create a Pulp custom resource (CR) to trigger the deployment of a Pulp cluster. Below is a sample manifest based on the official `minimal.yaml` example:

```yaml
---
apiVersion: repo-manager.pulpproject.org/v1
kind: Pulp
metadata:
  name: example-pulp
spec:
  database:
    postgres_storage_class: standard

  file_storage_storage_class: standard
  file_storage_access_mode: "ReadWriteMany"
  file_storage_size: "2Gi"
```

Apply these manifests in your managed namespace (e.g., `dev-pulp`):

```sh
kubectl apply -f <your-manifest>.yaml -n <namespace>
```

For more advanced configuration, see the [upstream samples](https://github.com/pulp/pulp-operator/tree/main/config/samples).

### Customization
- Edit your values file to change images, resource limits, or security settings.
- For advanced configuration (e.g., operator configmap), see chart templates and documentation.

### Support
For issues or questions, open an issue in this repository or see the upstream [Pulp Operator documentation](https://pulpproject.org/pulp-operator/).

## Pulp Operator Terraform Provisioner

The Pulp Operator can be provisioned using Terraform to automate deployment and management of Pulp clusters on Kubernetes. This repository includes example Terraform configurations in the `terraform/` directory.

### Features

- Deploys the Pulp Operator and required RBAC resources
- Provisions namespaces, ConfigMaps, and custom resources for Pulp clusters
- Supports customization via Terraform variables

### Usage

1. Review and update variables in `terraform.tfvars` to match your environment.
2. Initialize Terraform:
  ```sh
  terraform -chdir=terraform init
  ```
3. Apply the configuration:
  ```sh
  terraform -chdir=terraform apply
  ```
4. Terraform will create the necessary namespaces, ConfigMaps, and Pulp custom resources.

### Example

A minimal example is provided in `terraform/pulp-simple.tf` to deploy a basic Pulp cluster. You can customize storage classes, resource sizes, and other options in the variables file.

### Notes

- Ensure your Kubernetes context is set correctly before running Terraform.
- You may need appropriate permissions to create resources in the target cluster.
- For advanced customization, edit the Terraform files or add new resources as needed.

### References

- [Terraform documentation](https://www.terraform.io/docs/)
- [Pulp Operator documentation](https://pulpproject.org/pulp-operator/)
