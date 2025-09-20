## What is this for?
This is purely a container image that brings together several tools to simplify the auditing of several cloud services.

### Contains...
Currently serveral packages are configured (small list below), check out the [wiki](https://github.com/SethBodine/docker/wiki/) for additional details

| Tool | CLI command | GitHub Commit Age | Wiki URL |
| --- | --- | --- | --- |
| Azure CLI | `az` | ![](https://img.shields.io/github/last-commit/Azure/azure-cli) | [Using az cli ](https://github.com/SethBodine/docker/wiki/Cloud-Authentication-via-CLI#azure) |
| GCP Cli | `gcloud` | | [Using gcloud cli](https://github.com/SethBodine/docker/wiki/Cloud-Authentication-via-CLI#gcp) |
| AWS CLI | `aws` | ![](https://img.shields.io/github/last-commit/aws/aws-cli) | [Using aws cli](https://github.com/SethBodine/docker/wiki/Cloud-Authentication-via-CLI#aws) |
| Prowler | `. /opt/prowler/prowler.sh && prowler` | ![](https://img.shields.io/github/last-commit/prowler-cloud/prowler) | [Using Prowler](https://github.com/SethBodine/docker/wiki/Using-Prowler) |
| Steampipe | `steampipe` | ![](https://img.shields.io/github/last-commit/turbot/steampipe) | [Using steampipe](https://github.com/SethBodine/docker/wiki/Using-Steampipe) |
| Powerpipe | `powerpipe` | ![](https://img.shields.io/github/last-commit/turbot/powerpipe) | [Using powerpipe](https://github.com/SethBodine/docker/wiki/Using-Powerpipe) |
| ScoutSuite | `. /opt/ScoutSuite/scoutsuite.sh && /opt/ScoutSuite/scout.py` (stale) | ![](https://img.shields.io/github/last-commit/nccgroup/ScoutSuite) | [Using ScoutSuite](https://github.com/SethBodine/docker/wiki/Using-ScoutSuite) |
| testssl | `/opt/testssl.sh/testssl.sh` | ![](https://img.shields.io/github/last-commit/drwetter/testssl.sh) | [Using testssl.sh](https://github.com/SethBodine/docker/wiki/Using-testssl.sh) |
| trufflehog | `trufflehog` | ![](https://img.shields.io/github/last-commit/trufflesecurity/trufflehog) | [Using Trufflehog](https://github.com/SethBodine/docker/wiki/Using-Trufflehog) |
| AzureHound | `AzureHound` | ![](https://img.shields.io/github/last-commit/BloodHoundAD/AzureHound) | [Using AzureHound](https://github.com/SethBodine/docker/wiki/Using-AzureHound)| 
| trivy | `trivy` | ![](https://img.shields.io/github/last-commit/aquasecurity/trivy) | [Using trivy](https://github.com/SethBodine/docker/wiki/Using-trivy) |
| kubescape | `kubescape` | ![](https://img.shields.io/github/last-commit/kubescape/kubescape) | [Using kubescape](https://github.com/SethBodine/docker/wiki/Using-kubescape) |
| kube-bench | `kube-bench` | ![](https://img.shields.io/github/last-commit/aquasecurity/kube-bench) | [Using kube-bench](https://github.com/SethBodine/docker/wiki/Using-kubei-bench) |
| semgrep | `. /opt/semgrep/semgrep.sh && semgrep` | ![](https://img.shields.io/github/last-commit/semgrep/semgrep) | [Using semgrep](https://github.com/SethBodine/docker/wiki/Using-semgrep) |
| dockerspy | `dockerspy` | ![](https://img.shields.io/github/last-commit/UndeadSec/DockerSpy) | [Using dockerspy](https://github.com/SethBodine/docker/wiki/Using-dockerspy) |
| poutine | `poutine` | ![](https://img.shields.io/github/last-commit/boostsecurityio/poutine) | [Using poutine](https://github.com/SethBodine/docker/wiki/Using_poutine) |
| aws_list_all | `aws_list_all` | ![](https://img.shields.io/github/last-commit/JohannesEbke/aws_list_all) | [Using aws_list_all](https://github.com/SethBodine/docker/wiki/Using_aws_list_all) |
| grype | `grype` | ![](https://img.shields.io/github/last-commit/anchore/grype) | [Using grype](https://github.com/SethBodine/docker/wiki/Using_grype) |
| syft | `syft` | ![](https://img.shields.io/github/last-commit/anchore/syft) | [Using syft](https://github.com/SethBodine/docker/wiki/Using_syft) |
| checkov | `/opt/semgrep/checkov.sh && checkov` | ![](https://img.shields.io/github/last-commit/)bridgecrewio/checkov | [Using checkov](https://github.com/SethBodine/docker/wiki/Using_checkov) |

## Recent Changes
- Fixed a few issues - including prowler not supporting python 3.13 
- Wound back some of my workflows - resulted in messiness
- golang applications are now compiled at build - and will not be rebuilt at runtime (at this time) - reduces the overall bloat

### Removed 
The following stale and EOL/EOS applications have been removed and wiki documentation has been removed.
- tfsec
- kubeaudit
- steampipe mods (replaced by powerpipe)

### Added Tools
The following new tools have been added
- poutine
- aws_list_all
- grype
- syft
- kube-bench
- checkov
- batcat (alternative to cat)
- fdfind (find written in rust)
- rg (grep written in rust)
- dust (rust alternative to du)
