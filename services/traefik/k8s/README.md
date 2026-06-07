# Traefik Ingress Controller (BRAD2026)

This Terraform recipe deploys and configures Traefik v3.5 as the primary Ingress Controller for the cluster.

## Key Components

- **Traefik Deployment**: Single replica optimized for Scaleway.
- **ACME Persistence**: Dedicated 1Gi volume for `acme.json`.
- **Dashboard**: Web UI exposed securely with Basic Auth and SSL.
- **SSL Resolver**: HTTP-01 challenge configured with Let's Encrypt.

## Design Choices

- **Permissions**: Includes a non-root `initContainer` to fix `acme.json` file permissions (600).
- **Stability**: Resource limits applied to ensure high availability.
- **Security**: Basic Auth middleware protects the dashboard.
