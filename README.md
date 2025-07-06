# Mac Development Environment Setup

Automated setup script to create a consistent, high-quality development environment on macOS with modern CLI tools, enhanced terminal experience, and essential development applications.

## 🚀 Quick Start

### 1. Download Files

Clone this repository or download these files:
- `mac-setup.sh` (Main setup script)
- `.tmux.conf` (tmux configuration)
- `.zshrc.custom` (zsh configuration)
- `.vimrc` (vim configuration)

### 2. Run Setup

```bash
# Make the script executable
chmod +x mac-setup.sh

# Run the setup script
./mac-setup.sh
```

The script will automatically:
- Install Homebrew (if not already installed)
- Install all development tools and CLI utilities
- Set up dotfiles and configurations
- Install Visual Studio Code and extensions
- Configure tmux, zsh, and vim

### 3. Manual Steps

1. **Install Xcode from App Store** (if you need the full IDE)
2. **Restart your terminal** to use zsh as default shell
3. **Install tmux plugins**: Open tmux and press `Ctrl+a` then `I`
4. **Configure Git**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## 🛠️ What Gets Installed

### Applications
- **Visual Studio Code** - Primary code editor
- **Docker Desktop** - Containerization platform
- **Xcode Command Line Tools** - Essential build tools

### Development Tools
- **Homebrew** - Package manager for macOS
- **Node.js** - JavaScript runtime
- **Terraform** - Infrastructure as code
- **AWS CLI** - Amazon Web Services command line
- **Git** - Version control (with Git LFS)
- **Rust** - Modern systems programming language

### Quality of Life CLI Tools
- **eza** - Modern replacement for ls with colors and icons
- **ripgrep** - Fast text search tool
- **fd** - Better find command
- **fzf** - Fuzzy finder for files and commands
- **bat** - Better cat with syntax highlighting
- **tree** - Directory tree visualization
- **htop** - Better top command
- **jq** - JSON processor
- **tldr** - Simplified man pages

### Terminal & Shell
- **tmux** - Terminal multiplexer with plugins
- **zsh** - Modern shell with Oh My Zsh
- **Oh My Zsh** - Zsh framework with themes and plugins
- **TPM** - Tmux Plugin Manager

## 📋 Configuration Details

### Shell Features
- **Default Shell**: zsh with Oh My Zsh (robbyrussell theme)
- **Quality of Life Aliases**:
  - `ls` → `eza` (colorful file listing with icons)
  - `cat` → `bat` (syntax highlighting)
  - `find` → `fd` (smart file finding)
  - `grep` → `rg` (ripgrep for fast searching)
- **Git Shortcuts**: `gs`, `ga`, `gc`, `gp`, `gl`
- **Terraform Shortcuts**: `tf`, `tfa`, `tfp`

### tmux Configuration
- **Prefix Key**: `Ctrl+a` (instead of default `Ctrl+b`)
- **Mouse Support**: Click panes, drag borders, scroll with wheel
- **Plugin Manager**: TPM with essential productivity plugins
- **Key Bindings**:
  - `Ctrl+a c` - New window
  - `Ctrl+a |` - Split vertically
  - `Ctrl+a -` - Split horizontally
  - `Ctrl+a h/j/k/l` - Navigate panes (vim-style)

### Vim Configuration
- **Modern Features**: Relative line numbers, syntax highlighting
- **Smart Editing**: Auto-indentation, smart case searching
- **File Handling**: Automatic backup and persistent undo

### VS Code Extensions
- **Remote Development**: SSH, Containers
- **Version Control**: GitLens
- **Languages**: Python, TypeScript, Rust, PowerShell
- **Tools**: Docker, Terraform, Jupyter
- **Productivity**: GitHub Copilot, Markdown Preview Enhanced

## 🧪 Testing Your Setup

After installation, test these commands:

```bash
# Quality of life tools
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

## 🔧 Customization

### Adding More Tools
Edit `mac-setup.sh` and add packages to the brew install commands:
```bash
brew install your-package-name
```

### Customizing Aliases
Edit `.zshrc.custom` to add your own aliases:
```bash
alias myalias='your-command'
```

### tmux Plugins
Add more plugins to `.tmux.conf`:
```bash
set -g @plugin 'plugin-name'
```

## 🆘 Troubleshooting

### Homebrew Installation Issues
- Make sure you have internet connection
- Check if Xcode Command Line Tools are installed: `xcode-select --install`
- For Apple Silicon Macs, make sure Homebrew is in your PATH

### VS Code Extensions Not Installing
- Restart terminal after VS Code installation
- Manually install extensions: `code --install-extension extension-name`

### tmux Plugins Not Working
- Ensure TPM is installed: `ls ~/.tmux/plugins/tpm`
- Install plugins manually: `Ctrl+a` then `I`
- Restart tmux: `tmux kill-server` then `tmux`

### Shell Not Changing to zsh
- Restart your terminal application
- Manually change shell: `chsh -s $(which zsh)`

## 🎯 Repository Structure

```
mac-dev-setup/
├── mac-setup.sh      # Main setup script
├── .tmux.conf        # tmux configuration
├── .zshrc.custom     # zsh configuration
├── .vimrc           # vim configuration
├── README.md        # This file
└── CLAUDE.md        # Instructions for Claude Code
```

## 🚀 Next Steps

1. **Customize your setup** by editing the dotfiles
2. **Explore tmux plugins** and add more productivity tools
3. **Set up your development projects** with the new environment
4. **Configure VS Code** with your preferred settings and themes

## 🎉 Enjoy Your Development Environment!

You now have a powerful, consistent development environment with:
- Modern CLI tools with quality of life improvements
- Enhanced terminal experience with tmux
- Professional code editor with essential extensions
- Consistent shell experience with helpful aliases
- Development tools for various languages and platforms

Happy coding! 🚀