# Mattermost Kubernetes Stack

Generic Mattermost Team Edition module for Kubernetes.

## Components

- **Mattermost App**: Official Team Edition image.
- **Database**: PostgreSQL 15.
- **Ingress**: Traefik IngressRoute with Let's Encrypt support.

## Storage
- `mattermost-data-pvc`: For file uploads and user content.
- `mattermost-db-pvc`: For PostgreSQL data.
- Config is kept ephemeral (`emptyDir`) as all settings are injected via ENV variables.
