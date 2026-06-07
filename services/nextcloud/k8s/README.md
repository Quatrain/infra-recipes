# Nextcloud Kubernetes Stack

This Terraform recipe deploys a full Nextcloud instance on Kubernetes, optimized for Scaleway Block Storage (SBS) and Traefik Ingress.

## Architecture

- **Nextcloud App**: Apache-based image with integrated PHP.
- **Database**: MySQL 8.0 with `mysql_native_password` compatibility.
- **Cache**: Redis for session handling and file locking (password protected).
- **Ingress**: Traefik `IngressRoute` with automated Let's Encrypt SSL.
- **Storage**: Scaleway SBS (`sbs-default`) for data persistence.

## Features

- **Automated SSL**: Integrated with Traefik's ACME resolver.
- **Clean URLs**: Automatic removal of `index.php` via Traefik Middlewares.
- **Resource Management**: Pre-defined CPU/RAM limits to prevent pod evictions.
- **Safe Rollouts**: `Recreate` strategy for proper volume management.
