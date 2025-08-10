#!/bin/bash
set -e

# === CONFIG ===
NUM_VCAMS=2  # Change to 1 if you only want one virtual cam

# === FUNCTIONS ===
find_real_cam() {
    for dev in /dev/video*; do
        if v4l2-ctl --device="$dev" --all &>/dev/null; then
            if ! v4l2-ctl --device="$dev" --all | grep -q "v4l2 loopback"; then
                echo "$dev"
                return
            fi
        fi
    done
}

kill_using_video() {
    echo "[*] Killing processes using /dev/video*..."
    sudo fuser -k /dev/video* 2>/dev/null || true
}

load_v4l2loopback() {
    echo "[*] Loading v4l2loopback..."
    sudo modprobe -r v4l2loopback 2>/dev/null || true
    sudo modprobe v4l2loopback devices=$NUM_VCAMS exclusive_caps=1
}

find_vcam_devices() {
    for dev in /dev/video*; do
        if v4l2-ctl --device="$dev" --all &>/dev/null; then
            if v4l2-ctl --device="$dev" --all | grep -q "v4l2 loopback"; then
                echo "$dev"
            fi
        fi
    done
}

start_ffmpeg() {
    echo "[*] Starting ffmpeg loop..."
    local outputs=()
    for vdev in "${VCAM_DEVICES[@]}"; do
        outputs+=(-f v4l2 -pix_fmt yuv420p "$vdev")
    done

    ffmpeg -f v4l2 -i "$REAL_CAM" \
           -vf format=yuv420p \
           "${outputs[@]}"
}

# === MAIN SCRIPT ===
kill_using_video
REAL_CAM=$(find_real_cam)
echo "[OK] Real camera found: $REAL_CAM"
load_v4l2loopback
VCAM_DEVICES=($(find_vcam_devices))
echo "[OK] Virtual cams: ${VCAM_DEVICES[*]}"
start_ffmpeg
