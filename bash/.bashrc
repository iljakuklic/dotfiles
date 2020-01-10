# Quit if not running interactively.
[ -z "$PS1" ] && return

if ((BASH_VERSINFO[0] < 4)); then
  echo "Bash is too old, some configuration may not work" >&2
fi

# Source all initialization files.
for SCRIPT in ~/.config/bashrc.d/*.sh; do
  source "$SCRIPT"
done
