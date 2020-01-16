# Various enhancments to the standard cd and pushd/popd mechanisms.

# ls-like aliases
alias ll='ls -lhA'
alias lls='ll -S'
if builtin type tree >/dev/null 2>&1; then
  alias lst=tree
  alias llt='tree -hpuD'
fi

# Create a bunch of directories and move to the last one
function mkcd {
  local CDARGS=()
  local MKDIRARGS=()
  local CDDIR='' ARG=''
  for ARG in "$@"; do
    case "$ARG" in
      -L|-P) CDARGS+=("$ARG") ;;
      -p|-v|-m*|-Z) MKDIRARGS+=("$ARG") ;;
      -*) echo "mkcd: Unknown switch '$ARG'" >&2; return 1 ;;
      *) CDDIR="$ARG"; MKDIRARGS+=("$ARG") ;;
    esac
  done
  [ -z "$CDDIR" ] && echo "mkcd: No directory specified" >&2 && return 1
  mkdir "${MKDIRARGS[@]}" && cd "${CDARGS[@]}" "${CDDIR}"
}

# Move up the directory hierarchy
function cdup {
  case "$1" in
    -h|--help)
      echo "cdup: Move up the directory hierarchy"
      echo
      echo 'Usage:'
      echo '  cdup       - Move to the parent directory'
      echo '  cdup N     - Jump N directories up'
      echo '  cdup DIR   - Jump up to particular directory (prefix is ok)'
      echo '  cdup --git - Jump up to git top level directory'
      ;;
    --git) cd "$(git rev-parse --show-toplevel)" ;;
    -*) echo "Unknown switch '$1'" >&2; return 1 ;;
    '') cd .. ;;
    0) ;;
    [1-9]|1[0-9]) cd $(printf "../%.0s" `seq $1`) ;;
    *)
      local PAT="${1#/}"
      local DIR="$PWD"
      while [ "$DIR" != '' ]; do
        case "${DIR##*/}/" in
          "$PAT"*) cd "$DIR"; return 0 ;;
        esac
        DIR="${DIR%/*}"
      done
      echo "Pattern '$PAT' not found in current path" >&2
      return 1
      ;;
  esac
}

# Alias .. to cdup
alias ..=cdup

# Completion for cdup
function _complete_cdup {
  readarray -t COMPREPLY <<<"$(IFS=/ compgen -W "$PWD/--git" -- "$2")"
}
complete -F _complete_cdup cdup ..
