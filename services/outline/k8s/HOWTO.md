# How to Deploy Outline

Detailed guide to setting up Outline Knowledge Base.

## 1. Prerequisites

- **Google OAuth**: Go to Google Cloud Console, create an OAuth Client ID.
  - Authorized JavaScript origins: `https://<YOUR_DOMAIN>`
  - Authorized redirect URIs: `https://<YOUR_DOMAIN>/auth/google.callback`
- **DNS**: Two domains pointing to your cluster (e.g. `docs.example.com` and `s3-docs.example.com`).

## 2. Configuration

Create your `terraform.tfvars`:
```hcl
domain               = "docs.example.com"
s3_domain            = "s3-docs.example.com"
db_password          = "strong-db-password"
redis_password       = "strong-redis-password"
minio_root_password  = "strong-minio-password"
google_client_id     = "your-client-id"
google_client_secret = "your-client-secret"
secret_key           = "generate-with-openssl-rand-hex-32"
utils_secret         = "generate-with-openssl-rand-hex-32"
```

## 3. Deployment

```bash
terraform init
terraform apply
```

## 4. Post-Deployment

The stack automatically sets up the Postgres database, Redis, and provisions a MinIO bucket named `outline` with public read access. Once deployed, navigate to your domain and log in via Google.
