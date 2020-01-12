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
