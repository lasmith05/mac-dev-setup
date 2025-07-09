# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cross-platform development environment setup repository with automation scripts and dotfiles for consistent development environments on macOS and Windows (WSL2 Ubuntu). The key insight is unified configuration through shared dotfiles with platform-specific installation scripts.

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
│   ├── setup.bat           # Windows batch wrapper (recommended)
│   ├── windows-setup.ps1   # WSL2 + Windows apps via winget
│   └── ubuntu-setup.sh     # Ubuntu development environment
└── dotfiles/               # Unified configuration files
    ├── .tmux.conf          # Tmux (Ctrl+a prefix, vim navigation)
    ├── .vimrc              # Vim configuration
    ├── .zshrc.custom       # Shell aliases and functions
    ├── init.vim            # Neovim with vim-plug and plugins
    └── coc-settings.json   # COC.nvim LSP configuration
```

## Development Commands

### Setup Commands
```bash
# macOS setup
chmod +x macos/setup.sh && ./macos/setup.sh

# Windows setup (run as Administrator)
./windows/setup.bat  # or ./windows/windows-setup.ps1
./windows/ubuntu-setup.sh  # in WSL2 Ubuntu after restart

# Test script syntax
bash -n macos/setup.sh
bash -n windows/ubuntu-setup.sh
```

### Validation Commands
```bash
# Verify setup worked
ls          # Should show eza with icons
cat ~/.zshrc # Should show bat with syntax highlighting
tmux        # Should start with Ctrl+a prefix
node --version && terraform --version && aws --version

# Debug setup issues
brew doctor     # macOS Homebrew issues
echo $SHELL     # Current shell
wsl --list --verbose  # WSL status (Windows)

# Check externally managed Python environments
python3 -m pip --version  # Should show pip version
python3 -c "import sys; print(sys.prefix)"  # Show Python environment

# Verify tmux plugins
tmux show-environment | grep TMUX  # Check tmux environment
ls ~/.tmux/plugins/  # List installed plugins
```

### Development Testing
```bash
# Test dotfiles independently
tmux -f dotfiles/.tmux.conf
vim -u dotfiles/.vimrc
zsh -c "source dotfiles/.zshrc.custom && alias"
```

## Key Components

### Script Architecture Patterns

**Error Handling**: All scripts use `set -e` (exit on error) with verification functions:
- `command_exists()` - Check if command is available
- `verify_file()` - Verify file exists and is readable

**Installation Pattern**: Install → Verify → Report
```bash
brew install package_name
command_exists package_name && echo "✅ installed" || echo "❌ missing"
```

### Platform-Specific Setup Scripts

**macOS (`macos/setup.sh`)**: Homebrew-based installation with Apple Silicon/Intel detection
**Windows (`windows/setup.bat` + `windows-setup.ps1`)**: WSL2 installation + Windows apps via winget
**Ubuntu (`windows/ubuntu-setup.sh`)**: apt-based installation with Windows→Unix line ending conversion

### Dotfiles Configuration

**Shell (`.zshrc.custom`)**: Modern CLI aliases, git shortcuts, terraform shortcuts, productivity functions
**Tmux (`.tmux.conf`)**: Ctrl+a prefix, vim navigation, mouse support, TPM plugins
**Vim (`.vimrc` + `init.vim`)**: Traditional vim + Neovim with COC.nvim LSP support
**Neovim (`init.vim`)**: Modern IDE-like setup with vim-plug auto-installation, plugins (NERDTree, FZF, COC.nvim, ALE, vim-fugitive), LSP, git integration, file management
**COC Settings (`coc-settings.json`)**: Language server configuration for Python, Terraform, JSON, YAML with diagnostics, completion, and formatting

## Development Tools Installed

### Core Stack
- **Languages**: Node.js (LTS), Rust, Python 3
- **Infrastructure**: Terraform, AWS CLI, Docker
- **Version Control**: Git with Git LFS
- **Editors**: VS Code with extensions, Vim/Neovim
- **Fonts**: FiraCode Nerd Font with programming ligatures and icons

### Modern CLI Tools
- **File Operations**: eza (ls), bat (cat), fd (find)
- **Search**: ripgrep (grep), fzf (fuzzy finder)
- **System**: htop, tree, jq, tldr
- **Terminal**: tmux with TPM
- **Python**: pipx for isolated package installation

## Essential Aliases and Shortcuts

### Shell Aliases (from dotfiles/.zshrc.custom:20-50)
```bash
# Modern CLI replacements
ls='eza --icons'
cat='bat'
find='fd'
grep='rg'

# Git shortcuts
gs='git status'
ga='git add'
gc='git commit'
gp='git push'
gl='git log --oneline --graph --decorate --all'

# Terraform shortcuts
tf='terraform'
tfa='terraform apply'
tfp='terraform plan'
```

### Tmux Key Bindings
- Prefix: `Ctrl+a`
- Split: `|` (vertical), `-` (horizontal)
- Navigate: `h/j/k/l` (vim-style)
- Resize: `H/J/K/L`
- Install plugins: `Ctrl+a I`

### Custom Functions
- `mkcd <dir>` - Make directory and cd into it
- `extract <file>` - Extract any archive format
- `gcommit "msg"` - Git add all and commit with message
- `gnew <branch>` - Create and switch to new git branch
- `weather <location>` - Get weather information via wttr.in
- `ff <pattern>` - Find files matching pattern
- `fd <pattern>` - Find directories matching pattern

### Neovim Key Bindings (init.vim)
- Leader key: `Space`
- `<leader>n` - Toggle NERDTree file explorer
- `<leader>p` - Open file finder (FZF)
- `<leader>g` - Search in files (ripgrep)
- `<leader>gs` - Git status
- `<leader>t` - Toggle Tagbar
- `gd` - Go to definition (COC)
- `K` - Show documentation (COC)

## Common Development Patterns

### Adding New Tools
**macOS**: Add to `macos/setup.sh` brew install section + verification
**Ubuntu**: Add to `windows/ubuntu-setup.sh` apt install section + verification

### Modifying Setup Scripts
- Always use `command_exists()` and `verify_file()` functions
- Follow the install → verify → report pattern
- Test with `bash -n script_name.sh` before running
- Update final verification section when adding tools

### Cross-Platform Considerations
- Use dynamic path resolution pattern for dotfiles location
- Handle line endings (Ubuntu script converts Windows → Unix)
- Ensure consistent shell configuration sourcing across platforms

## Troubleshooting and Debugging

### Common Issues and Solutions

**tfenv Conflicts**: The macOS setup script automatically detects tfenv and skips terraform installation to avoid conflicts. Use `tfenv install latest` if tfenv is present.

**Externally Managed Python**: macOS may show "externally managed environment" warnings. This is normal and handled by the setup scripts.

**Tmux Plugin Installation**: After setup, manually install plugins with `tmux` then `Ctrl+a I`. If plugins don't load, check `.tmux/plugins/tpm` exists.

**Shell Changes**: If zsh doesn't become default, manually run `chsh -s $(which zsh)` and restart terminal.

**COC.nvim Setup**: First time opening Neovim, run `:CocInstall coc-python coc-json coc-yaml coc-terraform` for language support. If COC servers don't start, check `:CocInfo` for diagnostics.

**Neovim Plugin Installation**: Plugins are auto-installed via vim-plug. If plugins are missing, run `:PlugInstall` in Neovim.

### Debugging Commands
```bash
# Check file permissions and existence
ls -la dotfiles/
file dotfiles/.zshrc.custom  # Check file type

# Test shell configuration
zsh -c "source dotfiles/.zshrc.custom && echo 'Config loaded'"

# Verify PATH modifications
echo $PATH | tr ':' '\n' | grep -E "(cargo|local)"

# Check tmux configuration
tmux -f dotfiles/.tmux.conf list-keys | head -10

# Test vim configuration
vim -u dotfiles/.vimrc --version
nvim -u dotfiles/init.vim --version

# Check COC.nvim status
nvim -c ":CocInfo" -c ":q"
nvim -c ":CocList extensions" -c ":q"

# Check FiraCode Nerd Font installation
# macOS
ls ~/Library/Fonts/FiraCode* 2>/dev/null || ls /Library/Fonts/FiraCode* 2>/dev/null
# Ubuntu/WSL
ls ~/.local/share/fonts/FiraCode* 2>/dev/null
```