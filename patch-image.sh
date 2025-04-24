#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") <base-image> <path-in-image> <local-file> [new-image[:tag]]
  <base-image>       The existing Docker image name or ID to start from
  <path-in-image>    Full path inside the image where the file will be replaced
  <local-file>       Local file path to copy into the container
  [new-image[:tag]]  (Optional) Name for the new image. Defaults to "<base-image>-updated"
EOF
  exit 1
}

# Check arguments
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
  usage
fi

BASE_IMAGE=$1
TARGET_PATH=$2
LOCAL_FILE=$3
NEW_IMAGE=${4:-"${BASE_IMAGE}-updated"}

# Verify Docker is available
if ! command -v docker &>/dev/null; then
  echo "Error: docker command not found." >&2
  exit 1
fi

echo "▶ Base image:        $BASE_IMAGE"
echo "▶ Target path:       $TARGET_PATH"
echo "▶ Local file:        $LOCAL_FILE"
echo "▶ New image output:  $NEW_IMAGE"
echo

# 1) Create a temporary container
CONTAINER_ID=$(docker create "$BASE_IMAGE")
echo "[1/4] Created temporary container: $CONTAINER_ID"

# 2) Copy (overwrite) the file into the container
docker cp "$LOCAL_FILE" "${CONTAINER_ID}:${TARGET_PATH}"
echo "[2/4] Copied $LOCAL_FILE to ${TARGET_PATH}"

# 3) Commit the changes and create a new image
docker commit "$CONTAINER_ID" "$NEW_IMAGE" >/dev/null
echo "[3/4] Committed container $CONTAINER_ID as new image $NEW_IMAGE"

# 4) Remove the temporary container
docker rm "$CONTAINER_ID" >/dev/null
echo "[4/4] Removed temporary container $CONTAINER_ID"

echo
echo "✅ Done: New image '$NEW_IMAGE' has been created."
