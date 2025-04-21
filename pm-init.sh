#!/bin/sh

# chatgpt improvments included :)

# --- Configuration ---
IMAGE="ghcr.io/sethbodine/audit-tools:latest"
CONTAINER_NAME="audit-tools"
DEFAULT_OUTPUT_DIR="$HOME/Documents"
OUTPUT_DIR="${AUDIT_OUTPUT_DIR:-$DEFAULT_OUTPUT_DIR}"
LOG_DIR="$HOME/.local/share/audit-tools"
LOG_FILE="$LOG_DIR/audit-tools.log"

# --- Ensure log directory exists ---
mkdir -p "$LOG_DIR"

log() {
    printf "[%s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
}

log ".. Checking container status and image version..."

# --- Get remote image digest ---
REMOTE_DIGEST=$(podman pull --quiet --digestfile - "${IMAGE}" 2>/dev/null | awk '/Digest:/ {print $2}')

# --- Get local image digest ---
LOCAL_DIGEST=$(podman inspect --format '{{ index .RepoDigests 0 }}' "${IMAGE}" 2>/dev/null | cut -d@ -f2)

# --- Compare digests ---
if [ "$REMOTE_DIGEST" != "$LOCAL_DIGEST" ]; then
    log ".. New image available. Updating..."
    podman pull "$IMAGE" >/dev/null
    IMAGE_UPDATED=true
else
    log ". Image is up to date."
    IMAGE_UPDATED=false
fi

# --- Check if container is running ---
RUNNING=$(podman ps -q -f name="^${CONTAINER_NAME}$")

if [ -n "$RUNNING" ]; then
    log ".. Container '$CONTAINER_NAME' is already running. No action taken."
    exit 0
fi

# --- Remove existing stopped container if exists ---
STOPPED=$(podman ps -a -q -f name="^${CONTAINER_NAME}$")
if [ -n "$STOPPED" ]; then
    log ".. Removing old container '${CONTAINER_NAME}'..."
    podman rm "$CONTAINER_NAME" >/dev/null
fi

log ".. Starting container '$CONTAINER_NAME'..."

# --- Run container in background ---
podman run -d \
    --name "${CONTAINER_NAME}" \
    -p 9194:9194 \
    -p 9033:9033 \
    -p 11666:11666 \
    -v "${OUTPUT_DIR}:/output:Z" \
    "$IMAGE" /sbin/updatetools >/dev/null

if [ $? -eq 0 ]; then
    log ". Container started successfully."a
    podman exec -it --user container ${CONTAINER_NAME} /bin/bash; 
else
    log ". Failed to start container."
    exit 1
fi

