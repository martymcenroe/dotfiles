#!/bin/bash
# Idempotent setup of a Windows 11 development environment.
#
# IDEMPOTENT MEANS IDEMPOTENT. `winget install <id>` on an already-present
# package RE-RUNS the installer -- that is NOT a no-op: it can throw an
# unknown-publisher/UAC prompt (GnuWin32 packages are unsigned), change the
# installed version, or pull in co-packages. `code --install-extension --force`
# likewise re-installs every extension on every run. So this script now PROBES
# for each thing first -- presence, and version where it matters -- and skips
# what is already satisfied. It changes nothing it does not have to.

have() { command -v "$1" >/dev/null 2>&1; }

# wgi <winget-id> <probe> [<dir-to-test-instead-of-command>]
# If <dir> is given, presence is tested by that directory existing (for GUI
# apps like Sublime that do not put a command on PATH). Otherwise by command.
wgi() {
  local id="$1" probe="$2" dir="${3:-}"
  if [ -n "$dir" ]; then
    if [ -e "$dir" ]; then echo "  [skip] $id present ($dir)"; return; fi
  elif have "$probe"; then
    echo "  [skip] $probe present ($("$probe" --version 2>/dev/null | head -1))"; return
  fi
  echo "  [install] $id ..."
  winget install --id "$id" -e --source winget \
    --accept-source-agreements --accept-package-agreements
}

# -----------------------------------------------------------------
# SECTION 1: CORE APPLICATION INSTALLATION (WINGET) -- probe-first
# -----------------------------------------------------------------
echo "--- Core Applications (winget, idempotent) ---"
wgi Git.Git                    git
wgi GnuWin32.Tree              tree "/c/Program Files (x86)/GnuWin32/bin/tree.exe"
wgi Microsoft.VisualStudioCode code
wgi GitHub.cli                 gh
wgi jqlang.jq                  jq
wgi Sublime.SublimeText        subl "/c/Program Files/Sublime Text"

# Python 3.14 only. The old "N and N-1" line also installed Python 3.13 --
# removed: the fleet is pinned to 3.14 (the unleashed poetry venv path is
# version-locked to py3.14, and a stray 3.13 shadows resolution and litters
# PATH/registry/Start-Menu). See comp-environ #37. Probe by VERSION, not by
# bare `python`, which the Windows Store stub or any 3.x would satisfy.
if py -3.14 --version 2>/dev/null | grep -q "^Python 3\.14"; then
  echo "  [skip] Python 3.14 present ($(py -3.14 --version 2>/dev/null))"
else
  echo "  [install] Python.Python.3.14 ..."
  winget install --id Python.Python.3.14 -e --silent \
    --accept-source-agreements --accept-package-agreements
fi

# Java Runtime (JRE) for the SonarLint VSCode extension.
wgi EclipseAdoptium.Temurin.17.JRE java

echo "Core applications checked."
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

# Install only the extensions NOT already present. The old loop used
# `--install-extension --force` on every entry every run -- that re-installs
# all 22 extensions each time (slow, network-heavy, and not idempotent). Ask
# VSCode what it already has, once, and install only the gaps.
if have code; then
  INSTALLED="$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"
  for EXTENSION in "${EXTENSIONS[@]}"; do
    if echo "$INSTALLED" | grep -qxF "$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')"; then
      echo "  [skip] $EXTENSION"
    else
      echo "  [install] $EXTENSION"
      code --install-extension "$EXTENSION"
    fi
  done
  echo "VSCode extensions checked."
else
  echo "  [warn] 'code' not on PATH -- skipping extensions (open VSCode once, re-run)"
fi
echo ""

# -----------------------------------------------------------------
# SECTION 3: PYTHON ENVIRONMENT TOOLING
# -----------------------------------------------------------------
echo "--- Configuring Python Tooling ---"

# pipx -- only if absent. Re-running `pip install --user pipx` every time is
# another non-idempotent re-do. NOTE: poetry is NOT installed via pipx here
# (that path fails on Windows -- comp-environ #38); poetry uses its official
# installer below. pipx is kept only for other global CLI tools.
if py -3 -m pipx --version >/dev/null 2>&1; then
  echo "  [skip] pipx present ($(py -3 -m pipx --version 2>/dev/null))"
else
  echo "  [install] pipx (into 'N' Python via py -3) ..."
  py -3 -m pip install --user pipx
  py -3 -m pipx ensurepath
fi

echo "Installing Poetry (Project Manager) via official installer..."
# This uses the mandated official installer, which is independent
# of pipx and manages its own environment.
if curl -sSL https://install.python-poetry.org | python.exe -; then
    echo "Poetry installer completed."
    
    # Find where poetry.exe actually installed
    POETRY_EXE=$(find "$APPDATA/pypoetry" -name "poetry.exe" -type f 2>/dev/null | head -n 1)
    
    if [ -n "$POETRY_EXE" ]; then
        POETRY_DIR=$(dirname "$POETRY_EXE")
        # Convert to Windows path format
        POETRY_WIN_PATH=$(cygpath -w "$POETRY_DIR")
        
        echo "Fixing Poetry PATH in Windows Registry..."
        # Remove incorrect Poetry path and add correct one
        powershell.exe -Command "
            \$userPath = [Environment]::GetEnvironmentVariable('Path', 'User');
            \$userPath = \$userPath -replace '[^;]*pypoetry[^;]*;?', '';
            \$userPath = \$userPath.TrimEnd(';');
            \$userPath = \$userPath + ';$POETRY_WIN_PATH';
            [Environment]::SetEnvironmentVariable('Path', \$userPath, 'User');
        "
        
        # Add to current session for immediate verification
        export PATH="$POETRY_DIR:$PATH"
        
        if command -v poetry &> /dev/null; then
            echo "✅ Poetry installed successfully: $(poetry --version)"
        else
            echo "⚠️  Poetry installed but verification failed. Restart terminal."
        fi
    else
        echo "❌ ERROR: Poetry executable not found after installation"
        exit 1
    fi
else
    echo "❌ ERROR: Poetry installation failed"
    exit 1
fi

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

# Deploy .bash_profile. BACK UP any existing one first -- this is a blind
# overwrite of a file the operator edits by hand, and clobbering it without a
# copy is how local work disappears. Skip the copy entirely if it is already
# identical, so a re-run is a true no-op.
echo "Deploying .bash_profile..."
if [ -f "$HOME/.bash_profile" ] && diff -q "$SCRIPT_DIR/home/.bash_profile" "$HOME/.bash_profile" >/dev/null 2>&1; then
  echo "  [skip] .bash_profile already current"
else
  [ -f "$HOME/.bash_profile" ] && cp "$HOME/.bash_profile" "$HOME/.bash_profile.pre-install-$(date +%Y%m%d-%H%M%S)" \
    && echo "  backed up existing .bash_profile"
  cp -v "$SCRIPT_DIR/home/.bash_profile" "$HOME/.bash_profile"
fi

# Deploy Windows Terminal settings, same care: back up before overwrite,
# skip when identical.
echo "Deploying Windows Terminal settings.json..."
WT_SETTINGS_DIR="$USERPROFILE/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
mkdir -p "$WT_SETTINGS_DIR"
if [ -f "$SCRIPT_DIR/windows/terminal/settings.json" ]; then
  if [ -f "$WT_SETTINGS_DIR/settings.json" ] && diff -q "$SCRIPT_DIR/windows/terminal/settings.json" "$WT_SETTINGS_DIR/settings.json" >/dev/null 2>&1; then
    echo "  [skip] Windows Terminal settings already current"
  else
    [ -f "$WT_SETTINGS_DIR/settings.json" ] && cp "$WT_SETTINGS_DIR/settings.json" "$WT_SETTINGS_DIR/settings.json.pre-install-$(date +%Y%m%d-%H%M%S)" \
      && echo "  backed up existing settings.json"
    cp -v "$SCRIPT_DIR/windows/terminal/settings.json" "$WT_SETTINGS_DIR/settings.json"
  fi
else
  echo "Info: windows/terminal/settings.json not found in repo, skipping."
fi

echo ""
echo "Config file deployment complete."
echo ""
echo "!!! To apply all PATH changes, either:"
echo "    1. CLOSE and RE-OPEN your terminal, OR"
echo "    2. Run this command to refresh PATH in current session:"
echo ""
echo "NEW_USER_PATH=\$(powershell.exe -Command '[Environment]::GetEnvironmentVariable(\"Path\", \"User\")' | tr -d '\\r')"
echo "export PATH=\"\$NEW_USER_PATH:\$PATH\""