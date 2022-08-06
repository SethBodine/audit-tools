# Docker Audit Tools
This docker file contains a current list of reliable, usable tools to aid in Cloud Audits.
## Docker Install Engine
Ensure you review the docker installation - [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/) Licensing has changed recently.
- [Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
- [Debian](https://docs.docker.com/engine/install/debian/#install-using-the-repository)
- [RHEL](https://docs.docker.com/engine/install/rhel/#install-using-the-repository)
- [Fedora](https://docs.docker.com/engine/install/fedora/#install-using-the-repository)

## Option 1. Local Docker Image Build 
The following commands will clean-up and build this repo from github. Please note that this has changed, so before updating things, execute the following clean-up command.
```
docker system prune -a -f	    # Note: Running this command will PURGE ALL Images, not just this image
```
```bash
docker system prune -a -f --filter "label=audit-tools"
docker build github.com/SethBodine/docker#main -t audit-tools --label audit-tools
```
### Run Docker Instance from Local Build and Launch Container and grab Instance ID (Long)
* -t       : Allocate a pseudo-tty
* -i       : Keep STDIN open even if not attached
* -v       : Bind mount a volume /output in the container to ~/Documents
* -p       : Publish a container's port 9194 to the host
* --rm     : Automatically remove the container when it exits
* --name   : Assign a name to the container
* --detach : Run container in background and print container ID
```bash
container_id=$(docker run -it -p 9194:9194 -v ~/Documents:/output --rm --detach --name audit-tools audit-tools)
```
## Option 2. Run Docker Instance directly from Github [Package](https://github.com/SethBodine/docker/pkgs/container/audit-tools) and Launch Container and grab Instance ID (Long)
You can also just download the latest image via the [Packages section](https://github.com/SethBodine/docker/pkgs/container/audit-tools)
```
container_id=$(docker run -it -p 9194:9194 -v ~/Documents:/output --rm --detach --name audit-tools ghcr.io/sethbodine/audit-tools:main)
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
* [awsEnum](https://github.com/bassammaged/awsEnum) - Enumerate AWS cloud resources based on provided credential 
* [Prowler](https://github.com/prowler-cloud/prowler) - Perform AWS security best practices assessments, audits, incident response, continuous monitoring, hardening and forensics readiness
* [cliam](https://github.com/securisec/cliam) - Cloud agnostic IAM permissions enumerator 
### Other Tools
- Perl
- Python3
- golang
- nmap
- ping
- dig
- whois
### CLIs - login and update credentials before using the tools
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) - Azure command-line interface (Azure CLI) is a set of commands used to create and manage Azure resources
* [AWS CLI](https://aws.amazon.com/cli/) - The AWS Command Line Interface (AWS CLI) is a unified tool to manage your AWS services
* [GCP CLI](https://cloud.google.com/sdk/gcloud/) - The Google Cloud CLI is a set of tools to create and manage Google Cloud resources
### Output Location
Copy/Paste will mount ~/Documents to /output to move report files outside of the container
### Update Tool
Execute the following command to update the tools in the container, however, at container launch this will execute - and stay running (sleep) to stop the container just closing.
```bash
/sbin/updatetools
```

