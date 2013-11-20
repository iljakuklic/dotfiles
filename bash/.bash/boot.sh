# Bash bootstrap functions

function source-dir-ext {
	local EXT="$1"
	shift
	for DIR in "$@"; do
		[ -d "$DIR" ] && for SRC in "$DIR/"*"$EXT"; do
			source "$SRC"
		done
	done
}

function source-dir { source-dir-ext ".sh" "$@"; }

function env-set {
	local NAME="$1"
	shift
	export "$NAME=$*"
}

function env-add {
	local NAME="$1"
	shift
	eval "export '$NAME=\$$NAME:$*'"
}

function env-prepend {
	local NAME="$1"
	shift
	eval "export '$NAME=$*:\$$NAME'"
}

function env-alias {
	local NAME="$1"
	shift
	alias "$NAME=$*"
}

function env-include {
	source "$*"
}

function env-boot {
	source-dir-ext .env ~/.{local/share,config}/shenv
}

function shell-boot {
	env-boot
	for DIR in "$@"; do
		source-dir "~/.bash/$DIR"
	done
}
