
# Skip the rest of this file for non-interactive shells
case $- in
	*i*) ;;
	  *) return ;;
esac

# boot the shell
source ~/.bash/boot.sh
shell-boot init interact
