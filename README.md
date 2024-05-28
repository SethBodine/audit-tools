## What is this for?
This is purely a container image that brings together several tools to simplify the auditing of several cloud services.

### Contains...
Currently serveral packages are configured (small list below), check out the [wiki](https://github.com/SethBodine/docker/wiki/) for additional details

| Tool | CLI command | GitHub Commit Age | Wiki URL |
| --- | --- | --- | --- |
| Azure CLI | `az` | ![](https://img.shields.io/github/last-commit/Azure/azure-cli) | [Using az cli ](https://github.com/SethBodine/docker/wiki/Cloud-Authentication-via-CLI#azure) |
| GCP Cli | `gcloud` | | [Using gcloud cli](https://github.com/SethBodine/docker/wiki/Cloud-Authentication-via-CLI#gcp) |
| AWS CLI | `aws` | ![](https://img.shields.io/github/last-commit/aws/aws-cli) | [Using aws cli](https://github.com/SethBodine/docker/wiki/Cloud-Authentication-via-CLI#aws) |
| Prowler v3 | `. /opt/prowler/prowler.sh && prowler` | ![](https://img.shields.io/github/last-commit/prowler-cloud/prowler/v3) | [Using Prowler](https://github.com/SethBodine/docker/wiki/Using-Prowler-v3) |
| Prowler v4 | `. /opt/prowler4/prowler4.sh && prowler` | ![](https://img.shields.io/github/last-commit/prowler-cloud/prowler) | [Using Prowler](https://github.com/SethBodine/docker/wiki/Using-Prowler-v4) |
| Steampipe | `steampipe` | ![](https://img.shields.io/github/last-commit/turbot/steampipe) | [Using steampipe](https://github.com/SethBodine/docker/wiki/Using-Steampipe) |
| Powerpipe | `powerpipe` | ![](https://img.shields.io/github/last-commit/turbot/powerpipe) | [Using powerpipe](https://github.com/SethBodine/docker/wiki/Using-Powerpipe) |
| ScoutSuite | `. /opt/ScoutSuite/scoutsuite.sh && /opt/ScoutSuite/scout.py` | ![](https://img.shields.io/github/last-commit/nccgroup/ScoutSuite) | [Using ScoutSuite](https://github.com/SethBodine/docker/wiki/Using-ScoutSuite) |
| testssl | `/opt/testssl.sh/testssl.sh` | ![](https://img.shields.io/github/last-commit/drwetter/testssl.sh) | [Using testssl.sh](https://github.com/SethBodine/docker/wiki/Using-testssl.sh) |
| trufflehog | `trufflehog` | ![](https://img.shields.io/github/last-commit/trufflesecurity/trufflehog) | [Using Trufflehog](https://github.com/SethBodine/docker/wiki/Using-Trufflehog) |
| kubeaudit | `kubeaudit` | ![](https://img.shields.io/github/last-commit/Shopify/kubeaudit) | [Using kubeaudit](https://github.com/SethBodine/docker/wiki/Using-kubeaudit) |
| AzureHound | `AzureHound` | ![](https://img.shields.io/github/last-commit/BloodHoundAD/AzureHound) | [Using AzureHound](https://github.com/SethBodine/docker/wiki/Using-AzureHound)| 
| tfsec | `tfsec` | ![](https://img.shields.io/github/last-commit/aquasecurity/tfsec) | [Using tfsec](https://github.com/SethBodine/docker/wiki/Using-tfsec) |
| trivy | `trivy` | ![](https://img.shields.io/github/last-commit/aquasecurity/trivy) | [Using trivy](https://github.com/SethBodine/docker/wiki/Using-trivy) |
| kubescape | `kubescape` | ![](https://img.shields.io/github/last-commit/kubescape/kubescape) | [Using kubescape](https://github.com/SethBodine/docker/wiki/Using-kubescape) |
| bucketcloner | `. /opt/bucketcloner/bb-clone.sh && bucketcloner` | ![](https://img.shields.io/github/last-commit/phillies/bucketcloner) | [Using bucketcloner](https://github.com/SethBodine/docker/wiki/Using-bucketcloner) |

## Recent Changes
- Separating Prowler v3 and v4
- Fixing aws-cli installation issues
- Simplifying start-up
