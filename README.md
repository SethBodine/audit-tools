# Docker Audit Tools

This docker file contains a current list of reliable, usable tools to aid in Cloud Audits.

## Docker Image Build 

docker system prune -a -f	# Note: Runing this command will PURGE ALL Images, not just this image
docker build -t audit-tools .	# Build time is longer due to Cloud CLI Install times. Est about 10-15mins to build

## Run Docker Instance - without exiting - and drop into a shell

### Launch Container and grab Instance ID (Long)
container_id=$(docker run -it --rm --detach audit-tools --name audit-tools)

### Drop into Bash shell
docker exec -it --user docker  ${container_id} /bin/bash

### Stop and Clean-up
docker stop ${container_id}

## Tools and How to use
Everything is deployed under /opt

### CLIs - login and update credentials before using the tools
- aws
- gcp
- azure

### Scout Suite
Scout should be ready to use, run the following commands to prep the venv
```
/opt/ScoutSuite/scoutsuite.sh can be used to 
```
Once done - execute the following command to deactivate the environment
```
deactivate
```

### Steampipe
steampipe is installed into /usr/local/bin/steampipe

Mods for AWS, GCP, and Azure are deployed into the following path - to use, run steampipe from the specific location - dashboard will not run.

- /opt/steampipe-mod-*

### Update Tool
Execute the following command to update the tools in the container, however, at container launch this will execute - and stay running (sleep) to stop the container just closing.

- /sbin/updatetools
