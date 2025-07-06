# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Mac development environment setup repository containing an automated setup script and configuration files for creating a consistent, high-quality development environment on macOS. The setup focuses on modern CLI tools, enhanced terminal experience, and essential development applications.

## Architecture

### Setup Process Flow
1. **Mac Setup** (`mac-setup.sh`): Installs Homebrew, development tools, GUI applications, and configures the development environment
2. **Configuration Files**: Dotfiles (`.tmux.conf`, `.zshrc.custom`, `.vimrc`) provide consistent development environment configuration
3. **Automatic Configuration**: Script automatically applies dotfiles and configures shell environment

### Key Components

- **Main Setup Script** (`mac-setup.sh`): Comprehensive macOS development environment setup including:
  - Homebrew package manager installation
  - Modern CLI tools (eza, ripgrep, fd, fzf, bat, tree, htop, jq, tldr)
  - Development languages and tools (Node.js, Rust, Terraform, AWS CLI)
  - GUI applications (Visual Studio Code, Docker Desktop)
  - Shell environment (zsh, Oh My Zsh)
  - Terminal multiplexer (tmux with TPM plugins)
  - VS Code extensions installation
- **Configuration Files**: Pre-configured dotfiles optimized for development workflow

## Setup Commands

### macOS Setup
```bash
# Make script executable and run
chmod +x mac-setup.sh
./mac-setup.sh
```

## Key Features

### Applications Installed
- **Visual Studio Code** - Primary code editor with extensions
- **Docker Desktop** - Containerization platform
- **Xcode Command Line Tools** - Essential build tools
- **Homebrew** - Package manager for macOS

### CLI Tools Installed
- **Modern CLI Tools**: eza, ripgrep, fd, fzf, bat, tree, htop, jq, tldr
- **Development Languages**: Node.js, Rust, Terraform, AWS CLI
- **Version Control**: Git with Git LFS
- **Shell**: zsh with Oh My Zsh (robbyrussell theme)
- **Terminal Multiplexer**: tmux with TPM (Tmux Plugin Manager)

### VS Code Extensions Installed
- Remote Development (SSH, Containers)
- GitLens (Git integration)
- Language support (Python, TypeScript, Rust, PowerShell)
- Development tools (Docker, Terraform, Jupyter)
- Productivity tools (GitHub Copilot, Markdown Preview Enhanced)

### Configuration Details

**Shell Configuration:**
- Default shell: zsh with Oh My Zsh
- Custom aliases: ls→eza, cat→bat, find→fd, grep→rg
- Git shortcuts: gs, ga, gc, gp, gl
- Terraform shortcuts: tf, tfa, tfp
- fzf integration for fuzzy finding

**Tmux Configuration:**
- Prefix key: Ctrl+a (instead of default Ctrl+b)
- Mouse support enabled
- Plugin manager (TPM) with essential plugins
- Vim-style pane navigation

**Vim Configuration:**
- Relative line numbers, syntax highlighting
- Smart indentation and modern keybindings
- Automatic backup and persistent undo history

## Verification and Testing

The setup script includes comprehensive verification that checks:
- Installation status of all CLI tools and applications
- Creation and proper configuration of dotfiles
- Plugin manager installations (Oh My Zsh, TPM)
- Shell configuration linking
- VS Code installation and availability

## Common Tasks

### Testing Installation
```bash
# Test CLI tools
ls          # Should show eza with colors and icons
cat file    # Should show bat with syntax highlighting
rg "text"   # Fast text search with ripgrep

# Test development tools
node --version
terraform --version
aws --version
code --version

# Test terminal multiplexer
tmux        # Should start with mouse support
```

### Installing tmux Plugins
```bash
# After tmux is running
Ctrl+a I    # Install plugins via TPM
```

### Customizing Environment
- Edit `.zshrc.custom` for shell customizations
- Edit `.tmux.conf` for tmux customizations
- Edit `.vimrc` for vim customizations

## Development Workflow

This setup creates a consistent development environment with:
- Enhanced terminal experience (tmux + modern CLI tools)
- Optimized shell with productivity aliases and shortcuts
- Version control integration (Git with helpful shortcuts)
- Cloud and infrastructure tooling (AWS CLI, Terraform)
- Modern code editor with essential extensions
- Cross-platform development capabilities (Docker, containers)
- Quality of life improvements for daily development tasks

The environment is designed to provide the same level of productivity and consistency as the Windows/WSL setup but tailored specifically for macOS development workflows.