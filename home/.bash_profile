# Configures the Bash shell environment for this user.

# -----------------------------------------------------------------
# SECTION 0: AUTOMATIC SYNC
# -----------------------------------------------------------------
# Defines the location of the Git repository for dotfiles.
# CORRECTED PATH: using ~/dotfiles instead of ~/Projects/dotfiles
REPO_FILE="$HOME/dotfiles/home/.bash_profile"
REPO_DIR="$HOME/dotfiles"

# Only attempt sync if the repo file actually exists (Fixes Issue #17/#25)
if [ -f "$REPO_FILE" ]; then
    if ! diff -q "$HOME/.bash_profile" "$REPO_FILE" > /dev/null 2>&1; then
        echo "SYNC: Changes detected in ~/.bash_profile. Synchronizing to Git source..." >&2
        cp "$HOME/.bash_profile" "$REPO_FILE"
        # Auto-commit and push (runs in background to not slow shell startup)
        (
            cd "$REPO_DIR" &&
            git add home/.bash_profile &&
            git commit -m "auto: sync .bash_profile $(date +%Y-%m-%d_%H-%M-%S)" &&
            git push origin main
        ) > /dev/null 2>&1 &
        echo "✅ Sync complete (auto-commit in background)." >&2
    fi
fi

# -----------------------------------------------------------------
# SECTION 1: PERSISTENT COMMAND HISTORY
# -----------------------------------------------------------------
# Do not save duplicate commands or trivial commands in history.
export HISTCONTROL=ignoreboth:erasedups

# Set a large history file size.
export HISTSIZE=10000
export HISTFILESIZE=20000

# Append to the history file, do not overwrite it on session exit.
shopt -s histappend

# Set PROMPT_COMMAND to append the last command to history immediately.
export PROMPT_COMMAND="history -a"

# Define the persistent history file location.
export HISTFILE=~/.bash_history

# -----------------------------------------------------------------
# SECTION 2: ALIASES & FUNCTIONS
# -----------------------------------------------------------------
# Alias for a 2-level directory tree view, ignoring .git.
alias llt='tree -a -L 2 -I .git'

# History helper (Issue #24)
# Usage: h [lines] (defaults to 20)
h() {
    local lines=${1:-20}
    # Sets format to: YYYY-MM-DD HH:MM:SS (followed by 3 spaces)
    HISTTIMEFORMAT="%F %T    " history | tail -n "$lines" | cut -c 1-"$(tput cols)"
}

# -----------------------------------------------------------------
# SECTION 3: CUSTOM PROMPT
# -----------------------------------------------------------------
# Generate the Octocat glyph safely (bypassing \u expansion)
OCTOCAT=$(printf '\uf113')

# Colors: Green Date/Time, Cyan Path, Yellow Branch
# Symbol: Octocat (Generated via variable)
export PS1="\[\033[32m\][\D{%m-%d} \t] \[\033[36m\]\w\[\033[33m\]\$(__git_ps1 ' (%s)')\[\033[0m\] $OCTOCAT "

# -----------------------------------------------------------------
# SECTION 4: AGENTOS
# -----------------------------------------------------------------

# Load S-e-c-r-e-t-s
if [ -f ~/.agentos_secrets ]; then
    source ~/.agentos_secrets
fi

# Load AgentOS environment (LangSmith, etc.)
if [ -f ~/.agentos/env ]; then
    source ~/.agentos/env
fi

# Editor Alias
alias subl="/c/Program\ Files/Sublime\ Text/subl.exe"

# SENTINEL - Security Gatekeeper
sentinel() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/sentinel.py --cwd "$PROJECT_PATH" "$@")
}

# UNLEASHED - Tier System (prod / beta / alpha)
# Mapping: prod=c-24, beta=(none), alpha=c-25
# Last promotion: 2026-02-23 prod←c-24 (auto-tab-naming)
# See: https://github.com/martymcenroe/unleashed/wiki/Version-Promotions

_unleashed_log() {
  local script="$1"
  local project_path="$2"
  local tier="unknown"
  case "${FUNCNAME[2]}" in
    unleashed) tier="prod" ;;
    unleashed-beta) tier="beta" ;;
    unleashed-alpha) tier="alpha" ;;
  esac
  local version
  version=$(echo "$script" | sed -n 's/.*c-\([0-9]*\).*/\1/p')
  printf '%s\t%s\t%s\tc-%s\n' \
    "$(date -Iseconds)" "$tier" "$project_path" "$version" \
    >> ~/.unleashed-usage.log
}

_unleashed_run() {
  local script="$1"; shift
  local project_path
  project_path="$(cygpath -w "$(pwd)")"
  _unleashed_log "$script" "$project_path"
  (cd /c/Users/mcwiz/Projects/unleashed && poetry run python "$script" --cwd "$project_path" "$@")
}

unleashed() {
  _unleashed_run src/unleashed-c-25.py --sentinel-shadow --mirror --friction "$@"
}

unleashed-beta() {
  echo "No beta version configured. Promote a new build with: unleashed-alpha → unleashed-beta"
  return 1
}

unleashed-alpha() {
  echo "No alpha version configured. Promote a new build with: create new version → unleashed-alpha"
  return 1
}

# --- Gemini tier system ---
# Prod: g-19 (triplet + 0.2s approval delay + 3 permission patterns)
unleashed-g() {
  _unleashed_run src/unleashed-g-19.py "$@"
}

unleashed-t() {
  _unleashed_run src/unleashed-t-01.py "$@"
}

# BATCH WORKFLOW - Run multiple issues unattended
alias batch-workflow='/c/Users/mcwiz/Projects/AssemblyZero/tools/batch-workflow.sh'

# -----------------------------------------------------------------
# SECTION 5: AUTOMATION SCRIPTS
# -----------------------------------------------------------------
# Utility for opening URLs from markdown files in Firefox
alias open-pages="python /c/Users/mcwiz/Projects/automation-scripts/tools/open-pages.py"
