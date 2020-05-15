# Rust development configuration

if [ -f ~/.cargo/env ]; then
  # Setup PATH
  source ~/.cargo/env

  # Rustup completions
  source <(rustup completions bash)

  # Try locate bash completions for cargo
  CARGO_COMPLETIONS=(~/.cargo/git/checkouts/cargo-*/*/src/etc/cargo.bashcomp.sh)
  CARGO_COMPLETIONS="${CARGO_COMPLETIONS[0]}"
  [ -f "$CARGO_COMPLETIONS" ] && source "$CARGO_COMPLETIONS"
  unset CARGO_COMPLETIONS
fi
