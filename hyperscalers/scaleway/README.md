# Scaleway Cloud Integration

This directory contains resources and documentation for integrating Scaleway services into your infrastructure recipes. Scaleway is a European cloud provider offering a wide range of services, including managed Kubernetes (Kapsule) and Block Storage.

## 🚀 Scaleway CLI (`scw`)

The `scw` CLI is the primary tool for managing Scaleway resources from the command line.

### Installation

#### macOS (Homebrew)
```bash
brew install scw
```

#### Linux / WSL
```bash
curl -s https://raw.githubusercontent.com/scaleway/scaleway-cli/master/scripts/get.sh | sh
```

### Configuration

Once installed, initialize your environment by running:
```bash
scw init
```
You will need your **Access Key**, **Secret Key**, and **Organization ID** available in the Scaleway Console under the "IAM" section.

---

## 🛠 Scaleway Key Features for Kubernetes

### 1. Kapsule (Managed Kubernetes)
Scaleway Kapsule provides a fully managed Kubernetes environment. When deploying to Kapsule, ensure your `kubeconfig` is correctly set up:
```bash
scw k8s kubeconfig get cluster-id=<your-cluster-id> > ~/.kube/config
```

### 2. Scaleway Block Storage (SBS)
SBS provides persistent storage volumes that can be attached to your Kubernetes nodes.
- **StorageClass**: Use `sbs-default` for standard block storage.
- **Access Mode**: Most SBS volumes support `ReadWriteOnce` (RWO), meaning they can only be mounted by one node at a time.
- **Dynamic Provisioning**: Volumes are automatically provisioned when a `PersistentVolumeClaim` (PVC) is created with the appropriate storage class.

### 3. Load Balancer Integration
When a Kubernetes Service of type `LoadBalancer` is created, Scaleway automatically provisions a physical Load Balancer and assigns a public IP address to it.

---

## 🔍 Common Maintenance Commands

### Storage Management
```bash
# List all active block volumes
scw block volume list

# Create a manual snapshot of a volume
scw block snapshot create volume-id=<volume-id> name=<snapshot-name>
```

### Cluster Operations
```bash
# List all Kubernetes clusters in the current region
scw k8s cluster list

# View details of a specific cluster
scw k8s cluster get cluster-id=<cluster-id>
```

For more detailed information, refer to the [official Scaleway documentation](https://www.scaleway.com/en/docs/).
