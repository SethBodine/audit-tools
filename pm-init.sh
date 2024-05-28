#!/bin/sh

echo Clean-up of Container
podman stop audit-tools
podman rm audit-tools

echo Launching Container...
podman pull ghcr.io/sethbodine/audit-tools && \
podman image prune -f && \
container_id=$(podman run -it -p 9194:9194 -p 9033:9033 -p 11666:11666 --rm --detach --name audit-tools ghcr.io/sethbodine/audit-tools /sbin/updatetools) && \
podman exec -it --user container ${container_id} /bin/bash; 

echo Container Cleaned Up...
podman stop ${container_id}

