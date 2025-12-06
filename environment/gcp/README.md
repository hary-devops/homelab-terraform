# GCP VM Instance Configuration

This Terraform configuration creates a GCP VM instance with the following specifications:

## Infrastructure Components

- **Custom VPC Network**: Non-default VPC for better network isolation
- **Subnet**: Regional subnet with private Google access enabled
- **Firewall Rules**: SSH access and internal traffic allowed
- **VM Instance**: Compute instance with specified resources

## VM Specifications

- **vCPU**: 2 cores (e2-medium machine type)
- **Memory**: 4 GB RAM
- **Disk**: 20 GB SSD persistent disk
- **OS**: Ubuntu 22.04 LTS (configurable to Debian or CentOS)
- **Region**: Singapore (asia-southeast1) or Jakarta (asia-southeast2)

## Prerequisites

1. GCP account with billing enabled
2. GCP project created
3. Required APIs enabled:
   - Compute Engine API
   - Cloud Resource Manager API

## Setup Instructions

### 1. Enable Required APIs

```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### 2. Configure Authentication

```bash
# Option 1: Using gcloud CLI
gcloud auth application-default login

# Option 2: Using service account
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
```

### 3. Configure Variables

Copy the example file and update with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set:

- `project_id`: Your GCP project ID
- `region`: Choose `asia-southeast1` (Singapore) or `asia-southeast2` (Jakarta)
- `zone`: Choose appropriate zone for your region
- `ssh_public_key`: Your SSH public key for instance access

### 4. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the configuration
terraform apply
```

## OS Image Options

The configuration supports multiple Linux distributions:

- **Ubuntu**: `ubuntu-os-cloud/ubuntu-2204-lts` (default)
- **Debian**: `debian-cloud/debian-12`
- **CentOS**: `centos-cloud/centos-stream-9`

Change the `os_image` variable in `terraform.tfvars` to use a different OS.

## Region Options

### Singapore (asia-southeast1)

- Zone: `asia-southeast1-a`, `asia-southeast1-b`, `asia-southeast1-c`
- Lower latency for Southeast Asian users

### Jakarta (asia-southeast2)

- Zone: `asia-southeast2-a`, `asia-southeast2-b`, `asia-southeast2-c`
- Data residency in Indonesia

## Connecting to the Instance

After deployment, get the connection command:

```bash
terraform output ssh_command
```

Or manually connect:

```bash
ssh admin@<instance-public-ip>
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Cost Estimation

The e2-medium instance in asia-southeast1 costs approximately:

- Compute: ~$24-30/month (730 hours)
- Storage: ~$0.80/month (20 GB standard persistent disk)
- **Total**: ~$25-31/month

Note: Costs may vary by region and actual usage.

## Security Considerations

1. **SSH Access**: Currently allows SSH from anywhere (0.0.0.0/0). Consider restricting to specific IP ranges.
2. **Service Account**: Consider creating a custom service account with minimal permissions.
3. **Firewall Rules**: Review and adjust based on your security requirements.
4. **SSH Keys**: Use strong SSH keys and rotate them regularly.

## Customization

### Adding HTTP/HTTPS Access

Add to `main.tf`:

```hcl
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-https"
  network = google_compute_network.custom_vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
```

And add `"web"` to the instance tags.

## Troubleshooting

### API Not Enabled Error

Enable the required API in GCP Console or using gcloud CLI.

### Quota Exceeded

Check your project quotas in GCP Console and request increases if needed.

### SSH Connection Issues

Ensure your SSH public key is properly configured and firewall rules allow SSH access.
