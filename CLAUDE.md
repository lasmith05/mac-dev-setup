# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a cross-platform development environment setup repository containing automation scripts and configuration files for setting up consistent development environments on macOS and Windows (with WSL2 Ubuntu). The repository provides unified dotfiles and platform-specific setup scripts to ensure consistent development experience across operating systems.

## Architecture

### Multi-Platform Structure
The repository follows a clean, organized structure with platform-specific directories and unified configuration:

```
dev-setup/
├── macos/
│   └── setup.sh             # macOS setup script
├── windows/
│   ├── setup.bat            # Windows batch wrapper (recommended)
│   ├── windows-setup.ps1    # Windows PowerShell script  
│   └── ubuntu-setup.sh      # Ubuntu WSL2 setup script
└── dotfiles/
    ├── .tmux.conf           # Tmux configuration
    ├── .vimrc              # Vim configuration
    └── .zshrc.custom       # Zsh configuration
```

### Setup Process Flow

**macOS (Single-Phase):**
```bash
./macos/setup.sh
```
- Uses Homebrew for package management
- Installs native macOS applications
- Direct dotfile setup from `dotfiles/` directory

**Windows (Two-Phase):**
```batch
# Phase 1: Windows environment (as Administrator)
./windows/setup.bat  # or ./windows/windows-setup.ps1

# Phase 2: Ubuntu environment (in WSL2)
./windows/ubuntu-setup.sh
```
- Phase 1: WSL2 installation and Windows applications via winget
- Phase 2: Ubuntu development environment setup with dotfiles

## Common Setup Commands

### Quick Start
```bash
# macOS
chmod +x macos/setup.sh && ./macos/setup.sh

# Windows (recommended)
# Right-click windows/setup.bat and "Run as administrator"

# Windows (manual)
./windows/windows-setup.ps1  # as Administrator
./windows/ubuntu-setup.sh    # in WSL2 Ubuntu
```

### Post-Setup Verification
```bash
# Test modern CLI tools
ls          # Should show eza with icons
cat ~/.zshrc # Should show bat with syntax highlighting
tmux        # Should start with Ctrl+a prefix and mouse support

# Test development tools
node --version
terraform --version
aws --version
code --version
```

### Post-Setup Configuration
```bash
# Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Tmux plugin installation
# Open tmux and press Ctrl+a then I
```

## Key Components

### Platform-Specific Setup Scripts

**macOS Setup (`macos/setup.sh`)**:
- Installs Homebrew if not present
- Uses `SCRIPT_DIR` and `DOTFILES_DIR` variables to locate dotfiles
- Handles Apple Silicon and Intel Mac differences
- Installs GUI applications via Homebrew Cask
- Comprehensive verification and error handling

**Windows Setup (`windows/setup.bat` + `windows-setup.ps1`)**:
- Handles PowerShell execution policy automatically
- Installs WSL2 with Ubuntu 24.04 LTS
- Uses winget for Windows application installation
- Provides detailed user guidance and error handling

**Ubuntu Setup (`windows/ubuntu-setup.sh`)**:
- Uses `SCRIPT_DIR` and `DOTFILES_DIR` variables for cross-platform compatibility
- Handles Windows→Unix line ending conversion
- Installs modern CLI tools via apt and direct downloads
- Comprehensive package verification

### Unified Dotfiles (`dotfiles/`)

**Shell Configuration (`.zshrc.custom`)**:
- Modern CLI tool aliases (ls→eza, cat→bat, find→fd, grep→rg)
- Git shortcuts (gs, ga, gc, gp, gl, gd, gb, gco)
- Terraform shortcuts (tf, tfa, tfp, tfi, tfd, tfv, tff)
- Productivity functions (mkcd, extract, weather, ff, fd, gcommit, gnew)

**Tmux Configuration (`.tmux.conf`)**:
- Prefix key: Ctrl+a (instead of default Ctrl+b)
- Vim-style pane navigation (h/j/k/l) and resizing (H/J/K/L)
- Intuitive split commands (| for vertical, - for horizontal)
- TPM with productivity plugins (sensible, yank, resurrect, continuum)
- Mouse support and modern terminal features

**Vim Configuration (`.vimrc`)**:
- Modern editing features (relative line numbers, syntax highlighting, smart indentation)
- Development-focused key mappings (jj for Esc, Ctrl+s save, window navigation)
- File handling (automatic backup, undo history, trailing whitespace removal)
- File type specific settings (Python, JavaScript, HTML, CSS, YAML, JSON)

## Development Tools Installed

### Core Development Stack
- **Languages**: Node.js (LTS), Rust with Cargo, Python 3
- **Infrastructure**: Terraform, AWS CLI, Docker/Docker Desktop
- **Version Control**: Git with Git LFS, configured for cross-platform
- **Editors**: Visual Studio Code with comprehensive extension pack

### Modern CLI Tools
- **File Operations**: eza (colorful ls with icons), bat (syntax-highlighted cat), fd (smart find)
- **Search**: ripgrep (fast grep), fzf (fuzzy finder with key bindings)
- **System Utilities**: htop, tree, jq, tldr
- **Terminal Enhancement**: tmux with TPM plugin manager

### VS Code Extensions
- **Remote Development**: SSH, Containers, WSL
- **Version Control**: GitLens
- **Languages**: Python, TypeScript, Rust, PowerShell
- **Tools**: Docker, Terraform, Jupyter, GitHub Copilot
- **Productivity**: Markdown Preview Enhanced

## Cross-Platform Considerations

### Path Resolution
Both setup scripts use dynamic path resolution to locate dotfiles:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")/dotfiles"
```

### Line Ending Handling
Ubuntu setup script automatically converts Windows line endings:
```bash
tr -d '\r' < "$source_file" > "$file"
```

### Shell Configuration
Both platforms ensure zsh custom configuration is properly linked:
```bash
if ! grep -q "source ~/.zshrc.custom" ~/.zshrc 2>/dev/null; then
    echo "source ~/.zshrc.custom" >> ~/.zshrc
fi
```

## Error Handling and Verification

### Setup Script Features
- Exit on error (`set -e`) for fail-fast behavior
- Command existence checking (`command_exists()`)
- File verification (`verify_file()`)
- Comprehensive installation verification
- Platform-specific adaptation (macOS vs WSL detection)

### Common Issues and Solutions

**macOS**:
- Shell change verification and manual fallback
- Homebrew PATH configuration for Apple Silicon
- Xcode Command Line Tools installation prompts

**Windows/WSL2**:
- PowerShell execution policy management
- WSL2 installation status checking
- Cross-platform file copying guidance

## Development Workflow

The setup creates a consistent development environment featuring:
- **Enhanced Terminal**: tmux with vim-style navigation and modern plugins
- **Modern CLI**: Quality-of-life improvements with colorful, fast tools
- **Unified Shell**: Consistent aliases and functions across platforms
- **Development Ready**: Pre-configured tools for multiple languages and platforms
- **Cross-Platform**: Identical configuration files ensure consistent experience

## Testing and Verification

Both setup scripts include comprehensive verification that validates:
- Installation of all required packages and tools
- Creation and proper linking of dotfiles
- Plugin manager installations (Oh My Zsh, TPM)
- Shell configuration integration
- File permissions and accessibility