# Various enhancments to the standard cd and pushd/popd mechanisms.

# Create a directory and move there
function mkcd {
  local CDARGS=()
  local MKDIRARGS=()
  local ARG
  for ARG in "$@"; do
    case "$ARG" in
      -L|-P)
        CDARGS+=("$ARG")
        ;;
      -p|-v|-m*|-Z)
        MKDIRARGS+=("$ARG")
        ;;
      -*)
        echo "Unknown switch '$ARG'" >&2
        ;;
      *)
        CDARGS+=("$ARG")
        MKDIRARGS+=("$ARG")
        ;;
    esac
  done
  mkdir "${MKDIRARGS[@]}" && cd "${CDARGS[@]}"
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
      ;;
    -*)
      echo "Unknown switch '$1'" >&2
      return 1
      ;;
    '')
      cd ..
      ;;
    0)
      ;;
    [1-9]|1[0-9])
      cd $(printf "../%.0s" `seq $1`)
      ;;
    *)
      local PAT="${1#/}"
      local DIR="$PWD"
      while [ "$DIR" != '' ]; do
        if [[ "${DIR##*/}/" == "$PAT"* ]]; then
          cd "$DIR"
          return 0
        fi
        DIR="${DIR%/*}"
      done
      echo "Pattern '$PAT' not found in current path" >&2
      return 1
      ;;
  esac
}
