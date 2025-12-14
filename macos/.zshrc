source "${HOME}/dotfiles/common/.bash_profile"

# --- RESTORED CUSTOMIZATIONS (Zsh-specific) ---
#
# History Configuration
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

# Custom Prompt
PROMPT='%~ 🐙 '

# Poetry Completions (Requires PATH from .bash_profile)
fpath+=~/.zfunc
autoload -Uz compinit && compinit
