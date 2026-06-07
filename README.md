# BRAD2026 Infrastructure

This repository contains the Infrastructure as Code (IaC) recipes for the BRAD2026 project.

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

1. **Kubernetes First**: Main production workloads run on Scaleway Kapsule.
2. **Persistence**: All data is stored on Scaleway Block Storage (`sbs-default`).
3. **Security**: SSL is automated via Traefik and Let's Encrypt.
4. **Maintenance**: Recipes use Terraform to ensure reproducibility and consistency.
