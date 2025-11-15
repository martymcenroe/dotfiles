# --- Architect's Note ---
# This file configures the Bash shell environment.
# It's sourced on login and contains settings for a robust,
# persistent command history, fixing the "lost history" problem.

# Don't save duplicate commands or trivial commands
export HISTCONTROL=ignoreboth:erasedups

# Set large history file size
export HISTSIZE=10000
export HISTFILESIZE=20000

# Append to history, don't overwrite it
shopt -s histappend

# --- The "Fix" ---
# This line is the magic. It tells Bash to run 'history -a'
# (append history) *before* rendering the next prompt.
# This saves the command *immediately*.
export PROMPT_COMMAND="history -a"

# Define the persistent history file location
export HISTFILE=~/.bash_history

# Alias for a quick directory tree view
alias llt='tree -L 2'
