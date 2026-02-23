# AGENTS.md - Guidelines for AI Coding Agents

This is a **dotfiles repository** containing configuration files for various tools (bash, git, kakoune, nvim, tmux, etc.). It is managed with **GNU stow** - not a typical software project with build/test commands.

## Repository Structure

```
./
├── bash/           # Bash configuration (~/.config/bashrc.d/)
├── bash-init/     # Bash init scripts
├── git/           # Git configuration (~/.gitconfig)
├── gdb/           # GDB configuration
├── kakoune/       # Kakoune editor config
├── nvim/          # Neovim configuration
├── tmux/          # Tmux configuration
├── tools/         # Additional tool configs
├── scripts/       # Shell scripts
├── prompt-custom-bash/  # Custom bash prompt
└── prompt-starship/     # Starship prompt config
```

## Commands

### Deploying dotfiles with stow
```bash
# Deploy all packages
stow -v -t ~ */

# Deploy specific package
stow -v -t ~ bash
```

### No build/lint/test commands
This is a configuration repository, not a software project. There are no build, lint, or test commands.

## Code Style Guidelines

### General Principles
- Keep configurations minimal and readable
- Prefer explicit over implicit
- Add comments for non-obvious settings
- Group related configurations together

### Bash Scripts (.sh files in bashrc.d/)
- Use `function name { }` syntax (not `function-name()`)
- Use `local` for function-scope variables
- Check command existence with `type` or `command -v` before using
- Redirect stderr to `/dev/null` for optional dependencies: `2>/dev/null`
- Use `[[ ]]` for conditionals (not `[ ]`)
- Quote variables: `"$VAR"` not `$VAR`
- Use `shopt -s` for shell options

### Git Configuration
- Use meaningful aliases
- Group related settings with comments
- Prefer command-specific sections

### Editor Configs (nvim, kakoune)
- Follow each editor's conventional config structure
- Use plugin managers if needed (lazy.nvim for nvim)
- Keep configs modular

### Error Handling
- Fail silently for optional features
- Use guards: `[ -f "$FILE" ] && source "$FILE"`
- Provide fallback commands when tools are unavailable

### Naming Conventions
- Files: lowercase with descriptive names (e.g., `20_base.sh`, `61_fzf.sh`)
- Functions: lowercase with underscores (e.g., `fzfd`, `_fzf_preview_textfile`)
- Environment variables: UPPERCASE with underscores

## Editor Notes

- **Shellcheck**: Run on bash scripts if you want to check for issues: `shellcheck script.sh`
- **Stow**: This repo follows https://alexpearce.me/2016/02/managing-dotfiles-with-stow/ pattern
