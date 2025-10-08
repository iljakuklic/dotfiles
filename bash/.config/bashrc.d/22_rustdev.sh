# Rust development configuration

if [ -d ~/.cargo ]; then
  # Setup PATH
  [ -f ~/.cargo/env ] && source ~/.cargo/env

  # If the above fails, try adding bin manually
  case ":$PATH:" in
    *":$HOME/.cargo/bin:"*) ;;
    *) PATH="$HOME/.cargo/bin:$PATH" ;;
  esac

  # Rustup completions
  source <(rustup completions bash)

  # Try locate bash completions for cargo
  CARGO_COMPLETIONS=(~/.cargo/git/checkouts/cargo-*/*/src/etc/cargo.bashcomp.sh)
  CARGO_COMPLETIONS="${CARGO_COMPLETIONS[0]}"
  [ -f "$CARGO_COMPLETIONS" ] && source "$CARGO_COMPLETIONS"
  unset CARGO_COMPLETIONS
fi
