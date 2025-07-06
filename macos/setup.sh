#!/bin/bash
# Mac Development Environment Setup Script
# Creates a consistent development environment with quality of life improvements

set -e  # Exit on any error

echo "🍎 Setting up Mac Development Environment..."

# Get script directory to find dotfiles
echo "🔍 Current working directory: $(pwd)"
echo "🔍 Script path: ${BASH_SOURCE[0]}"
echo "🔍 Script dirname: $(dirname "${BASH_SOURCE[0]}")"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")/dotfiles"

echo "🔍 Script location: $SCRIPT_DIR"
echo "🔍 Looking for dotfiles in: $DOTFILES_DIR"
echo "🔍 Does dotfiles directory exist? $([ -d "$DOTFILES_DIR" ] && echo "YES" || echo "NO")"
if [ -d "$DOTFILES_DIR" ]; then
    echo "🔍 Dotfiles directory contents:"
    ls -la "$DOTFILES_DIR"
else
    echo "🔍 Parent directory contents:"
    ls -la "$(dirname "$SCRIPT_DIR")"
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to verify file exists and is readable
verify_file() {
    if [ -f "$1" ] && [ -r "$1" ]; then
        echo "✅ $1 exists and is readable"
        return 0
    else
        echo "❌ $1 is missing or not readable"
        return 1
    fi
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "⚠️  This script is designed for macOS. Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install Homebrew if not already installed
if ! command_exists brew; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Update Homebrew
echo "📦 Updating Homebrew..."
brew update

# Install essential development tools
echo "🔧 Installing essential development tools..."
brew install \
    tmux \
    zsh \
    git \
    curl \
    wget \
    unzip

# Install quality of life CLI tools
echo "✨ Installing quality of life CLI tools..."
brew install \
    eza \
    ripgrep \
    fd \
    fzf \
    bat \
    tree \
    htop \
    jq \
    tldr

# Install development languages and tools
echo "🛠️ Installing development languages and tools..."
brew install \
    node \
    terraform \
    awscli \
    docker \
    git-lfs

# Install GUI applications via Homebrew Cask
echo "🖥️ Installing GUI applications..."
brew install --cask \
    visual-studio-code \
    docker

# Install Xcode Command Line Tools
echo "🛠️ Installing Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    echo "⚠️  Xcode Command Line Tools installation started. Please complete the installation in the popup dialog."
    echo "Press any key to continue after installation completes..."
    read -n 1
else
    echo "✅ Xcode Command Line Tools already installed"
fi

# Install full Xcode (optional - requires App Store)
echo "📱 Xcode Installation Note:"
echo "To install full Xcode, please download it from the App Store manually."
echo "This script installs Xcode Command Line Tools only."

# Install Oh My Zsh
echo "🐚 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install TPM (Tmux Plugin Manager)
echo "🔌 Installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Rust and Cargo (for some modern tools)
echo "🦀 Installing Rust and Cargo..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
fi

# Set up dotfiles
echo "📝 Setting up dotfiles..."

# Function to create dotfile
create_dotfile() {
    local file="$1"
    local source_file="$2"
    
    echo "🔍 Checking for: $source_file"
    if [ -f "$source_file" ]; then
        echo "📄 Processing $file..."
        if cp "$source_file" "$file"; then
            echo "✅ $file created successfully"
        else
            echo "❌ Failed to copy $source_file to $file"
        fi
    else
        echo "⚠️  $source_file not found, skipping $file"
        echo "🔍 Directory contents:"
        ls -la "$(dirname "$source_file")" || echo "Directory doesn't exist"
    fi
}

# Create dotfiles from dotfiles directory
create_dotfile ~/.tmux.conf "$DOTFILES_DIR/.tmux.conf"
create_dotfile ~/.vimrc "$DOTFILES_DIR/.vimrc"
create_dotfile ~/.zshrc.custom "$DOTFILES_DIR/.zshrc.custom"

# Verify dotfiles were created
echo "🔍 Verifying dotfiles..."
echo "🔍 Checking home directory for dotfiles:"
ls -la ~/. | grep -E "\.(tmux\.conf|vimrc|zshrc\.custom)" || echo "No dotfiles found in home directory"

echo "🔍 Individual file checks:"
verify_file ~/.tmux.conf || echo "⚠️  .tmux.conf not created"
verify_file ~/.vimrc || echo "⚠️  .vimrc not created" 
verify_file ~/.zshrc.custom || echo "⚠️  .zshrc.custom not created"

echo "🔍 Home directory permissions:"
ls -ld ~/

# Add custom zsh config to .zshrc
echo "🔍 Linking custom zsh config..."
if [ -f "$HOME/.zshrc.custom" ]; then
    echo "✅ .zshrc.custom exists, checking if linked..."
    if ! grep -q "source ~/.zshrc.custom" ~/.zshrc 2>/dev/null; then
        echo "📄 Adding source line to .zshrc..."
        echo "" >> ~/.zshrc
        echo "# Custom configuration" >> ~/.zshrc
        echo "source ~/.zshrc.custom" >> ~/.zshrc
        echo "✅ Custom config linked to .zshrc"
    else
        echo "✅ Custom config already linked in .zshrc"
    fi
else
    echo "❌ .zshrc.custom not found, cannot link to .zshrc"
fi

echo "🔍 Current .zshrc tail:"
tail -5 ~/.zshrc

# Set zsh as default shell (if not already)
if [[ "$SHELL" != */zsh ]]; then
    echo "🐚 Setting zsh as default shell..."
    chsh -s $(which zsh)
    echo "✅ Shell changed to zsh. Please restart your terminal."
else
    echo "✅ zsh is already the default shell"
fi

# Install tmux plugins
echo "🔌 Installing tmux plugins..."
if [ -f "$HOME/.tmux.conf" ]; then
    # Start tmux in detached mode and install plugins
    tmux new-session -d -s setup 2>/dev/null || true
    tmux send-keys -t setup "~/.tmux/plugins/tpm/bin/install_plugins" Enter 2>/dev/null || true
    sleep 5
    tmux kill-session -t setup 2>/dev/null || true
fi

# Install fzf key bindings and fuzzy completion
echo "🔍 Setting up fzf integration..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc

# Install VS Code extensions
echo "🧩 Installing VS Code extensions..."
if command_exists code; then
    echo "Installing recommended VS Code extensions..."
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-vscode.vscode-json
    code --install-extension eamodio.gitlens
    code --install-extension hashicorp.terraform
    code --install-extension ms-python.python
    code --install-extension ms-vscode.js-debug
    code --install-extension bradlc.vscode-tailwindcss
    code --install-extension ms-vscode.vscode-typescript-next
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension github.copilot
    code --install-extension ms-vscode.powershell
    code --install-extension rust-lang.rust-analyzer
    code --install-extension ms-toolsai.jupyter
    code --install-extension ms-vscode-remote.remote-containers
    code --install-extension shd101wyy.markdown-preview-enhanced
    echo "✅ VS Code extensions installed"
else
    echo "⚠️  VS Code not found in PATH. Extensions will be skipped."
    echo "Please restart your terminal and run: code --install-extension <extension-name>"
fi

echo ""
echo "🎉 Mac development environment setup complete!"
echo ""
echo "🔍 Final verification:"

# Verify installations
echo "📦 Checking installed packages..."
command_exists tmux && echo "✅ tmux installed" || echo "❌ tmux missing"
command_exists zsh && echo "✅ zsh installed" || echo "❌ zsh missing"
command_exists git && echo "✅ git installed" || echo "❌ git missing"
command_exists eza && echo "✅ eza installed" || echo "❌ eza missing"
command_exists bat && echo "✅ bat installed" || echo "❌ bat missing"
command_exists rg && echo "✅ ripgrep installed" || echo "❌ ripgrep missing"
command_exists fd && echo "✅ fd installed" || echo "❌ fd missing"
command_exists fzf && echo "✅ fzf installed" || echo "❌ fzf missing"
command_exists aws && echo "✅ aws cli installed" || echo "❌ aws cli missing"
command_exists terraform && echo "✅ terraform installed" || echo "❌ terraform missing"
command_exists node && echo "✅ node.js installed" || echo "❌ node.js missing"
command_exists code && echo "✅ visual studio code installed" || echo "❌ visual studio code missing"

# Verify dotfiles
echo ""
echo "📄 Checking dotfiles..."
verify_file ~/.tmux.conf
verify_file ~/.vimrc
verify_file ~/.zshrc.custom

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh installed"
else
    echo "❌ Oh My Zsh missing"
fi

# Check if TPM is installed
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "✅ Tmux Plugin Manager installed"
else
    echo "❌ Tmux Plugin Manager missing"
fi

# Check if custom config is loaded in .zshrc
if grep -q "source ~/.zshrc.custom" ~/.zshrc 2>/dev/null; then
    echo "✅ Custom zsh config is linked"
else
    echo "⚠️  Custom zsh config not linked in .zshrc"
fi

echo ""
echo "📋 Next steps:"
echo "1. 🔄 Restart your terminal to use zsh as default shell"
echo "2. 🔌 Open tmux and press Ctrl+a then I to install plugins"
echo "3. 🔧 Configure Git credentials:"
echo "   git config --global user.name 'Your Name'"
echo "   git config --global user.email 'your.email@example.com'"
echo "4. 🧪 Test your setup:"
echo "   ls    # Should show colorful output with icons"
echo "   cat ~/.zshrc  # Should show syntax highlighting"
echo "   tmux  # Should start with mouse support"
echo "   code  # Should open Visual Studio Code"
echo "5. 📱 Install full Xcode from the App Store if needed"
echo ""
echo "🛠️  If any items show ❌, you may need to run parts of the setup manually."
echo "🎯  For issues, check the GitHub repository README for troubleshooting."
echo ""
echo "Enjoy your Mac development environment! 🚀"