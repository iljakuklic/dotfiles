# Support utilities for subsequent init scripts.

# Check a command exists, and optionally run it.
#
# Syntax: iscmd [--warn] <command> [operation [args...]]
#
# Options:
#   --warn: Print a warning if the command is not found
# Operations:
#   --run: Execute the command with remaining arguments
#   --eval: Execute the command and eval its output
#   --exec: Replace the current shell with the command
function iscmd {
    local WARN=false

    if [ "$1" = '--warn' ]; then
        WARN=true
        shift
    fi

    local COMMAND="$1"
    shift

    if !builtin type "$COMMAND" >/dev/null 2>&1; then
        $WARN && echo "WARNING: '$COMMAND' not found" >&2
        return 127
    fi

    local OPERATION="$1"
    shift
    case "$OPERATION" in
        '') ;;
        '--run') "$COMMAND" "$@";;
        '--eval') eval "$("$COMMAND" "$@")";;
        '--exec') exec "$COMMAND" "$@";;
        *) echo "Unknown operation '$OPERATION'" >&2; return 128;;
    esac
}
