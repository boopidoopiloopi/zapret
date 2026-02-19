#!/bin/bash

# Stop the script if any command fails
set -e

# Determine the directory where this script is stored
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

REPO_URL="https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git"
TEMP_DIR=$(mktemp -d)

echo "--- Starting Initialization ---"
echo "Target Directory: $BASE_DIR"

# ---------------------------------------------------------
# 1. CLONE & MERGE
# ---------------------------------------------------------
echo "1. Cloning external repository..."
git clone "$REPO_URL" "$TEMP_DIR"

# Remove the .git folder from the downloaded files
rm -rf "$TEMP_DIR/.git"

# Copy all files from temp dir to BASE_DIR without overwriting existing local files (-n)
cp -rn "$TEMP_DIR"/. "$BASE_DIR/" 2>/dev/null || true

# Clean up temporary directory
rm -rf "$TEMP_DIR"
echo "   Repository content merged successfully."

# ---------------------------------------------------------
# 2. APPLY CUSTOMIZATIONS
# ---------------------------------------------------------
echo "2. Applying custom files..."

# --- Replace main_script.sh ---
SOURCE_SCRIPT="$BASE_DIR/boopishit/main_script.sh"
TARGET_SCRIPT="$BASE_DIR/main_script.sh"

if [ -f "$SOURCE_SCRIPT" ]; then
    cp -f "$SOURCE_SCRIPT" "$TARGET_SCRIPT"
    chmod +x "$TARGET_SCRIPT"
    echo "   [OK] main_script.sh replaced."
else
    echo "   [ERROR] $SOURCE_SCRIPT not found!"
    exit 1
fi

# --- Copy general-zoopi.bat ---
SOURCE_BAT="$BASE_DIR/boopishit/custom-bats/general-zoopi.bat"
TARGET_BAT_DIR="$BASE_DIR/custom-strategies"
TARGET_BAT="$TARGET_BAT_DIR/general-zoopi.bat"

if [ -f "$SOURCE_BAT" ]; then
    mkdir -p "$TARGET_BAT_DIR"
    cp -f "$SOURCE_BAT" "$TARGET_BAT"
    echo "   [OK] general-zoopi.bat copied."
else
    echo "   [WARNING] $SOURCE_BAT not found. Skipping."
fi

# ---------------------------------------------------------
# 3. LAUNCH
# ---------------------------------------------------------
echo "--- Initialization Complete. Launching main_script.sh ---"

# Execute the main script
"$TARGET_SCRIPT"
