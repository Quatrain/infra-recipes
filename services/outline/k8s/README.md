# Outline Kubernetes Stack

Generic Outline Knowledge Base module for Kubernetes.

## Components

- **Outline App**: Official Outline image.
- **Database**: PostgreSQL 15.
- **Cache**: Redis 7.
- **Storage**: MinIO for S3-compatible object storage.
- **Ingress**: Traefik IngressRoutes for Outline and MinIO with Let's Encrypt support.

## Configuration

Outline requires a Single Sign-On (SSO) provider to function. This recipe uses Google OAuth by default.
- `google_client_id` & `google_client_secret`: Your Google OAuth credentials.
- `secret_key` & `utils_secret`: Random 32-byte hex strings.
- `s3_domain`: A separate sub-domain for the MinIO API to serve images and attachments.
