
# Enable fzf completions if available
[ -f /usr/share/bash-completion/completions/fzf ] && \
  source /usr/share/bash-completion/completions/fzf

# Enable bash key bindings if available
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && \
  source /usr/share/doc/fzf/examples/key-bindings.bash

# Preview a file or a directory
function _fzf_preview_fs {
  {
    local CRESET=$'\033[0m'
    local CYELLOW=$'\033[0;4;33m'
    local TYPE=$(file -Eib "$1")
    echo "${CYELLOW}Name:$CRESET $1"
    echo "${CYELLOW}Type:$CRESET $TYPE"
    echo "${CYELLOW}Info:$CRESET $(ls -lhdG "$1")"
    echo
    case "$TYPE" in
      'inode/directory'*)
        if type tree >/dev/null; then
          tree -C -L 1 -push -a --filelimit 200 "$1"
        else
          ls --color=always -lAh "$1"
        fi
        ;;
      *' charset=binary'*)
        xxd "$1"
        ;;
      *)
        if type bat >/dev/null; then
          bat -n --color always --tabs 4 "$1"
        else
          cat -n "$1"
        fi
        ;;
    esac
  } 2>/dev/null
}

export -f _fzf_preview_fs

# If we have fd, change some defaults to use it.
if type fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd -tf -tl'
  export FZF_ALT_C_COMMAND='fd -td'

  # Override the default path searchers for tab completion.
  function _fzf_compgen_path {
    fd -H -E.git . "$@"
  }
  function _fzf_compgen_dir {
    fd -td -H -E.git . "$@"
  }
fi

# Tweak the default settings
export FZF_DEFAULT_OPTS="--multi --height=40% --reverse -1 -0 --tabstop=4"
FZF_DEFAULT_OPTS+=" --prompt=' │ ' --color=prompt:0,hl:178,hl+:178"
FZF_DEFAULT_OPTS+=" --bind='ctrl-t:toggle-all,ctrl-g:select-all+accept'"
FZF_DEFAULT_OPTS+=" --bind='tab:down,shift-tab:up'"
FZF_DEFAULT_OPTS+=" --bind='f2:toggle-preview,ctrl-space:toggle'"
FZF_ALT_C_OPTS="--preview='_fzf_preview_fs {}'"

# Bash history and completion
export FZF_CTRL_R_OPTS=" --preview='echo {}' --preview-window=down:3:wrap"
export FZF_COMPLETION_TRIGGER='@'

# Override path completion to use the previewer
function _fzf_path_completion {
  FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview='_fzf_preview_fs {}'" \
    __fzf_generic_path_completion _fzf_compgen_path '-m' "" "$@"
}
function _fzf_dir_completion {
  FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview='_fzf_preview_fs {}'" \
    __fzf_generic_path_completion _fzf_compgen_dir '' '/' "$@"
}

# fzf with preview for filesystem
function fzfs {
  fzf --preview='_fzf_preview_fs {}' "$@"
}

# Use fd and fzf to find files and directories, enhanced with previews.
function fzfd {
  if type fd >/dev/null 2>&1; then
    local FD=(fd "$@")
  else
    local FD=(find . "$@")
    echo "Warning: 'fd' not found, falling back to 'find'" >&2
  fi
  "${FD[@]}" | fzfs
}

# Use fzf to find git branch with log preview
function fzbr {
  local POST="cut -c3- | awk '{print \$1}'"
  local GLOG='git log --oneline --decorate -n50 --color=always'
  local PRE="--preview=$GLOG \$(echo {} | $POST)"
  git branch "$@" | fzf +m "$PRE" --preview-window=right:65%:wrap | eval "$POST"
}
