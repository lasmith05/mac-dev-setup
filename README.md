# Cross-Platform Development Environment Setup

Automated setup scripts to create a consistent, high-quality development environment across macOS and Windows (with WSL2). This repository provides modern CLI tools, enhanced terminal experience, and essential development applications.

## 🚀 Quick Start

Choose your platform and follow the setup instructions:

### macOS Setup

```bash
# Clone the repository
git clone <repository-url>
cd dev-setup

# Make setup script executable and run
chmod +x macos/setup.sh
./macos/setup.sh
```

### Windows Setup

```batch
# Clone the repository
git clone <repository-url>
cd dev-setup

# Method 1: Automated (Recommended)
# Right-click windows/setup.bat and "Run as administrator"

# Method 2: Manual
# Run PowerShell as Administrator, then:
./windows/windows-setup.ps1
# After restart, in WSL2 Ubuntu:
./windows/ubuntu-setup.sh
```

## 🗂️ Repository Structure

```
dev-setup/
├── README.md                 # This file
├── CLAUDE.md                 # Instructions for Claude Code
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

## 🛠️ What Gets Installed

### Core Development Tools
- **Languages**: Node.js, Rust (with Cargo), Python 3
- **Infrastructure**: Terraform, AWS CLI, Docker
- **Version Control**: Git with Git LFS
- **Editors**: Visual Studio Code with extensions, Vim

### Modern CLI Tools
- **File Operations**: eza (ls replacement), bat (cat replacement), fd (find replacement)
- **Search**: ripgrep (grep replacement), fzf (fuzzy finder)
- **System**: htop, tree, jq, tldr
- **Terminal**: tmux with TPM plugin manager

### Shell Environment
- **Shell**: zsh with Oh My Zsh (robbyrussell theme)
- **Key Aliases**: Modern command replacements and git shortcuts
- **Functions**: File extraction, weather lookup, directory navigation utilities

## 📋 Platform-Specific Details

### macOS
- **Package Manager**: Homebrew
- **Applications**: Visual Studio Code, Xcode Command Line Tools
- **Docker**: CLI included (Docker Desktop available for manual install)
- **Shell**: Native zsh with Oh My Zsh
- **Terminal**: Enhanced with tmux and modern CLI tools

### Windows + WSL2
- **Phase 1 (Windows)**: WSL2 installation, Windows applications via winget
- **Phase 2 (Ubuntu)**: Development environment in WSL2 Ubuntu
- **Cross-Platform**: Files accessible from both Windows and Ubuntu

## 🔧 Configuration Features

### Shell Configuration (.zshrc.custom)
```bash
# Modern CLI tool aliases
alias ls='eza --icons'
alias cat='bat'
alias find='fd'
alias grep='rg'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'

# Terraform shortcuts
alias tf='terraform'
alias tfa='terraform apply'
alias tfp='terraform plan'
```

### Tmux Configuration (.tmux.conf)
- **Prefix Key**: `Ctrl+a` (instead of default `Ctrl+b`)
- **Navigation**: Vim-style pane navigation (`h`/`j`/`k`/`l`)
- **Splitting**: `|` for vertical split, `-` for horizontal split
- **Mouse Support**: Click panes, drag borders, scroll with wheel
- **Plugins**: TPM with productivity plugins (resurrect, continuum, yank)

### Vim Configuration (.vimrc)
- **Modern Features**: Relative line numbers, syntax highlighting, smart indentation
- **Key Mappings**: `jj` to exit insert mode, `Ctrl+s` to save
- **File Handling**: Automatic backup, undo history, trailing whitespace removal
- **Development**: File type specific settings, spell checking for text files

## 🧪 Testing Your Setup

After installation, test these commands:

```bash
# Modern CLI tools
ls          # Should show colorful output with icons
cat ~/.zshrc # Should show syntax highlighting
tree        # Should show directory structure
rg "text"   # Fast text search

# Development tools
node --version
terraform --version
aws --version
code --version

# Terminal multiplexer
tmux        # Should start with mouse support
# Press Ctrl+a then I to install plugins
```

## 🔄 Manual Post-Setup Steps

1. **Configure Git credentials**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Install tmux plugins**:
   - Open tmux: `tmux`
   - Press `Ctrl+a` then `I` to install plugins

3. **Restart terminal** to ensure all changes take effect

4. **macOS Only**: Install full Xcode from App Store if needed

## 🎯 Cross-Platform Consistency

### Shared Configuration
All platforms use identical dotfiles ensuring consistent development experience:
- Same tmux configuration and key bindings
- Same zsh aliases and functions
- Same vim configuration and key mappings

### Platform Adaptations
- **macOS**: Native Homebrew packages and GUI applications
- **Windows**: WSL2 with Ubuntu, Windows applications via winget
- **Line Endings**: Automatic conversion for cross-platform compatibility

## 🆘 Troubleshooting

### macOS Issues
- **Homebrew installation**: Make sure Xcode Command Line Tools are installed
- **Shell not changing**: Run `chsh -s $(which zsh)` manually
- **VS Code extensions**: Restart terminal after VS Code installation

### Windows Issues
- **WSL2 installation**: Ensure Windows version supports WSL2 (Windows 10 2004+ or Windows 11)
- **PowerShell execution**: Run PowerShell as Administrator
- **Ubuntu setup**: Copy files from Windows to Ubuntu before running ubuntu-setup.sh

### Common Issues
- **Tmux plugins**: Install manually with `Ctrl+a` then `I`
- **dotfiles not found**: Ensure you're running scripts from the correct directory
- **Permission errors**: Check that setup scripts are executable (`chmod +x`)

## 🔧 Customization

### Adding More Tools
Edit the setup scripts and add packages:

**macOS**:
```bash
brew install your-package-name
```

**Windows/Ubuntu**:
```bash
sudo apt install your-package-name
```

### Customizing Dotfiles
Edit files in the `dotfiles/` directory:
- `.tmux.conf`: Add tmux plugins and key bindings
- `.zshrc.custom`: Add aliases and functions
- `.vimrc`: Add vim plugins and configurations

### Adding Aliases
Edit `dotfiles/.zshrc.custom`:
```bash
alias myalias='your-command'
```

## 🎉 Enjoy Your Development Environment!

You now have a powerful, consistent development environment with:
- Modern CLI tools with quality of life improvements
- Enhanced terminal experience with tmux
- Professional code editor with essential extensions
- Consistent shell experience with helpful aliases
- Development tools for various languages and platforms

Happy coding! 🚀