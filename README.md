# Docker Audit Tools
This docker file contains a current list of reliable, usable tools to aid in Cloud Audits.
## Docker Install Engine
Ensure you review the docker installation - [Docker Desktop](https://docs.docker.com/desktop/install/windows-install/) Licensing has changed recently.
- [Ubuntu](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
- [Debian](https://docs.docker.com/engine/install/debian/#install-using-the-repository)
- [RHEL](https://docs.docker.com/engine/install/rhel/#install-using-the-repository)
- [Fedora](https://docs.docker.com/engine/install/fedora/#install-using-the-repository)
## [Podman Install](https://podman.io/getting-started/installation) - Alternative to Docker and recommended for MACOS
> Note: Drive Mapping is not supported so instructions will be added in the wiki to cover this

### Podman set-up notes
#### MACOS
```
xcode-select --install
brew install podman
podman machine init ---now -cpus=4 --memory=4096 
podman machine start
```                                                                                                                                        
> Note: While you can execute `alias docker=podman` you man run into specific issues - so podman variations will be captured below.
# Environment Prep
The following commands will clean-up and build this repo from github. Please note some documentation has changed, so before updating things, execute the following clean-up command.
```
docker system prune -a -f	    # Note: Running this command will PURGE ALL Images, not just this image

podman system prune -a -f
```
# Prepare and run the Container
## Option 1. Local Docker Image Build (Note: Runtime is 10-20mins)
```bash
docker system prune -a -f --filter "label=audit-tools"
docker build github.com/SethBodine/docker#main -t audit-tools --label audit-tools

podman system prune -a -f --filter "label=audit-tools"
podman build github.com/SethBodine/docker#main -t audit-tools --label audit-tools
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
container_id=$(docker run -it -p 9194:9194 -v ~/Documents:/output --rm --detach --name audit-tools audit-tools /sbin/updatetools)

container_id=$(podman run -it -p 9194:9194 --rm --detach --name audit-tools audit-tools /sbin/updatetools)
```
## Option 2. Run Docker Instance directly from Github [Package](https://github.com/SethBodine/docker/pkgs/container/audit-tools) and Launch Container and grab Instance ID (Long) (Note: Runetime: about 5mins - recommended)
You can also just download the latest image via the [Packages section](https://github.com/SethBodine/docker/pkgs/container/audit-tools)
```
docker pull ghcr.io/sethbodine/audit-tools:main
container_id=$(docker run -it -p 9194:9194 -v ~/Documents:/output --rm --detach --name audit-tools ghcr.io/sethbodine/audit-tools:main /sbin/updatetools)

podman pull ghcr.io/sethbodine/audit-tools:main
container_id=$(podman run -it -p 9194:9194 --rm --detach --name audit-tools ghcr.io/sethbodine/audit-tools:main /sbin/updatetools)
```
### Drop into Bash shell
```bash
docker exec -it --user docker  ${container_id} /bin/bash

podman exec -it --user docker  ${container_id} /bin/bash
```
> Note: By default the container will exit after 48 hours (See updatetools script)
### Stop and Clean-up
```bash
docker stop ${container_id}

podman stop ${container_id}
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
### Output Location (docker)
Copy/Paste will mount ~/Documents to /output to move report files outside of the container
### Output Location [https://docs.podman.io/en/latest/markdown/podman-cp.1.html](podman)
* Move/copy any files to transfer externally to /output
```
podman cp ${container_id}:/output ~/Documents
```
### Update Tool
Execute the following command to update the tools in the container, however, at container launch this will execute - and stay running (sleep) to stop the container just closing.
```bash
/sbin/updatetools
```

