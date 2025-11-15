#!/bin/bash
# --- Architect's Note ---
# This is your "daily driver" script for the green matrix.
# Its job is to copy the "live" config files *from* your system
# *into* this Git repo, then commit and push the changes.

set -e # Exit immediately if any command fails

echo "--- Starting Configuration Save ---"

# --- 1. Define Paths ---
# Get the root of this git repo
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "Repo source directory is: $SCRIPT_DIR"

# --- 2. List Configs to Save ---
# We define "live" source paths and "repo" destination paths.

# .bash_profile
BASH_PROFILE_SRC="$HOME/.bash_profile"
BASH_PROFILE_DEST="$SCRIPT_DIR/home/.bash_profile"

# Windows Terminal settings
WT_SETTINGS_SRC="$USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
WT_SETTINGS_DEST="$SCRIPT_DIR/windows/terminal/settings.json"


# --- 3. Copy Configs INTO Repo ---
# We use 'cp -v' (verbose) to see what's happening.

echo "Saving .bash_profile..."
cp -v "$BASH_PROFILE_SRC" "$BASH_PROFILE_DEST"

echo "Saving Windows Terminal settings..."
# Check if the live file exists before trying to copy
if [ -f "$WT_SETTINGS_SRC" ]; then
  cp -v "$WT_SETTINGS_SRC" "$WT_SETTINGS_DEST"
else
  echo "Info: Live settings.json not found, skipping."
  echo "      (This is normal if Windows Terminal hasn't been run)."
fi


# --- 4. Commit and Push ---
echo "--- Committing and Pushing Changes ---"
cd "$SCRIPT_DIR" || exit

# Check for changes
if [[ -z $(git status --porcelain) ]]; then
  echo "✅ No config changes detected. You are all up to date."
  exit 0
fi

git pull --rebase # Always pull before pushing

git add .
# We'll use a standardized commit message for these automated updates.
git commit -m "chore(system): update dotfiles"
git push

echo "✅ New configurations saved and pushed to GitHub."