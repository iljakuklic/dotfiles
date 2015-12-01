
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

  # android lunch status
  printSol base1 "${LUNCH_MENU_CHOICES:+[${LUNCH_MENU_CHOICES:0:12}] }"

  # current directory
  printSol blue "$(basename "$PWD") "

  # end of prompt
  colorReset
  case "$UID" in
    0) printf '# ' ;;
    *) printf '$ ' ;;
  esac
}

# TODO version control support
# TODO NOTEs/TODOs support
PS1=$(printf '$(prompt_print $?)')
