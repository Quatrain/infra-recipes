# How to Deploy Traefik

Detailed guide to setting up Traefik Ingress with automated SSL.

## 1. Initial Setup

Ensure your Kubernetes context is correct:
```bash
kubectl config current-context
```

## 2. Configuration

Update `variables.tf` with your specific details:
- `acme_email`: Your email for Let's Encrypt notifications.
- `dashboard_domain`: The domain to access the Traefik UI.
- `dashboard_auth_users`: Hashed credentials for Basic Auth.

## 3. Deployment

```bash
terraform init
terraform apply
```

## 4. Post-Deployment Verification

### Load Balancer IP
Retrieve the external IP:
```bash
terraform output traefik_lb_ip
```
Update your DNS A records to point to this IP.

### Dashboard Access
Visit `https://your-dashboard-domain` and login with your Basic Auth credentials.

### SSL Status
Check Traefik logs to confirm ACME registration:
```bash
kubectl logs -l app.kubernetes.io/name=traefik -n traefik
```
Look for: `Register... providerName=myresolver.acme`.
