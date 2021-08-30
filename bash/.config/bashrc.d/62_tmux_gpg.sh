# Explicitly set GPG_TTY, otherwise password prompts don't work in tmux.
export GPG_TTY=$(tty)
