#!/bin/bash

# Stop the script if any command fails
set -e

REPO_URL="https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git"
TEMP_DIR=$(mktemp -d)

echo "--- Starting Initialization ---"

# 1. Clone the repo to a temporary directory
echo "1. Cloning external repository..."
git clone "$REPO_URL" "$TEMP_DIR"

# Remove the .git folder from the downloaded files
# (This prevents overwriting your own repo's git history)
rm -rf "$TEMP_DIR/.git"

# Copy all files from the temp dir to the current directory (.)
# This effectively merges the downloaded files with your existing files
cp -rn "$TEMP_DIR"/* . 2>/dev/null || true
# Note: -n prevents overwriting your existing files (like initialize.sh or boopishit folder)
# if the downloaded repo happens to have files with the same name.

# Clean up temporary directory
rm -rf "$TEMP_DIR"
echo "   Repository content merged successfully."

# 2. Replace main_script.sh
echo "2. replacing main_script.sh..."

if [ -f "boopishit/main_script.sh" ]; then
    # Remove the one that came from the clone (optional as cp overwrites, but added for clarity)
    if [ -f "main_script.sh" ]; then
        rm "main_script.sh"
    fi
    
    # Copy your custom script to the root
    cp "boopishit/main_script.sh" "main_script.sh"
    
    # Make sure it is executable
    chmod +x "main_script.sh"
    echo "   main_script.sh has been replaced with your custom version."
else
    echo "   Error: boopishit/main_script.sh not found!"
    exit 1
fi

echo "--- Initialization Complete ---"
