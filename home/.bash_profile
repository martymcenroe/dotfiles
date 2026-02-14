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
export PS1="\[\033[32m\][\D{%m-%d} 	] \[\033[36m\]\w\[\033[33m\]\$(__git_ps1 ' (%s)')\[\033[0m\] $OCTOCAT "

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

# UNLEASHED - Autonomous Coding (v18, shell functions for arg passthrough)
unleashed() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-18.py --cwd "$PROJECT_PATH" "$@")
}

unleashed-test() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-test.py --cwd "$PROJECT_PATH" "$@")
}

# UNLEASHED-C (Claude) — v18 functions with arg passthrough
unleashed-c() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-18.py --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-18() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-18.py --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-18-mirror() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-18.py --mirror --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-18-triplet() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-18.py --mirror --friction --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-18-joint() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-18.py --joint-log --friction --cwd "$PROJECT_PATH" "$@")
}

# UNLEASHED-C (Claude) — v21 functions with arg passthrough
unleashed-c-21() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-21.py --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-21-mirror() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-21.py --mirror --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-21-triplet() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-21.py --mirror --friction --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-21-joint() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-21.py --joint-log --friction --cwd "$PROJECT_PATH" "$@")
}

# UNLEASHED-C (Claude) — v20 functions with arg passthrough
unleashed-c-20() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-20.py --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-20-mirror() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-20.py --mirror --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-20-triplet() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-20.py --mirror --friction --cwd "$PROJECT_PATH" "$@")
}

unleashed-c-20-joint() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-20.py --joint-log --friction --cwd "$PROJECT_PATH" "$@")
}

# UNLEASHED-C (Claude) — v19 function (v16-based, transcript only, no mirror/friction)
unleashed-c-19() {
  (PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-19.py --cwd "$PROJECT_PATH" "$@")
}

# UNLEASHED-C (Claude) LEGACY ALIASES (v17 and below, no passthrough)
alias unleashed-c-17='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-17.py --cwd "$PROJECT_PATH")'
alias unleashed-c-16='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-16.py --cwd "$PROJECT_PATH")'
alias unleashed-c-15='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-15.py --cwd "$PROJECT_PATH")'
alias unleashed-c-14='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-14.py --cwd "$PROJECT_PATH")'
alias unleashed-c-13='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-13.py --cwd "$PROJECT_PATH")'
alias unleashed-c-12='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-12.py --cwd "$PROJECT_PATH")'
alias unleashed-c-11='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-11.py --cwd "$PROJECT_PATH")'
alias unleashed-c-10='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-10.py --cwd "$PROJECT_PATH")'
alias unleashed-c-09='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-09.py --cwd "$PROJECT_PATH")'
alias unleashed-c-08='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-08.py --cwd "$PROJECT_PATH")'
alias unleashed-c-07='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-c-07.py --cwd "$PROJECT_PATH")'

# UNLEASHED-G (Gemini) VERSIONED (2-digit: 17 and above)
alias unleashed-g='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g.py --cwd "$PROJECT_PATH")'
alias unleashed-g-17='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-17.py --cwd "$PROJECT_PATH")'
alias unleashed-g-18='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-18.py --cwd "$PROJECT_PATH")'
alias unleashed-g-19='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-19.py --cwd "$PROJECT_PATH")'
alias unleashed-g-20='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-20.py --cwd "$PROJECT_PATH")'
alias unleashed-g-21='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-21.py --cwd "$PROJECT_PATH")'
alias unleashed-g-22='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-22.py --cwd "$PROJECT_PATH")'
alias unleashed-g-23='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-23.py --cwd "$PROJECT_PATH")'
alias unleashed-g-24='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-24.py --cwd "$PROJECT_PATH")'
alias unleashed-g-25='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-25.py --cwd "$PROJECT_PATH")'
alias unleashed-g-26='(PROJECT_PATH="$(cygpath -w "$(pwd)")" && cd /c/Users/mcwiz/Projects/unleashed && poetry run python src/unleashed-g-26.py --cwd "$PROJECT_PATH")'

# AGENTOS BATCH WORKFLOW - Run multiple issues unattended
# Usage: batch-workflow --type <issue|lld|impl> [--gates none|auto] [--yes] [--continue-on-fail] <issues> 
alias batch-workflow='/c/Users/mcwiz/Projects/AgentOS/tools/batch-workflow.sh'
 
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 #   S E C T I O N   5 :   A U T O M A T I O N   S C R I P T S  
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
 #   U t i l i t y   f o r   o p e n i n g   U R L s   f r o m   m a r k d o w n   f i l e s   i n   F i r e f o x  
 a l i a s   o p e n - p a g e s = " p y t h o n   / c / U s e r s / m c w i z / P r o j e c t s / a u t o m a t i o n - s c r i p t s / t o o l s / o p e n - p a g e s . p y "  
 