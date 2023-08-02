# Container of Audit Tools
This README was becomming a bit ott... so new README... less mess

## What is this for?
This is purely a docker container that brings together several tools to simplify the auditing of cloud services.

### Contains...
Currently serveral packages are configured (small list below), check out the [wiki](https://github.com/SethBodine/docker/wiki/Home/) for additional details
* Azure CLI `az`
* GCP Cli `gcloud`
* AWS CLI `aws`
* Prowler v2 `. /opt/prowler/prowler.sh && /opt/prowler/prowler`
* Prowler v3 `. /opt/prowler3/prowler.sh && prowler`
* SteamPipe `steampipe`
* ScoutSuite `. /opt/ScoutSuite/scoutsuite.sh && /opt/ScoutSuite/scout.py`
* testssl `/opt/testssl.sh/testssl.sh`
* trufflehog `trufflehog`
* kubeaudit  `kubeaudit`

## Recent Changes
- Added kubeaudit, testssl, trufflehog, and AzureHound

## How?
Historically docker was the go to, however, due to the licensing changes, podman is now the recommended approach to the build. Check out the [wiki](https://github.com/SethBodine/docker/wiki/Home/) for further information

## Why?
New Job, new wants and needs, simple.
