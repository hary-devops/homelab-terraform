# GCP VM Instance with Monitoring & Alerts

This Terraform configuration creates a complete GCP infrastructure with VM instance, monitoring, and alerting capabilities.

## Infrastructure Components

- **Custom VPC Network**: Non-default VPC for better network isolation
- **Subnet**: Regional subnet with private Google access enabled
- **Firewall Rules**: SSH access and internal traffic allowed
- **VM Instance**: Compute instance with specified resources
- **Cloud Monitoring**: Comprehensive monitoring and alerting system
- **Email Notifications**: Critical alerts sent to specified email address
- **Cloud Ops Agent**: Automatic installation for enhanced metrics collection

## VM Specifications

- **vCPU**: 2 cores (e2-medium machine type)
- **Memory**: 4 GB RAM
- **Disk**: 20 GB SSD persistent disk
## Monitoring & Alerting

### Alert Policies (Best Practice Thresholds)

**CPU Monitoring:**
- ⚠️ Warning: ≥70% for 5 minutes
- 🚨 Critical: ≥85% for 5 minutes

**Memory Monitoring:**
- ⚠️ Warning: ≥75% for 5 minutes
- 🚨 Critical: ≥90% for 5 minutes
## Setup Instructions

### 1. Create GCP Service Account

```bash
# Set your project ID
PROJECT_ID="your-project-id"

# Create service account
gcloud iam service-accounts create terraform-cloud \
  --display-name="Terraform Cloud Service Account" \
  --project=${PROJECT_ID}

# Grant required roles
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:terraform-cloud@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:terraform-cloud@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:terraform-cloud@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/monitoring.admin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
Edit `terraform.tfvars` and set:

```hcl
project_id     = "your-gcp-project-id"
region         = "asia-southeast2"  # Jakarta or asia-southeast1 for Singapore
zone           = "asia-southeast2-a"
instance_name  = "homelab-vm"
alert_email    = "your-email@example.com"  # REQUIRED for monitoring alerts
ssh_public_key = "ssh-rsa AAAAB3NzaC... your-key-here"
```

**Required Variables:**
- `project_id`: Your GCP project ID
- `alert_email`: Email address for monitoring alerts (you'll receive a verification email)
- `region`: `asia-southeast1` (Singapore) or `asia-southeast2` (Jakarta)
- `zone`: Choose appropriate zone for your region
- `ssh_public_key`: Your SSH public key for instance accessccount.com
```

### 2. Configure Authentication

**For Terraform Cloud:**
1. Go to your workspace in [Terraform Cloud](https://app.terraform.io/)
2. Navigate to **Variables**
3. Add environment variable:
   - Key: `GOOGLE_CREDENTIALS`
   - Value: Contents of `terraform-cloud-key.json`
   - Mark as **Sensitive**

**For Local Development:**
- 🚨 Instance Down: VM not running

### Email Notifications

All alerts are sent to the configured email address with:
- Alert severity and description
- Metric values and thresholds
- Direct link to GCP Console
- Auto-resolve notifications

## Prerequisites

1. GCP account with billing enabled
2. GCP project created
3. Service account with required IAM roles:
   - `Compute Admin` (roles/compute.admin)
### 4. Deploy Infrastructure

```bash
# Navigate to the GCP environment
cd environment/gcp

# Initialize Terraform
terraform init

# Review the planned changes
terraform plan

# Apply the configuration
terraform apply
```

### 5. Verify Monitoring Setup

After deployment:

1. **Check email**: You'll receive a verification email from Google Cloud Monitoring. Click the verification link.

2. **View monitoring dashboard**:
```bash
terraform output monitoring_dashboard_url
```

3. **Test alerts** (optional):
```bash
# SSH to instance
ssh admin@$(terraform output -raw instance_public_ip)

# Simulate high CPU usage
stress-ng --cpu 2 --timeout 360s

## Connecting to the Instance

After deployment, get the connection command:

```bash
terraform output ssh_command
```

Or manually connect:

```bash
ssh admin@<instance-public-ip>
```

### View Monitoring Metrics

Once connected to the instance:

```bash
# Check if Cloud Ops Agent is running
sudo systemctl status google-cloud-ops-agent

# View CPU usage
top

# View memory usage
free -h

# View disk usage
df -h

# View disk I/O
iostat -x 1
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

## Cost Estimation

The e2-medium instance in asia-southeast2 (Jakarta) costs approximately:

- **Compute**: ~$24-30/month (730 hours)
- **Storage**: ~$0.80/month (20 GB standard persistent disk)
- **Monitoring**: Free tier includes:
  - 150 MB of logs ingestion per month
  - 10 alert policies
  - 100 notification channels
  - Cloud Ops Agent metrics (free)
- **Network**: Egress charges apply based on usage
- **Total**: ~$25-31/month (assuming free tier monitoring)

Note: Costs may vary by region and actual usage. Singapore region (asia-southeast1) has similar pricing.
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
And add `"web"` to the instance tags.

## Files Overview

- **`main.tf`**: VPC, subnet, firewall rules, and VM instance
- **`monitoring.tf`**: Alert policies and notification channels
- **`apis.tf`**: Automatic API enablement
- **`provider.tf`**: Google Cloud provider configuration
- **`variables.tf`**: Input variables with defaults
- **`outputs.tf`**: Output values (IPs, SSH command, dashboard URL)
- **`terraform.tfvars.example`**: Example configuration file

## What Gets Created

Running `terraform apply` creates:

**Network Resources:**
- 1 VPC network
- 1 subnet
- 2 firewall rules

**Compute Resources:**
- 1 VM instance (e2-medium)
- 1 persistent disk (20GB)

**Monitoring Resources:**
- 1 email notification channel
- 9 alert policies (CPU, Memory, Disk, Instance health)

**APIs Enabled:**
- Compute Engine API
- Cloud Monitoring API
- Cloud Pub/Sub API
- Service Usage API
- Cloud Resource Manager API

## Monitoring Best Practices

1. **Review alerts regularly**: Check GCP Console for alert history
2. **Tune thresholds**: Adjust based on your application's normal behavior
3. **Add more alerts**: Consider network, application-specific metrics
4. **Create dashboards**: Visualize metrics in GCP Monitoring
5. **Set up escalation**: Configure multiple notification channels
6. **Document incidents**: Keep track of alert patterns

## Next Steps

After successful deployment:

1. ✅ Configure additional monitoring dashboards
2. ✅ Set up log-based alerts
3. ✅ Configure uptime checks
4. ✅ Add application-specific monitoring
5. ✅ Set up budget alerts
6. ✅ Configure backup policies
7. ✅ Implement infrastructure as code best practices

## Troubleshooting

### API Not Enabled Error

The Terraform configuration automatically enables all required APIs. If you encounter API errors, wait 1-2 minutes for APIs to fully activate, then retry:

```bash
terraform apply
```

### Permission Denied (403) Error

Ensure your service account has all required roles:

```bash
# Check current IAM bindings
gcloud projects get-iam-policy YOUR_PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:terraform-cloud@*"
```

Required roles:
- `roles/compute.admin`
- `roles/iam.serviceAccountUser`
- `roles/monitoring.admin`
- `roles/monitoring.notificationChannelEditor`

### Not Receiving Alert Emails

1. **Check email verification**: Look for verification email from Google Cloud Monitoring
2. **Check spam folder**: Alerts might be filtered
3. **Verify email address**: Check `terraform.tfvars` for correct email
4. **Check notification channel**:
```bash
gcloud alpha monitoring channels list --project=YOUR_PROJECT_ID
```

### Cloud Ops Agent Not Installed

If monitoring metrics aren't appearing:

1. SSH to instance
2. Check agent status:
```bash
sudo systemctl status google-cloud-ops-agent
```

3. Manually install if needed:
```bash
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

### Quota Exceeded

Check your project quotas in GCP Console and request increases if needed.

### SSH Connection Issues

Ensure your SSH public key is properly configured and firewall rules allow SSH access.

### Alert Not Triggering

Alert policies have durations:
- CPU/Memory warnings: 5 minutes sustained
- CPU/Memory critical: 5 minutes sustained
- Disk I/O: 5 minutes sustained

Wait for the full duration before expecting alerts.
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
