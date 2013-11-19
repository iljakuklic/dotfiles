# Source all config files into a tmux session

DIR=~/.config/tmux
TMUX="tmux -f ~/.local/share/tmux/empty.conf"

[ -d "$DIR" ] || exit

for CONF in $DIR/*.conf; do
	$TMUX source "$CONF" >/dev/null
done
