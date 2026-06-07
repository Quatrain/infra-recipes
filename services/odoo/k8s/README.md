# Odoo Kubernetes Stack

Generic Odoo 16 module for Kubernetes.

## Components

- **Odoo App**: Official Odoo 16.0 image.
- **Database**: PostgreSQL 15.
- **Addons**: Mount point for extra addons at `/mnt/extra-addons`.
- **Ingress**: Traefik IngressRoute with Let's Encrypt support.

## Configuration

- `admin_passwd`: Set via ConfigMap or Secret.
- `db_name`: Pre-configured database.
- `addons_path`: Custom paths for extra addons.
