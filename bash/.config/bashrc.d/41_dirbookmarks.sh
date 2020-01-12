# DIRECTORY BOOKMARKS

# Set up directory bookmarks by creating a folder with a bunch of symlinks
# and putting it in CDPATH.
CDAT_DIR=~/.local/share/cdat
CDPATH="${CDPATH:-.}:$CDAT_DIR"

# Use physical location for changing directories
function cd {
  builtin cd -P "$@" >/dev/null
}

# Bookmark manager
function cdat {
  # Colours
  local CRESET CRED CCYAN
  if [ -t 1 ]; then
    CRESET=$'\001\033[0m\002'
    CRED=$'\001\033[0;31m\002'
    CCYAN=$'\001\033[0;96m\002'
  fi

  # Main functionality
  case "$1" in
    -h|-?|--help)
      # Show help
      echo "cdat: Minimalistic directory bookmark manager"
      echo
      echo "Usage:"
      echo "  cd @/<TAB>    - Follow a bookmark"
      echo "  cdat          - List bookmarks"
      echo "  cdat -l SUB   - List a subtree of bookmarks"
      echo "  cdat DIR      - Bookmark specific dir"
      echo "  cdat DIR NAME - Bookmark specific dir under given name"
      echo "  cdat -d NAME  - Delete bookmark of given name"
      echo "  cdat --help   - This help"
      echo
      echo "Bookmarks are stored in '$CDAT_DIR/@'"
      ;;
    ''|-l|--ls|--list)
      # List bookmarks
      if ! [ -d "$CDAT_DIR/@" ]; then
        echo "No bookmarks yet" >&2
        return
      fi
      (
        local TOP="${2#@/}"
        cd "$CDAT_DIR"
        find "@/$TOP" -type l -printf "  $CRED%p$CRESET -> $CCYAN%l$CRESET\\n"
      )
      ;;
    -d|--del|--delete)
      # Delete a bookmark
      local NAME="${2#@/}"
      local LINK="$CDAT_DIR/@/${NAME%/}"
      if ! [ -L "$LINK" ]; then
        echo "Not a bookmark: $NAME" >&2
        return 1
      fi
      rm -i "$LINK"
      ;;
    -*)
      echo "Unknown switch: '$1', -h for help" >&2
      return 2
      ;;
    *)
      # Create a bookmark
      local TGT="$(realpath -q "${1%/}")"
      if [ -z "$TGT" ]; then
        echo "Not found: $TGT" >&2
        return 1
      fi
      local NAME="${2#@/}"
      [ -z "$NAME" ] && NAME="${TGT##*/}"
      local BMARK="@/${NAME%/}"
      local LINK="$CDAT_DIR/$BMARK"
      mkdir -p "$(dirname "$LINK")" || return 1
      ln -s -i -T "$TGT" "$LINK" || return 1
      echo "  $CRED$BMARK$CRESET -> $CCYAN$TGT$CRESET"
      ;;
  esac
}
