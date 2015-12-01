BAHSPROMPT_DIR=$(realpath $(dirname $BASH_SOURCE))
source "${BAHSPROMPT_DIR:-.}/git-prompt.sh"

function colorSet {
	printf '\001\033[38;5;%sm\002' "$1"
}

# Solarized color scheme color definitions
function __color_sol_base03 () { echo "234"; }
function __color_sol_base02 () { echo "235"; }
function __color_sol_base01 () { echo "240"; }
function __color_sol_base00 () { echo "241"; }
function __color_sol_base0  () { echo "244"; }
function __color_sol_base1  () { echo "245"; }
function __color_sol_base2  () { echo "254"; }
function __color_sol_base3  () { echo "230"; }
function __color_sol_yellow () { echo "136"; }
function __color_sol_orange () { echo "166"; }
function __color_sol_red    () { echo "160"; }
function __color_sol_magenta() { echo "125"; }
function __color_sol_violet () { echo  "61"; }
function __color_sol_blue   () { echo  "33"; }
function __color_sol_cyan   () { echo  "37"; }
function __color_sol_green  () { echo  "64"; }

function colorSol() {
	colorSet "$(__color_sol_$1)"
}

function colorReset() {
	printf '\001\033[m\002'
}

function printSol() {
	colorSol $1; shift; printf '%s' "$*"; colorReset
}

function prompt_print {
  # exit status
  case "$1" in
    0) true ;;
    *) printSol red "×$1 " ;;
  esac

  # time
  colorSol green
  printf '%s ' $(date '+%H%M')

  # user & hostname
  case "$UID" in
    0) colorSol red ;;
    *) colorSol yellow ;;
  esac
  printf "$USER@$HOSTNAME"

  # devel stuff
  colorSol violet
  # android lunch status
  printf "${LUNCH_MENU_CHOICES:+ [${LUNCH_MENU_CHOICES:0:12}]}"
  # git prompt
  GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUPSTREAM='auto' __git_ps1

  # current directory
  local DIR=${PWD##$HOME}
  if [ "$DIR" != "$PWD" ]; then
    DIR="~$DIR"
  fi
  local -a DIRS SHDIRS
  IFS=/ read -r -a DIRS <<<"$DIR"
  [ '/' == "$DIR" ] && DIRS=("" "")
  for D in "${DIRS[@]:0:${#DIRS[@]}-1}"; do
    if [ "${#D}" -le 4 ]; then
      SHDIRS+=("$D")
    else
      SHDIRS+=("${D:0:2}")
    fi
  done
  SHDIRS+=("${DIRS[-1]}")
  colorSol blue
  printf ' %s' "${SHDIRS[0]}"
  for D in "${SHDIRS[@]:1}"; do
    printf '/%s' "$D"
  done

  # end of prompt
  colorReset
  case "$UID" in
    0) printf '\n# ' ;;
    *) printf '\n$ ' ;;
  esac
}

# TODO version control support
# TODO NOTEs/TODOs support
PS1=$(printf '$(prompt_print $?)')
