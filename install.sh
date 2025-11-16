#!/bin/bash
# This script performs a full, idempotent setup of a Windows 11
# development environment.

# -----------------------------------------------------------------
# SECTION 1: CORE APPLICATION INSTALLATION (WINGET)
# -----------------------------------------------------------------
echo "--- Installing Core Applications (winget) ---"
winget install --id Git.Git -e --source winget
winget install --id GnuWin32.Tree -e --source winget
winget install --id Microsoft.VisualStudioCode -e --source winget
winget install --id GitHub.cli -e --source winget
winget install --id jqlang.jq -e --source winget
winget install --id Sublime.SublimeText -e --source winget

# Install "N" and "N-1" Python versions (N-2 Policy)
# This establishes our base interpreters.
winget install --id Python.Python.3.14 -e --silent
winget install --id Python.Python.3.13 -e --silent

# Install Java Runtime (JRE) for SonarLint
# This is a required dependency for the SonarLint VSCode extension.
winget install --id EclipseAdoptium.Temurin.17.JRE -e --silent

echo "✅ Core applications installed."
echo ""

# -----------------------------------------------------------------
# SECTION 2: VSCODE EXTENSION INSTALLATION
# -----------------------------------------------------------------
echo "--- Installing VSCode Extensions ---"
# Defines the list of extensions, organized by professional stack.
EXTENSIONS=(
    # 1. GENERAL & AI
    "eamodio.gitlens"
    "github.copilot"
    "github.copilot-chat"
    # 2. WEB & FORMATTING
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    # 3. PYTHON (LOCAL)
    "ms-python.python"
    "ms-python.black-formatter"
    "ms-python.flake8"
    # 4. AI / RAG / JUPYTER
    "ms-toolsai.jupyter"
    "genieai.chatgpt-vscode"
    "yzhang.markdown-all-in-one"
    # 5. CORE LANGUAGES
    "ms-vscode.cpptools-extension-pack"
    "mtxr.sqltools"
    # 6. CLOUD & DEVOPS
    "amazonwebservices.aws-toolkit-vscode"
    "ms-vscode.azure-account"
    "ms-azuretools.vscode-azureresourcegroups" # FIX: 'vscode-azure-general' is stale.
    "GoogleCloudTools.cloudcode"
    "google.geminicodeassist" # FIX: 'Google.gemini-code-assist' is stale.
    "ms-azuretools.vscode-docker"
    "SonarSource.sonarlint-vscode"
    # 7. DATA & SPECIALTY
    "Snowflake.snowflake-vsc" # FIX: 'snowflake-vscode-extension' is stale.
    "Redis.redis-for-vscode" # FIX: 'ms-azuretools.vscode-redis' is stale.
)

# Loop and install each extension.
for EXTENSION in "${EXTENSIONS[@]}"; do
    echo "Installing $EXTENSION..."
    # --force ensures it updates if already installed
    code --install-extension "$EXTENSION" --force
done
echo "✅ VSCode Extensions installed."
echo ""

# -----------------------------------------------------------------
# SECTION 3: PYTHON ENVIRONMENT TOOLING
# -----------------------------------------------------------------
echo "--- Configuring Python Tooling ---"

echo "Installing pipx (Global Tool Manager) into 'N' Python..."
# This installs pipx into the user-level scripts of the 'N'
# version (3.14), as per our "rolling" architecture.
# We use 'python.exe' to be explicit, as 'python' may be the
# 'python3' symlink which hasn't been created yet.
python.exe -m pip install --user pipx

echo "Bootstrapping pipx: Adding to Windows Registry PATH..."
# This ensures pipx is on the PATH for all *future* sessions.
python.exe -m pipx ensurepath

echo "Installing Poetry (Project Manager) via official installer..."
# This uses the mandated official installer, which is independent
# of pipx and manages its own environment.
curl -sSL https://install.python-poetry.org | python.exe -

echo "✅ Python tooling configured."
echo ""

# -----------------------------------------------------------------
# SECTION 4: POST-INSTALL ALIASES & FIXES
# -----------------------------------------------------------------
echo "--- Applying Post-Install Fixes ---"

echo "Creating 'python3' symlink..."
# Fixes the "opposite behavior" by creating a 'python3.exe' alias
# pointing to the primary 'python.exe' (N version).
# We must find the "ground truth" path.
PYTHON_EXE_PATH=$(where python | head -n 1)
PYTHON_DIR=$(dirname "$PYTHON_EXE_PATH")
if [ -f "$PYTHON_EXE_PATH" ] && [ ! -f "$PYTHON_DIR/python3.exe" ]; then
  ln -s "$PYTHON_EXE_PATH" "$PYTHON_DIR/python3.exe"
  echo "Symlink created: python3.exe -> python.exe"
else
  echo "Info: python3.exe symlink already exists or python.exe not found."
fi

echo "Upgrading default pip..."
python.exe -m pip install --upgrade pip

echo ""

# -----------------------------------------------------------------
# SECTION 5: CONFIGURATION FILE DEPLOYMENT
# -----------------------------------------------------------------
echo "--- Deploying Config Files from Repo --- "

# Get the root directory of this script.
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
echo "!!! Please CLOSE and RE-OPEN your terminal for all changes to take effect!"