#!/usr/bin/env bash
set -euo pipefail

# Switch the linux builder to aarch64-linux, run update, then switch back to x86_64

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AARCH_PATCH_FILE="aarch64-linux-builder.patch"
X86_PATCH_FILE="x86_64-linux-builder.patch"

if [ -t 1 ]; then
    BOLD="$(tput bold 2>/dev/null)"
    RESET="$(tput sgr0 2>/dev/null)"
else
    BOLD=""
    RESET=""
fi

CURRENT_PATCH=""
CLEANUP_DONE=false

cleanup() {
    if [[ "$CLEANUP_DONE" == "true" ]]; then
        return
    fi
    CLEANUP_DONE=true

    local exit_code=$?

    echo ""
    if [[ $exit_code -eq 130 ]]; then
        echo "Interrupted by user (Ctrl-C), cleaning up..."
    elif [[ $exit_code -ne 0 ]]; then
        echo "Error occurred (exit code: $exit_code), cleaning up..."
    else
        echo "Script completed, cleaning up..."
    fi

    if [[ -n "$CURRENT_PATCH" ]]; then
        echo "Reverting patch: $CURRENT_PATCH"
        cd "$ROOT_DIR"
        git apply -R "$CURRENT_PATCH" 2>/dev/null || true
        CURRENT_PATCH=""
    fi

    if [[ $exit_code -ne 0 ]]; then
      echo "Restoring x86_64-linux builder..."
      just _switch 2>/dev/null || true

      echo "Cleanup complete."
      exit $exit_code
    fi
}

trap cleanup EXIT

source "$(dirname "$0")/builder-functions.sh"

cd "$ROOT_DIR"
echo "${BOLD}=== Step 1: Switching to aarch64-linux builder ===${RESET}"
switch_to_builder "aarch64" "$AARCH_PATCH_FILE"

echo "${BOLD}=== Step 2: Running 'just _update' ===${RESET}"
just _update

echo "${BOLD}=== Step 3: Switching back from aarch64-linux builder ===${RESET}"
revert_patch "aarch64" "$AARCH_PATCH_FILE"

echo "${BOLD}=== Step 4: Switching to x86_64-linux builder ===${RESET}"
switch_to_builder "x86_64" "$X86_PATCH_FILE"

echo "${BOLD}=== Step 5: Switching back from x86_64-linux builder ===${RESET}"
revert_patch "x86_64" "$X86_PATCH_FILE"

echo "${BOLD}=== Step 6: Running 'just _switch' ===${RESET}"
just switch

echo "${BOLD}=== Done! ===${RESET}"
