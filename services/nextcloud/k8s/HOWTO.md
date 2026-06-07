# How to Deploy Nextcloud on K8s

Follow these steps to deploy or update the Nextcloud stack.

## 1. Prerequisites

- A running Kubernetes cluster (Kapsule).
- Traefik installed and configured with an ACME resolver named `myresolver`.
- `terraform` CLI installed.

## 2. Configuration

Edit `variables.tf` or create a `terraform.tfvars` file to customize your deployment:

```hcl
domain      = "cloud.example.com"
db_password = "your-secure-password"
```

## 3. Deployment

```bash
# Initialize the workspace
terraform init

# Review changes
terraform plan

# Apply deployment
terraform apply
```

## 4. Post-Deployment

### Data Migration (if needed)
If migrating from an existing instance, use `kubectl cp` or `rsync` to transfer data into the `nextcloud-main-pvc`.

### Verification
Check the pod status:
```bash
kubectl get pods -n nextcloud
```

### Email Settings
Once logged in, go to **Administration settings > Basic settings** and send a test email to verify the SMTP configuration.
