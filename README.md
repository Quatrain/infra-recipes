# Infrastructure Recipes

This repository contains generic Infrastructure as Code (IaC) recipes for deploying various services.

## Repository Structure

```
infra/
├── hyperscalers/
│   └── scaleway/    # Scaleway specific documentation & CLI
└── services/        # Service-specific recipes
    ├── nextcloud/
    │   └── k8s/     # Nextcloud Kubernetes Deployment
    ├── odoo/
    │   └── k8s/     # Odoo Kubernetes Deployment
    └── traefik/
        └── k8s/     # Traefik Ingress Controller & SSL
```

## General Principles

1. **Kubernetes First**: Production workloads are designed for Kubernetes (e.g., Scaleway Kapsule).
2. **Persistence**: Data persistence is handled via Cloud Block Storage (e.g., Scaleway SBS).
3. **Security**: SSL is automated via Ingress Controllers (e.g., Traefik) and Let's Encrypt.
4. **Maintenance**: Recipes use Terraform to ensure reproducibility and consistency.
