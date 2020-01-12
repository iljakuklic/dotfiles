# Command prompt

# Format time compactly to fit in 6 chars.
# $1 is the time in nanoseconds
function fmt_compact_time {
  local maxw r u q ns us ms s m h d ul l
  (( maxw = 6 ))
  case "$1" in
    -w*) (( maxw = "${1#-w}" )); shift ;;
  esac
  (( ns = "$1" ))
  local r=''
  local u=''
  if (( q = 1, ns < 1000 )); then
    printf -vr "%d" $(( ns ))
    u='ns'
  elif (( q *= 1000, ( us = ns / q ) < 1000 )); then
    printf -vr "%d.%03d" $(( us )) $(( ns % q ))
    u='μs'
  elif (( q *= 1000, ( ms = ns / q ) < 1000 )); then
    printf -vr "%d.%06d" $(( ms )) $(( ns % q ))
    u='ms'
  elif (( q *= 1000, (s = ns / q ) < 600 )); then
    printf -vr "%d.%09d" $(( s )) $(( ns % q ))
    u='s'
  elif (( q *= 60, (m = ns / q ) < 60 )); then
    printf -vr "%dm%02d" $(( m )) $(( s % 60 ))
    u='s'
  elif (( q *= 60, (h = ns / q ) < 96 )); then
    printf -vr "%dh%02d" $(( h )) $(( m % 60 ))
    u='m'
  elif (( q *= 24, (d = ns / q ) < 100 )); then
    printf -vr "%dd%02d" $(( d )) $(( h % 24 ))
    u='h'
  else
    printf -vr "%d" $(( d ))
    u='d'
  fi
  local -i ul=${#u}
  (( l = maxw - ul ))
  r=${r:0:$l}
  echo "${r%.}$u"
}

function command_timer_start {
  [ -z "$COMMAND_TIMER_START" ] && COMMAND_TIMER_START="${EPOCHREALTIME/./}000"
}

function command_timer_stop {
  [ -z "$COMMAND_TIMER_START" ] && return 1
  LAST_COMMAND_TIME_NS="$(( "${EPOCHREALTIME/./}000" - $COMMAND_TIMER_START ))"
  unset COMMAND_TIMER_START
}

function prompt_command {
  # Capture command exit code before it's too late
  local CMDSTATUS="$?"

  # Some colours
  local CRESET=$'\001\033[0m\002'
  local CGREY=$'\001\033[0;30m\002'
  local CGREEN=$'\001\033[2;32m\002'
  local CRED=$'\001\033[0;1;31m\002'
  local CDRED=$'\001\033[0;2;31m\002'
  local CYELLOW=$'\001\033[0;33m\002'
  local CBYELLOW=$'\001\033[0;1;33m\002'
  local CDYELLOW=$'\001\033[0;2;33m\002'
  local CDCYAN=$'\001\033[0;2;36m\002'
  local CBCYAN=$'\001\033[0;96m\002'
  local CBLUE=$'\001\033[0;34m\002'
  local CDBLUE=$'\001\033[0;2;34m\002'
  local CBBLUE=$'\001\033[0;94m\002'
  local CUNDERLINE=$'\001\033[4m\002'
  local CBLINK=$'\001\033[5m\002'
  local INDICATOR='_▁▂▃▄▅▆▇█'

  # Form the command status info
  local STATUS=''
  if [ "$CMDSTATUS" != '' ] && [ "$CMDSTATUS" != 0 ]; then
    local STATUS=" $CDRED✗$CRED$CMDSTATUS"
  fi

  # Capture command running time
  local CMDTIME=''
  if [ ! -z "$LAST_COMMAND_TIME_NS" ]; then
    CMDTIME="     $(fmt_compact_time $LAST_COMMAND_TIME_NS)"
    CMDTIME=" $CDYELLOW⌛︎$CYELLOW${CMDTIME:(-6)}"
  fi

  # Get date and time
  local DATETIME=$(date "+ $CDYELLOW%a$CYELLOW%d$CDYELLOW%b ⌚︎$CBYELLOW%H:%M")

  # Battery status
  local BATTERY UF BATINFO BATCAP BATSTATUS ENTRY BATIND BATICON
  for UF in /sys/class/power_supply/BAT?/uevent; do
    readarray -t BATINFO <"$UF"
    local CHARGING=false
    for ENTRY in "${BATINFO[@]}"; do
      case "$ENTRY" in
        POWER_SUPPLY_STATUS=Charging) CHARGING=true ;;
        POWER_SUPPLY_CAPACITY=*) BATCAP="${ENTRY#*=}" ;;
      esac
    done
    BATIND="${INDICATOR:$(( (BATCAP * 8 + 50) / 100 )):1}"
    $CHARGING && BATICON="$CYELLOW±" || BATICON="$CGREY±"
    BATCLR="$CDYELLOW"
    (( BATCAP >= 98 )) && BATCLR="$CYELLOW"
    (( BATCAP <= 15 )) && BATCLR="$CRED"
    (( BATCAP <=  5 )) && BATCLR="$CRED$CBLINK"
    BATTERY="$BATTERY$BATICON$BATCLR$BATIND"
  done
  [ -z "$BATTERY" ] || BATTERY=" $BATTERY"

  # Get info about directory stack depth
  local DIRDEPTH=''
  (( "${#DIRSTACK[@]}" > 1 )) && \
    DIRDEPTH=" $CDCYAN≣$(( ${#DIRSTACK[@]} - 1 ))"

  # User color
  local USERCLR="$CBLUE"
  [ "$EUID" = 0 ] && USERCLR="$CRED$CUNDERLINE"

  # The usual prompt syntax used here
  local PS=" $USERCLR\u$CGREY@$CBLUE\h$DIRDEPTH $CBCYAN\\w"

  # Compile the components together into a few sections
  local NOWINFO="$DATETIME$BATTERY"
  local CMDINFO="$CGREY▕$CMDTIME$STATUS"
  local LOCINFO="$CGREY▕${PS@P}"

  # Write it out
  echo "$CGREY╭╼$NOWINFO$CMDINFO$LOCINFO"
  echo "$CGREY╰┤$CRESET "
}

# Set the whole thing up
trap 'command_timer_start' DEBUG
PROMPT_COMMAND="${PROMPT_COMMAND}; command_timer_stop"
PROMPT_DIRTRIM=4
PS0=$'\001\033[0m\002'
PS1='$(prompt_command)'
PS2='\001\033[0;30m\002 │\001\033[0m\002 '
