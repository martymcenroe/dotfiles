#!/bin/bash
# --- Architect's Note ---

# It takes one argument: the path to a project directory.
# It finds all code files, adds a copyright header (if missing),
# and creates a *separate commit for each file*.


set -e # Exit immediately if any command fails

# --- 1. Configuration ---
YEAR=$(date +%Y)
COPYRIGHT_NOTICE="Copyright (c) $YEAR Marty McEnroe. All rights reserved."

# --- 2. Input Validation ---
if [ -z "$1" ]; then
  echo "ERROR: No project directory specified."
  echo "Usage: ./bulk-copyright.sh /path/to/your/project"
  exit 1
fi

PROJECT_DIR=$1
echo "--- Starting Copyright Audit for: $PROJECT_DIR ---"

# --- 3. The Engine ---
# We use 'find' to locate all files of a specific type.
# We must 'cd' into the repo for 'git commit' to work.
cd "$PROJECT_DIR" || exit

# We process each file type separately.

# --- For Python files (.py) ---
find . -type f -name "*.py" -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="# $COPYRIGHT_NOTICE"
  # Use 'grep -q' (quiet) to check if the notice already exists
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    echo "Adding copyright to: $file"
    # 'sed -i 1i' inserts the text at line 1
    sed -i "1i$COMMENT_NOTICE\n" "$file"
    git add "$file"
    git commit -m "style(license): add copyright header to $file"
  else
    echo "Skipping (already present): $file"
  fi
done

# --- For JS/TS files (.js, .ts) ---
find . -type f \( -name "*.js" -o -name "*.ts" \) -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="// $COPYRIGHT_NOTICE"
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    echo "Adding copyright to: $file"
    sed -i "1i$COMMENT_NOTICE\n" "$file"
    git add "$file"
    git commit -m "style(license): add copyright header to $file"
  else
    echo "Skipping (already present): $file"
  fi
done

# --- For HTML/Markdown files (.html, .md) ---
find . -type f \( -name "*.html" -o -name "*.md" \) -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="<!-- $COPYRIGHT_NOTICE -->"
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    echo "Adding copyright to: $file"
    sed -i "1i$COMMENT_NOTICE\n" "$file"
    git add "$file"
    git commit -m "style(license): add copyright header to $file"
  else
    echo "Skipping (already present): $file"
  fi
done

# --- 4. Final Push ---
echo "--- Pushing all new commits ---"
git push

echo "✅ Copyright update complete for: $PROJECT_DIR"