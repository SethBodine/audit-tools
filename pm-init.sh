#!/bin/sh

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
    printf "[%s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
}

log "Using container engine: $CONTAINER_ENGINE"

# --- Pull latest image and get remote digest ---
log "Checking for image updates..."
REMOTE_DIGEST=$($CONTAINER_ENGINE pull --quiet --digestfile - "$IMAGE" 2>/dev/null | awk '/Digest:/ {print $2}')

# --- Get local image digest ---
LOCAL_DIGEST=$($CONTAINER_ENGINE inspect --format '{{ index .RepoDigests 0 }}' "$IMAGE" 2>/dev/null | cut -d@ -f2)

# --- Compare digests ---
if [ "$REMOTE_DIGEST" != "$LOCAL_DIGEST" ]; then
    log "New image detected. Pulling latest version..."
    $CONTAINER_ENGINE pull "$IMAGE" >/dev/null
    IMAGE_UPDATED=true
else
    log "Image is already up to date."
    IMAGE_UPDATED=false
fi

# --- Check if container is already running ---
RUNNING=$($CONTAINER_ENGINE ps -q -f name="^${CONTAINER_NAME}$")
if [ -n "$RUNNING" ]; then
    log "Container '$CONTAINER_NAME' is already running. No changes made."
    exit 0
fi

# --- Remove stopped container if exists ---
STOPPED=$($CONTAINER_ENGINE ps -a -q -f name="^${CONTAINER_NAME}$")
if [ -n "$STOPPED" ]; then
    log "Removing old container '$CONTAINER_NAME'."
    $CONTAINER_ENGINE rm "$CONTAINER_NAME" >/dev/null
fi

log "Starting new container '$CONTAINER_NAME'..."
$CONTAINER_ENGINE run -d \
    --name "$CONTAINER_NAME" \
    -p 9194:9194 \
    -p 9033:9033 \
    -p 11666:11666 \
    $MOUNT_FLAGS \
    "$IMAGE" /sbin/updatetools >/dev/null

if [ $? -eq 0 ]; then
    log "Container started successfully."
else
    log "Failed to start container."
    exit 1
fi
