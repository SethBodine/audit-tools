#!/usr/bin/env bash

# chatgpt improvments included :)

# --- Configuration ---
IMAGE="ghcr.io/sethbodine/audit-tools:latest"
CONTAINER_NAME="audit-tools"
DEFAULT_OUTPUT_DIR="$HOME/Documents"
OUTPUT_DIR="${AUDIT_OUTPUT_DIR:-$DEFAULT_OUTPUT_DIR}"
LOG_DIR="$HOME/.local/share/audit-tools"
LOG_FILE="$LOG_DIR/audit-tools.log"

# --- Detect container engine ---
if command -v podman >/dev/null 2>&1; then
    CONTAINER_ENGINE="podman"
elif command -v docker >/dev/null 2>&1; then
    CONTAINER_ENGINE="docker"
else
    echo "[ERROR] Neither podman nor docker is installed or available in PATH." >&2
    exit 1
fi

# --- Volume mount flags (adjust if docker doesn't support :Z) ---
if [ "$CONTAINER_ENGINE" = "docker" ]; then
    MOUNT_FLAGS="-v ${OUTPUT_DIR}:/output"
else
    MOUNT_FLAGS="-v ${OUTPUT_DIR}:/output:Z"
fi

# --- Ensure log directory exists ---
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Using container engine: $CONTAINER_ENGINE"

# --- Stop container if running ---
RUNNING_ID=$($CONTAINER_ENGINE ps -q -f name="^${CONTAINER_NAME}$")

if [ -n "$RUNNING_ID" ]; then
    log "Stopping running container '$CONTAINER_NAME'..."
    $CONTAINER_ENGINE stop "$CONTAINER_NAME" >/dev/null
else
    log "No running container '$CONTAINER_NAME' found. Skipping stop."
fi

# --- Remove stopped container if it exists ---
EXISTS_ID=$($CONTAINER_ENGINE ps -a -q -f name="^${CONTAINER_NAME}$")
if [ -n "$EXISTS_ID" ]; then
    log "Removing old container '$CONTAINER_NAME'..."
    $CONTAINER_ENGINE rm "$CONTAINER_NAME" >/dev/null
else
    log "No container '$CONTAINER_NAME' exists to remove."
fi

# --- Pull new image if needed ---
log "Pulling latest image. This will skip if already up to date..."
$CONTAINER_ENGINE pull "$IMAGE" >/dev/null

# --- Start container in detached mode ---
log "Starting container '$CONTAINER_NAME'..."
$CONTAINER_ENGINE run -d \
    --name "$CONTAINER_NAME" \
    -p 9194:9194 \
    -p 9033:9033 \
    -p 11666:11666 \
    $MOUNT_FLAGS \
    "$IMAGE" /sbin/updatetools >/dev/null

if [[ $? -ne 0 ]]; then
    log "Failed to start container."
    exit 1
fi

# --- Drop into interactive shell ---
log "Attaching to container shell. Exit when done."
$CONTAINER_ENGINE exec -it --user container "$CONTAINER_NAME" /bin/bash

# --- Stop container after shell exit ---
log "Stopping container '$CONTAINER_NAME'..."
$CONTAINER_ENGINE stop "$CONTAINER_NAME" >/dev/null

# --- Clean up old image versions ---
log "Cleaning up older unused versions of '$IMAGE'..."
CURRENT_ID=$($CONTAINER_ENGINE inspect --format '{{.Id}}' "$IMAGE" 2>/dev/null)

for IMG_ID in $($CONTAINER_ENGINE images --no-trunc --quiet "$IMAGE" | sort | uniq); do
    if [[ "$IMG_ID" != "$CURRENT_ID" ]]; then
        USED=$($CONTAINER_ENGINE ps -a --filter ancestor="$IMG_ID" --format '{{.ID}}')
        if [[ -z "$USED" ]]; then
            log "Removing unused image ID: $IMG_ID"
            $CONTAINER_ENGINE rmi "$IMG_ID" >/dev/null
        fi
    fi
done
