#!/usr/bin/env bash
# Builder switching functions library

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

switch_to_builder() {
    local arch="$1"
    local patch_file="$2"

    CURRENT_PATCH="$patch_file"

    echo "${BOLD}===== Applying patch to switch to ${arch}-linux builder ===${RESET}"
    git apply "$patch_file"

    echo "${BOLD}===== Running 'just _switch' to activate ${arch}-linux builder ===${RESET}"
    just _switch

    echo "${BOLD}===== Waiting for ${arch}-linux builder to be ready for SSH ===${RESET}"
    local MAX_RETRIES=30
    local RETRY_DELAY=5

    for i in $(seq 1 $MAX_RETRIES); do
        echo "Attempt $i/$MAX_RETRIES: Checking if we can SSH to linux-builder..."
        if sudo ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no linux-builder "exit 0" 2>/dev/null; then
            echo "SSH connection successful!"
            break
        fi
        if [[ $i -eq $MAX_RETRIES ]]; then
            echo "ERROR: Could not connect to linux-builder after $MAX_RETRIES attempts"
            exit 1
        fi
        echo "Waiting ${RETRY_DELAY}s before retry..."
        sleep $RETRY_DELAY
    done

    echo "${BOLD}===== Verifying architecture with uname -a ===${RESET}"
    local arch_output
    arch_output=$(sudo ssh linux-builder "uname -a")
    echo "Builder kernel: $arch_output"

    if ! echo "$arch_output" | grep -q "$arch"; then
        echo "ERROR: Builder is NOT ${arch}-linux!"
        echo "Expected '${arch}' in output, got: $arch_output"
        exit 1
    fi
    echo "Confirmed: Builder is ${arch}-linux"
}

revert_patch() {
    local arch="$1"
    local patch_file="$2"

    echo "${BOLD}===== Reverting patch to restore from ${arch}-linux builder ===${RESET}"
    git apply -R "$patch_file"
    CURRENT_PATCH=""
}
