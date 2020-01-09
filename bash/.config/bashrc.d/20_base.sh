# Basic configuration

# History
shopt -s histappend
HISTCONTROL=ignoredups # Ignore dumplicates
HISTSIZE=10000
HISTFILESIZE=20000

# Various settings
shopt -s checkwinsize
shopt -s globstar

# Set up tab completion
[ -f '/usr/share/bash-completion/bash_completion' ] \
  && source '/usr/share/bash-completion/bash_completion'
