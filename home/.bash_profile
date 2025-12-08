# Configures the Bash shell environment for this user.

# -----------------------------------------------------------------
# SECTION 0: AUTOMATIC SYNC
# -----------------------------------------------------------------
# Defines the location of the Git repository for dotfiles.
# CORRECTED PATH: using ~/dotfiles instead of ~/Projects/dotfiles
REPO_FILE="$HOME/dotfiles/home/.bash_profile"

# Only attempt sync if the repo file actually exists (Fixes Issue #17/#25)
if [ -f "$REPO_FILE" ]; then
    if ! diff -q "$HOME/.bash_profile" "$REPO_FILE" > /dev/null 2>&1; then
        echo "SYNC: Changes detected in ~/.bash_profile. Synchronizing to Git source..." >&2
        cp "$HOME/.bash_profile" "$REPO_FILE"
        echo "✅ Sync complete." >&2
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
    HISTTIMEFORMAT="%F %T   " history | tail -n "$lines" | cut -c 1-"$(tput cols)"
}

# -----------------------------------------------------------------
# SECTION 3: CUSTOM PROMPT
# -----------------------------------------------------------------
# Generate the Octocat glyph safely (bypassing \u expansion)
OCTOCAT=$(printf '\uf113')

# Colors: Green Date/Time, Cyan Path, Yellow Branch
# Symbol: Octocat (Generated via variable)
export PS1="\[\033[32m\][\D{%m-%d} \t] \[\033[36m\]\w\[\033[33m\]\$(__git_ps1 ' (%s)')\[\033[0m\] $OCTOCAT "