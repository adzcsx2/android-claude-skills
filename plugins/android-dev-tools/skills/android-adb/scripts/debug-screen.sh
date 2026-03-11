#!/bin/bash
# Capture screenshot and UI dump for debugging
# Usage: debug-screen.sh [-s <serial>]
#   -s <serial>  Target specific device by serial number
#
# Output files are saved to /tmp/android_debug_<timestamp>/
# Maximum 5 debug directories are kept; older ones are deleted.

set -e

# Parse arguments
SERIAL=""
ADB_CMD="adb"

while getopts "s:" opt; do
    case $opt in
        s) SERIAL="$OPTARG" ;;
        *) echo "Usage: debug-screen.sh [-s <serial>]"; exit 1 ;;
    esac
done

# Build ADB command with optional serial
if [ -n "$SERIAL" ]; then
    ADB_CMD="adb -s $SERIAL"
fi

# Create debug directory with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEBUG_DIR="/tmp/android_debug_$TIMESTAMP"
mkdir -p "$DEBUG_DIR"

# Device paths
DEVICE_SCREENSHOT="/sdcard/debug_screen.png"
DEVICE_UI_DUMP="/sdcard/debug_window_dump.xml"

# Local paths
LOCAL_SCREENSHOT="$DEBUG_DIR/screenshot.png"
LOCAL_UI_DUMP="$DEBUG_DIR/ui_dump.xml"

echo "Capturing debug files..."

# Take screenshot
$ADB_CMD shell screencap -p "$DEVICE_SCREENSHOT" > /dev/null 2>&1
$ADB_CMD pull "$DEVICE_SCREENSHOT" "$LOCAL_SCREENSHOT" > /dev/null 2>&1
$ADB_CMD shell rm -f "$DEVICE_SCREENSHOT" > /dev/null 2>&1

# Dump UI hierarchy
$ADB_CMD shell uiautomator dump "$DEVICE_UI_DUMP" > /dev/null 2>&1
$ADB_CMD pull "$DEVICE_UI_DUMP" "$LOCAL_UI_DUMP" > /dev/null 2>&1
$ADB_CMD shell rm -f "$DEVICE_UI_DUMP" > /dev/null 2>&1

# Cleanup old debug directories (keep max 5)
echo ""
echo "Cleaning up old debug directories..."

# Get list of android_debug directories sorted by time (oldest first)
DEBUG_DIRS=$(ls -1dt /tmp/android_debug_* 2>/dev/null || true)
DIR_COUNT=$(echo "$DEBUG_DIRS" | grep -c . 2>/dev/null || echo "0")

if [ "$DIR_COUNT" -gt 5 ]; then
    # Delete oldest directories (skip current one)
    echo "$DEBUG_DIRS" | tail -n +6 | while read dir; do
        if [ "$dir" != "$DEBUG_DIR" ] && [ -d "$dir" ]; then
            rm -rf "$dir"
            echo "  Deleted: $dir"
        fi
    done
fi

# Output result
echo ""
echo "=========================================="
echo "Debug files saved to: $DEBUG_DIR"
echo "  - screenshot.png"
echo "  - ui_dump.xml"
echo ""
echo "Use Read tool to view these files:"
echo "  Read: $LOCAL_SCREENSHOT"
echo "  Read: $LOCAL_UI_DUMP"
echo "=========================================="
