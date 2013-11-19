# Source all config files into a tmux session

DIR=~/.config/tmux
TMUX="tmux -f /dev/null"

[ -d "$DIR" ] || exit

for CONF in $DIR/*.conf; do
	$TMUX source "$CONF" >/dev/null
done
