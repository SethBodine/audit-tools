## What is this for?
This is purely a container image that brings together several tools to simplify the auditing of several cloud services.

### Contains...
Currently serveral packages are configured (small list below), check out the [wiki](https://github.com/SethBodine/docker/wiki/) for additional details
* Azure CLI `az`
* GCP Cli `gcloud`
* AWS CLI `aws`
* Prowler v3 `. /opt/prowler/prowler.sh && prowler`
* SteamPipe `steampipe`
* ScoutSuite `. /opt/ScoutSuite/scoutsuite.sh && /opt/ScoutSuite/scout.py`
* testssl `/opt/testssl.sh/testssl.sh`
* trufflehog `trufflehog`
* kubeaudit  `kubeaudit`
* AzureHound `AzureHound`
* tfsec `tfsec`

## Recent Changes
- Removed awsenum and prowler v2
