#!/bin/bash
# --- Architect's Note ---
# This script adds copyright notices to code files in bulk.
# It finds code files and adds a copyright header *only*
# if no other copyright notice is already present.

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
# We must 'cd' into the repo for 'git commit' to work.
cd "$PROJECT_DIR" || exit

# --- For Python files (.py) ---
find . -type f -name "*.py" -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="# $COPYRIGHT_NOTICE"
  # --- FIX: Implement 2-step safety check ---
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    # My notice isn't present. Now, check for *any* copyright.
    if ! grep -iq 'copyright' "$file"; then
      # No other copyright found. SAFE TO ADD.
      echo "Adding copyright to: $file"
      sed -i "1i$COMMENT_NOTICE\n" "$file"
      git add "$file"
      git commit -m "style(license): add copyright header to $file"
    else
      # A different copyright was found. DO NOT TOUCH.
      echo "Skipping (EXISTING copyright found): $file"
    fi
  else
    # My notice is already present.
    echo "Skipping (my notice already present): $file"
  fi
done

# --- For JS/TS files (.js, .ts) ---
find . -type f \( -name "*.js" -o -name "*.ts" \) -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="// $COPYRIGHT_NOTICE"
  # --- FIX: Implement 2-step safety check ---
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    if ! grep -iq 'copyright' "$file"; then
      echo "Adding copyright to: $file"
      sed -i "1i$COMMENT_NOTICE\n" "$file"
      git add "$file"
      git commit -m "style(license): add copyright header to $file"
    else
      echo "Skipping (EXISTING copyright found): $file"
    fi
  else
    echo "Skipping (my notice already present): $file"
  fi
done

# --- For HTML/Markdown files (.html, .md) ---
find . -type f \( -name "*.html" -o -name "*.md" \) -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="<!-- $COPYRIGHT_NOTICE -->"
  # --- FIX: Implement 2-step safety check ---
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    if ! grep -iq 'copyright' "$file"; then
      echo "Adding copyright to: $file"
      sed -i "1i$COMMENT_NOTICE\n" "$file"
      git add "$file"
      git commit -m "style(license): add copyright header to $file"
    else
      echo "Skipping (EXISTING copyright found): $file"
    fi
  else
    echo "Skipping (my notice already present): $file"
  fi
done

# --- For SQL files (.sql) ---
find . -type f -name "*.sql" -not -path "./.git/*" | while read -r file; do
  COMMENT_NOTICE="-- $COPYRIGHT_NOTICE"
  # --- FIX: Implement 2-step safety check ---
  if ! grep -q "$COPYRIGHT_NOTICE" "$file"; then
    if ! grep -iq 'copyright' "$file"; then
      echo "Adding copyright to: $file"
      sed -i "1i$COMMENT_NOTICE\n" "$file"
      git add "$file"
      git commit -m "style(license): add copyright header to $file"
    else
      echo "Skipping (EXISTING copyright found): $file"
    fi
  else
    echo "Skipping (my notice already present): $file"
  fi
done

# --- 4. Final Push ---
echo "--- Pushing all new commits ---"
git push

echo "✅ Copyright update complete for: $PROJECT_DIR"