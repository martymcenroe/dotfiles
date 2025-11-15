#!/bin/bash
# --- Architect's Note ---
# This is the main setup script for a new machine.
# It performs two key functions:
# 1. Installs all required applications via winget (Idempotent).
# 2. Copies all version-controlled config files from this repo
#    to their 'live' locations in the user's home directory.

# --- 1. App Installation (via winget) ---
# We use winget to install our core command-line tools.
# The '-e' flag means 'exact match' to avoid ambiguity.

echo "--- Installing Core Apps via winget --- "
winget install --id Git.Git -e --source winget
winget install --id GnuWin32.Tree -e --source winget
winget install --id Sublime.SublimeText -e --source winget
winget install --id Microsoft.VisualStudioCode -e --source winget
winget install --id GitHub.cli -e --source winget
winget install --id jqlang.jq -e --source winget
echo "✅ Core apps installed."
echo ""


# --- 2. Configuration File Deployment ---
# This copies our configs from the repo to their live locations.
# We define the source (repo) and destination (live) paths.

# The root of this git repo
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "Repo source directory is: $SCRIPT_DIR"

# We use 'cp -v' (verbose) to see what's happening.

echo "--- Deploying Config Files --- "

# Deploy .bash_profile
echo "Deploying .bash_profile..."
cp -v "$SCRIPT_DIR/home/.bash_profile" "$HOME/.bash_profile"

# Deploy Windows Terminal settings
# We must use the full, verbose Windows path here.
echo "Deploying Windows Terminal settings.json..."
WT_SETTINGS_DIR="$USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
mkdir -p "$WT_SETTINGS_DIR"
# We check if the settings.json exists in the repo first
if [ -f "$SCRIPT_DIR/windows/terminal/settings.json" ]; then
  cp -v "$SCRIPT_DIR/windows/terminal/settings.json" "$WT_SETTINGS_DIR/settings.json"
else
  echo "Info: windows/terminal/settings.json not found in repo, skipping."
fi


echo ""
echo "✅ Config file deployment complete."
echo "!!! Please CLOSE and RE-OPEN your terminal to see all changes!"