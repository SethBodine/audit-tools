# Docker Audit Tools
This docker file contains a current list of reliable, usable tools to aid in Cloud Audits.
## Docker Image Build 
```bash
docker system prune -a -f	# Note: Runing this command will PURGE ALL Images, not just this image
docker build -t audit-tools .	# Build time is longer due to Cloud CLI Install times. Est about 10-15mins to build
```
## Run Docker Instance - without exiting - and drop into a shell
### Launch Container and grab Instance ID (Long)
```bash
container_id=$(docker run -it --rm --detach audit-tools --name audit-tools)
```
### Drop into Bash shell
```bash
docker exec -it --user docker  ${container_id} /bin/bash
```
### Stop and Clean-up
```bash
docker stop ${container_id}
```
## Tools and How to use
Everything is deployed under /opt, further reading can be found for tools at these lcoations
* [ScoutSuite](https://github.com/nccgroup/ScoutSuite/) -  an open source multi-cloud security-auditing tool
* [Steampipe](https://steampipe.io/) - an open source tool for querying cloud APIs in a universal way and reasoning about the data in SQL
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) - Azure command-line interface (Azure CLI) is a set of commands used to create and manage Azure resources
* [AWS CLI](https://aws.amazon.com/cli/) - The AWS Command Line Interface (AWS CLI) is a unified tool to manage your AWS services
* [GCP CLI](https://cloud.google.com/sdk/gcloud/) - The Google Cloud CLI is a set of tools to create and manage Google Cloud resources
### Other Tools
- Perl
- Python
- nmap
### CLIs - login and update credentials before using the tools
- aws
- gcp
- azure
### Scout Suite
Scout should be ready to use, run the following commands to prep the venv
```bash
cd /opt/ScoutSuite/
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt 
```
The following script will run those commands as well
```bash
/opt/ScoutSuite/scoutsuite.sh can be used to 
```
Once done - execute the following command to deactivate the environment
```bash
deactivate
```
### Steampipe
Steampipe is installed into /usr/local/bin/steampipe

Mods for AWS, GCP, and Azure are deployed into the following path - to use, run steampipe from the specific location - dashboard will not run.
- /opt/steampipe-mod-*

### Update Tool
Execute the following command to update the tools in the container, however, at container launch this will execute - and stay running (sleep) to stop the container just closing.
```bash
/sbin/updatetools
```
