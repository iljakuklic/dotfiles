
# Enable fzf completions if available
[ -f /usr/share/bash-completion/completions/fzf ] && \
  source /usr/share/bash-completion/completions/fzf

# If we have fd, change some defaults to use it.
if type fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd -tf -tl'
fi

export FZF_DEFAULT_OPTS="--multi --height=40% --reverse -1 --tabstop=4"
FZF_DEFAULT_OPTS+=" --prompt=' │ ' --color=prompt:0"
FZF_DEFAULT_OPTS+=" --bind='f2:toggle-preview,ctrl-a:select-all+accept,tab:down,shift-tab:up,ctrl-space:toggle'"

# The following only works with files, for reference only:
#FZF_DEFAULT_OPTS+=" --preview='{ [[ \$(file -i -b {}) =~ binary ]] && xxd {} || cat -n {}; } | head -100'"
