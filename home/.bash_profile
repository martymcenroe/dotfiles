# Configures the Bash shell environment for this user.

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

# Set PROMPT_COMMAND to append the last command to history immediately,
# ensuring the session history is saved before the next prompt is drawn.
export PROMPT_COMMAND="history -a"

# Define the persistent history file location.
export HISTFILE=~/.bash_history

# Alias for a 2-level directory tree view, ignoring .git.
alias llt='tree -a -L 2 -I .git'

# -----------------------------------------------------------------
# SECTION 2: CUSTOM WINDOWS PATH CONFIGURATION
# -----------------------------------------------------------------
# Manually add required user-level script paths for Python tools
# to ensure they are discoverable in the shell.

# Add Python (N-version) user-level scripts (for 'pipx').
export PATH="$PATH:$HOME/AppData/Roaming/Python/Python314/Scripts"

# Add Poetry (official installer) bin path.
export PATH="$PATH:$HOME/AppData/Roaming/pypoetry/bin"

# Add pipx global tool bin path (managed by 'pipx ensurepath').
export PATH="$PATH:$HOME/.local/bin"