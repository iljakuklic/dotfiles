# Quit if not running interactively.
[ -z "$PS1" ] && return

# Source all initialization files.
for SCRIPT in ~/.config/bashrc.d/*.sh; do
  source "$SCRIPT"
done
