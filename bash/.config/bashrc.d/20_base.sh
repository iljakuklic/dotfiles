# Basic configuration
# Some of this taken from https://github.com/mrzool/bash-sensible

# VARIOUS OPTIONS

# Check window size and set $LINES, $COLUMNS
shopt -s checkwinsize
# Recursive globbing with **
shopt -s globstar

# HISTORY

# Append to history
shopt -s histappend
# Save multi-line commands as one history entry
shopt -s cmdhist
# Expand glob that matches nothing to nothing
shopt -s nullglob
# Ignore duplicates in history
HISTCONTROL=ignoredups
# Increase the history size
HISTSIZE=10000
HISTFILESIZE=20000
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Record each line as it gets issued
PROMPT_COMMAND="${PROMPT_COMMAND}; history -a"
# Incremental history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# NAVIGATION

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# TAB COMPLETION

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Source the completion scripts
[ -f '/usr/share/bash-completion/bash_completion' ] \
  && source '/usr/share/bash-completion/bash_completion'
