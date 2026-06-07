# Global Infrastructure HOWTO

Common operations for managing infrastructure recipes.

## 🛠 Prerequisites

- `terraform` CLI.
- `kubectl` configured with your cluster context.
- `scw` CLI for managing Scaleway resources if needed.

## 🚀 Standard Deployment Flow

For any service in this repo:

1. `cd` into the service directory (e.g., `services/traefik/k8s`).
2. Run `terraform init` (only the first time).
3. Run `terraform plan` to preview changes.
4. Run `terraform apply` to commit changes to the cluster.

## 🔍 Troubleshooting

### Resource Eviction
If pods show `Evicted`, check the node memory pressure:
```bash
kubectl top nodes
```
The recipes include resource limits to mitigate this.

### Volume Attachment Errors
If a pod is stuck in `ContainerCreating` due to `Multi-Attach error`, ensure the previous pod is fully terminated or the deployment strategy is set to `Recreate`.

### SSL Issues
Check Traefik logs for ACME errors:
```bash
kubectl logs -n traefik -l app.kubernetes.io/name=traefik
```
Verify that the DNS for the domain points to the LoadBalancer IP.
