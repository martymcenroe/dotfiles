# Configures the Bash shell environment for this user.
# AUTOMATIC SYNC: Check for changes in the live file before loading.
if ! diff -q ~/.bash_profile home/.bash_profile > /dev/null 2>&1; then
    echo "SYNC: Changes detected in ~/.bash_profile. Synchronizing to Git source..." >&2
    cp ~/.bash_profile home/.bash_profile
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

# Set PROMPT_COMMAND to append the last command to history immediately,
# ensuring the session history is saved before the next prompt is drawn.
export PROMPT_COMMAND="history -a"

# Define the persistent history file location.
export HISTFILE=~/.bash_history

# Alias for a 2-level directory tree view, ignoring .git.
alias llt='tree -a -L 2 -I .git'