# Various enhancments to the standard cd and pushd/popd mechanisms.

# Use exa for ls if available
if iscmd exa; then
  alias ls='exa'
  alias lst='ls -T'
  alias llt='ll -T'
fi

# ls-like aliases
alias ll='ls -lha'
alias lls='ll --sort=size'

# Enable colors
iscmd --warn dircolors --eval

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
  test "$#" = 0 && cd .. && return 0

  local DIR="$PWD"
  local TEST=(test 1)
  local PAT=
  while test "$#" -gt 0; do
    case "$1" in
      -h|--help)
        echo "cdup: Move up the directory hierarchy"
        echo
        echo 'Usage:'
        echo '  cdup                - Move to the parent directory'
        echo '  cdup -N             - Jump N directories up'
        echo '  cdup DIR            - Jump up to particular directory (prefix is ok)'
        echo '  cdup --git          - Jump up to git top level directory'
        echo '  cdup -[edfrwx] FILE - Jump up to directory matching a test (see help test)'
        return 0
        ;;
      --git) TEST+=(-a -d .git) ;;
      /) cd /; return "$?" ;;
      -0) ;;
      -[0-9]|-[12][0-9]) for i in `seq ${1:1}`; do DIR="${DIR%/*}"; done ;;
      -[edfLrwxOG]) TEST+=(-a "$1" "$2"); shift ;;
      -a) ;;
      -o) TEST+=("$1") ;;
      -) cd -; return "$?" ;;
      -*) echo "Unknown switch '$1'" >&2; return 1 ;;
      *) PAT="${1#/}" ;;
    esac
    shift
  done

  while [ "$DIR" != '' ]; do
    case "${DIR##*/}/" in
      "$PAT"*) (cd "$DIR" && "${TEST[@]}") && { cd "$DIR"; return "$?"; } ;;
    esac
    DIR="${DIR%/*}"
  done

  echo "Could not find matching directory" >&2
  return 1
}

# Alias .. to cdup
alias ..=cdup

# Completion for cdup
function _complete_cdup {
  readarray -t COMPREPLY <<<"$(IFS=/ compgen -W "$PWD" -- "$2")"
}
complete -F _complete_cdup cdup ..
