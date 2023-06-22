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

## Recent Changes
- Prowler now supports Azure and AWS - new in [v3](https://github.com/prowler-cloud/prowler/tree/3.0.0)

## How?
Historically docker was the go to, however, due to the licensing changes, podman is now the recommended approach to the build. Check out the [wiki](https://github.com/SethBodine/docker/wiki/Home/) for further information

## Why?
New Job, new wants and needs, simple.

