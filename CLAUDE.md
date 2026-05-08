# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cross-platform development environment setup repository with automation scripts and shared dotfiles for macOS and Windows (WSL2 Ubuntu). The core design is unified configuration through shared dotfiles with platform-specific installation scripts.

## Architecture

### Core Pattern: Dynamic Path Resolution
All setup scripts use this critical pattern to locate dotfiles regardless of execution context:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")/dotfiles"
```

### Structure
```
mac-dev-setup/
├── macos/setup.sh           # macOS Homebrew-based setup
├── windows/
│   ├── setup.bat           # Windows batch wrapper (run as Administrator)
│   ├── windows-setup.ps1   # WSL2 + Windows apps via winget
│   └── ubuntu-setup.sh     # Ubuntu/WSL2 development environment
└── dotfiles/               # Shared config files (identical across platforms)
    ├── .tmux.conf          # Tmux (Ctrl+a prefix, TPM plugins)
    ├── .vimrc              # Vim (auto-installs vim-plug on first run)
    ├── .zshrc.custom       # Zsh aliases, functions, Oh My Zsh config
    ├── init.vim            # Neovim with vim-plug and LSP (auto-installs plugins)
    └── coc-settings.json   # COC.nvim LSP config (Python, Terraform, JSON, YAML)
```

## Development Commands

### Test Script Syntax
```bash
bash -n macos/setup.sh
bash -n windows/ubuntu-setup.sh
```

### Test Dotfiles Independently
```bash
tmux -f dotfiles/.tmux.conf
vim -u dotfiles/.vimrc
zsh -c "source dotfiles/.zshrc.custom && alias"
```

### Run Setup Scripts
```bash
# macOS — dynamic path resolution works from any directory
chmod +x macos/setup.sh && ./macos/setup.sh

# Windows — run as Administrator
./windows/setup.bat

# WSL2 Ubuntu — must run inside WSL after Windows setup + restart
./windows/ubuntu-setup.sh
```

## Script Architecture

### Error Handling
All scripts use `set -e` with two utility functions:
- `command_exists()` — check if a command is in PATH
- `verify_file()` — verify file exists and is readable

### Installation Pattern: Install → Verify → Report
```bash
brew install package_name
command_exists package_name && echo "✅ installed" || echo "❌ missing"
```

### Adding New Tools
- **macOS**: Add `brew install` + verification to `macos/setup.sh`
- **Ubuntu**: Add `apt install` + verification to `windows/ubuntu-setup.sh`
- Always update the final verification section at the bottom of the script

## Platform-Specific Notes

### macOS (`macos/setup.sh`)
- Detects Apple Silicon (arm64) vs Intel and configures Homebrew paths accordingly
- Installs Xcode CLT with an interactive user prompt — script waits for manual confirmation
- Detects tfenv and skips standalone terraform to avoid conflicts
- Detects "externally-managed-environment" and automatically uses pipx instead of pip
- Auto-runs TPM plugin installation in a detached tmux session after setup

### Ubuntu (`windows/ubuntu-setup.sh`)
- **WSL-only**: Checks `/proc/version` to verify WSL environment; fails on native Ubuntu
- Strips Windows line endings via `tr -d '\r'` when writing dotfiles (CRLF → LF) — critical for cross-platform correctness
- Creates `bat` symlink from `batcat` (Ubuntu package naming differs from macOS)
- AWS CLI v2 installation uses the x86_64 binary — WSL on ARM64 requires a different URL
- FZF: sources key bindings from system package paths (`/usr/share/doc/fzf/`) rather than a Homebrew installer

### Windows (`windows/windows-setup.ps1` + `setup.bat`)
- `setup.bat` manages PowerShell execution policies at both `Process` and `CurrentUser` scopes before calling the PS1 script
- Installs TeamViewer (remote access) via winget in addition to dev tools
- Installs Ubuntu 24.04 LTS for WSL2

## Dotfiles Design Notes

All dotfiles are **identical across platforms** — platform differences are handled entirely in setup scripts.

- `.vimrc` and `init.vim` auto-download vim-plug and auto-install all plugins on first launch
- `init.vim` uses Space as leader; Python and Terraform files auto-format on save (via ALE + black/terraform fmt)
- `.zshrc.custom` has a `fdir` function for directory finding — named to avoid collision with the `fd` CLI tool
- Tmux sessions auto-save every 15 minutes via tmux-continuum; resurrect directory pre-created by setup scripts to prevent errors

## Troubleshooting

**tfenv Conflicts**: macOS script auto-detects and skips terraform. Use `tfenv install latest` manually.

**Externally Managed Python**: Handled automatically via pipx. Normal on modern macOS.

**Tmux Plugins**: After setup, open tmux and press `Ctrl+a I` to install plugins. Verify with `ls ~/.tmux/plugins/`.

**Shell Not Changed**: Run `chsh -s $(which zsh)` and restart terminal.

**COC.nvim First Launch**: Run `:CocInstall coc-python coc-json coc-yaml coc-terraform`. Debug with `:CocInfo`.

**FiraCode Font Verification**:
```bash
# macOS
ls ~/Library/Fonts/FiraCode* 2>/dev/null || ls /Library/Fonts/FiraCode* 2>/dev/null
# Ubuntu/WSL
ls ~/.local/share/fonts/FiraCode* 2>/dev/null
```

**Debugging PATH and Architecture**:
```bash
echo $PATH | tr ':' '\n' | grep -E "(cargo|local|brew)"
uname -m  # arm64 = Apple Silicon, x86_64 = Intel
brew --version && which brew  # Verify Homebrew path
```
