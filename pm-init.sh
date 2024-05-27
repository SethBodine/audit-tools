#!/bin/sh

echo Launching Container...

podman stop audit-tools
podman rm audit-tools
podman pull ghcr.io/sethbodine/audit-tools && \
podman image prune -f && \
container_id=$(podman run -it -p 9194:9194 -p 9033:9033 -p 11666:11666 --rm --detach --name audit-tools ghcr.io/sethbodine/audit-tools /sbin/updatetools) && \
podman exec -it --user container ${container_id} /bin/bash 
podman stop ${container_id}

echo Container Cleaned Up...
