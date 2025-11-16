#!/bin/bash
# --- Architect's Note ---
# This is the main setup script for a new machine.
# It performs two key functions:
# 1. Installs all required applications via winget (Idempotent).
# 2. Copies all version-controlled config files from this repo
#    to their 'live' locations in the user's home directory.

# --- 1. App Installation (via winget) ---
echo "--- Installing Core Apps via winget --- "
winget install --id Git.Git -e --source winget
winget install --id GnuWin32.Tree -e --source winget
winget install --id Microsoft.VisualStudioCode -e --source winget
winget install --id GitHub.cli -e --source winget
winget install --id jqlang.jq -e --source winget
winget install --id Sublime.SublimeText -e --source winget
winget install --id Python.Python.3.12 -e
winget install --id Python.Poetry -e
echo "✅ Core apps installed."
echo ""

# --- 2. VSCode Extension Installation ---
echo "--- Installing VSCode Extensions ---"
# We define our list of essential extensions, organized by professional stack.
EXTENSIONS=(
    # ----------------------------------------
    # 1. GENERAL & AI
    # ----------------------------------------
    "eamodio.gitlens"
    "github.copilot"
    "github.copilot-chat"

    # ----------------------------------------
    # 2. WEB & FORMATTING
    # ----------------------------------------
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"

    # ----------------------------------------
    # 3. PYTHON (LOCAL)
    # ----------------------------------------
    "ms-python.python"
    "ms-python.black-formatter"
    "ms-python.flake8"

    # ----------------------------------------
    # 4. AI / RAG / JUPYTER (from your stack)
    # ----------------------------------------
    "ms-toolsai.jupyter"
    "genieai.chatgpt-vscode"
    "yzhang.markdown-all-in-one"

    # ----------------------------------------
    # 5. CORE LANGUAGES (from your stack)
    # ----------------------------------------
    "ms-vscode.cpptools-extension-pack"
    "mtxr.sqltools"

    # ----------------------------------------
    # 6. CLOUD & DEVOPS (from your stack)
    # ----------------------------------------
    "amazonwebservices.aws-toolkit-vscode"
    "ms-vscode.azure-account"
    "ms-azuretools.vscode-azure-general"
    "GoogleCloudTools.cloudcode"
    "ms-azuretools.vscode-docker"
    "SonarSource.sonarlint-vscode"

    # ----------------------------------------
    # 7. DATA & SPECIALTY (from your stack)
    # ----------------------------------------
    "Snowflake.snowflake-vscode-extension"
    "ms-azuretools.vscode-redis"
)

# We loop through the list and install each one
for EXTENSION in "${EXTENSIONS[@]}"; do
    echo "Installing $EXTENSION..."
    # --force ensures it updates if already installed
    code --install-extension "$EXTENSION" --force
done
echo "✅ VSCode Extensions installed."
echo ""

# --- 3. Python Environment Setup ---
# This section mirrors our "Python-for-Python" architecture
echo "--- Configuring Python Environment ---"

echo "Installing pipx (Python Tool Manager)..."
# Use 'python -m pip' to be explicit, honoring our "ground truth"
python -m pip install --user pipx
python -m pipx ensurepath

echo "Installing Poetry (Project Manager)..."
# We use the official, Python-based installer
curl -sSL https://install.python-poetry.org | python -

echo ""

# --- 4. Post-Install Configuration Fixes ---
echo "--- Applying Post-Install Fixes ---"

# Architect's Note: Fix the "python vs python3" friction.
# Create a 'python3.exe' symlink pointing to our real 'python.exe'.
# This ensures 'python3' resolves to our official install, not the MS-Store stub.
echo "Creating python3 symlink..."
PYTHON_DIR=$(dirname $(where python | head -n 1))
if [ -f "$PYTHON_DIR/python.exe" ] && [ ! -f "$PYTHON_DIR/python3.exe" ]; then
  ln -s "$PYTHON_DIR/python.exe" "$PYTHON_DIR/python3.exe"
  echo "Symlink created: python3.exe -> python.exe"
else
  echo "Info: python3.exe symlink already exists or python.exe not found."
fi

echo ""

# --- 5. Configuration File Deployment ---
# This copies our configs from the repo to their live locations.
echo "--- Deploying Config Files --- "

# The root of this git repo
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "Repo source directory is: $SCRIPT_DIR"

# Deploy .bash_profile
echo "Deploying .bash_profile..."
cp -v "$SCRIPT_DIR/home/.bash_profile" "$HOME/.bash_profile"

# Deploy Windows Terminal settings
echo "Deploying Windows Terminal settings.json..."
WT_SETTINGS_DIR="$USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
mkdir -p "$WT_SETTINGS_DIR"
if [ -f "$SCRIPT_DIR/windows/terminal/settings.json" ]; then
  cp -v "$SCRIPT_DIR/windows/terminal/settings.json" "$WT_SETTINGS_DIR/settings.json"
else
  echo "Info: windows/terminal/settings.json not found in repo, skipping."
fi


echo ""
echo "✅ Config file deployment complete."
echo "!!! Please CLOSE and RE-OPEN your terminal to see all changes!"