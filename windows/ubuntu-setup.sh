#!/bin/bash
# Ubuntu Development Environment Setup Script
# Run this inside WSL Ubuntu

set -e  # Exit on any error

echo "🚀 Setting up Ubuntu Development Environment..."

# Get script directory to find dotfiles
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")/dotfiles"

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

# Check if we're in WSL
if ! grep -q Microsoft /proc/version 2>/dev/null; then
    echo "⚠️  This script is designed for WSL. Continue anyway? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential development tools
echo "🔧 Installing essential development tools..."
sudo apt install -y \
    tmux \
    zsh \
    git \
    curl \
    wget \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    neovim \
    python3 \
    python3-pip \
    python3-venv

# Install quality of life CLI tools
echo "✨ Installing quality of life CLI tools..."
sudo apt install -y \
    eza \
    ripgrep \
    fd-find \
    fzf \
    bat

# Create bat symlink (Ubuntu installs it as batcat)
sudo ln -sf /usr/bin/batcat /usr/local/bin/bat

# Install Terraform
echo "🏗️ Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform

# Install Node.js and npm (useful for development)
echo "🟢 Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

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

# Install AWS CLI
echo "☁️ Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws/
fi

# Install FiraCode Nerd Font
echo "🔤 Installing FiraCode Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCode Bold Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Bold/FiraCodeNerdFont-Bold.ttf
curl -fLo "FiraCode Bold Italic Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/BoldItalic/FiraCodeNerdFont-BoldItalic.ttf
curl -fLo "FiraCode Light Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Light/FiraCodeNerdFont-Light.ttf
curl -fLo "FiraCode Light Italic Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/LightItalic/FiraCodeNerdFont-LightItalic.ttf
curl -fLo "FiraCode Medium Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFont-Medium.ttf
curl -fLo "FiraCode Medium Italic Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/MediumItalic/FiraCodeNerdFont-MediumItalic.ttf
curl -fLo "FiraCode Regular Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
curl -fLo "FiraCode Regular Italic Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/RegularItalic/FiraCodeNerdFont-RegularItalic.ttf
curl -fLo "FiraCode Retina Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Retina/FiraCodeNerdFont-Retina.ttf
curl -fLo "FiraCode Retina Italic Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/RetinaItalic/FiraCodeNerdFont-RetinaItalic.ttf
curl -fLo "FiraCode SemiBold Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/SemiBold/FiraCodeNerdFont-SemiBold.ttf
curl -fLo "FiraCode SemiBold Italic Nerd Font Complete.ttf" \
    https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/SemiBoldItalic/FiraCodeNerdFont-SemiBoldItalic.ttf
fc-cache -fv
cd -
echo "✅ FiraCode Nerd Font installed"

# Set up dotfiles with proper line endings
echo "📝 Setting up dotfiles..."

# Function to create dotfile with Unix line endings
create_dotfile() {
    local file="$1"
    local source_file="$2"
    
    if [ -f "$source_file" ]; then
        echo "📄 Processing $file..."
        # Remove Windows line endings and copy
        tr -d '\r' < "$source_file" > "$file"
        echo "✅ $file created with Unix line endings"
    else
        echo "⚠️  $source_file not found, skipping $file"
    fi
}

# Create dotfiles with proper line endings from dotfiles directory
create_dotfile ~/.tmux.conf "$DOTFILES_DIR/.tmux.conf"
create_dotfile ~/.vimrc "$DOTFILES_DIR/.vimrc"
create_dotfile ~/.zshrc.custom "$DOTFILES_DIR/.zshrc.custom"

# Set up Neovim configuration
echo "📝 Setting up Neovim configuration..."
mkdir -p ~/.config/nvim
create_dotfile ~/.config/nvim/init.vim "$DOTFILES_DIR/init.vim"
create_dotfile ~/.config/nvim/coc-settings.json "$DOTFILES_DIR/coc-settings.json"

# Verify dotfiles were created
echo "🔍 Verifying dotfiles..."
verify_file ~/.tmux.conf || echo "⚠️  .tmux.conf not created"
verify_file ~/.vimrc || echo "⚠️  .vimrc not created"
verify_file ~/.zshrc.custom || echo "⚠️  .zshrc.custom not created"

# Add custom zsh config to .zshrc
if [ -f "$HOME/.zshrc.custom" ]; then
    if ! grep -q "source ~/.zshrc.custom" ~/.zshrc 2>/dev/null; then
        echo "" >> ~/.zshrc
        echo "# Custom configuration" >> ~/.zshrc
        echo "source ~/.zshrc.custom" >> ~/.zshrc
    fi
fi

# Set zsh as default shell
echo "🐚 Setting zsh as default shell..."
sudo chsh -s $(which zsh) $USER

# Install tmux plugins
echo "🔌 Installing tmux plugins..."
if [ -f "$HOME/.tmux.conf" ]; then
    # Start tmux in detached mode and install plugins
    tmux new-session -d -s setup 2>/dev/null || true
    tmux send-keys -t setup "~/.tmux/plugins/tpm/bin/install_plugins" Enter 2>/dev/null || true
    sleep 5
    tmux kill-session -t setup 2>/dev/null || true
fi

# Install Python development packages
echo "🐍 Installing Python development packages..."
pip3 install --user black flake8 pylint isort python-lsp-server[all] || echo "⚠️ Some Python packages failed to install"

echo ""
echo "🎉 Ubuntu development environment setup complete!"
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
command_exists nvim && echo "✅ neovim installed" || echo "❌ neovim missing"
command_exists python3 && echo "✅ python3 installed" || echo "❌ python3 missing"

# Check if FiraCode Nerd Font is installed
if ls ~/.local/share/fonts/FiraCode* >/dev/null 2>&1; then
    echo "✅ FiraCode Nerd Font installed"
else
    echo "❌ FiraCode Nerd Font missing"
fi

# Verify dotfiles
echo ""
echo "📄 Checking dotfiles..."
verify_file ~/.tmux.conf
verify_file ~/.vimrc
verify_file ~/.zshrc.custom
verify_file ~/.config/nvim/init.vim
verify_file ~/.config/nvim/coc-settings.json

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
echo "   nvim  # Should open Neovim with plugins"
echo ""
echo "🛠️  If any items show ❌, you may need to run parts of the setup manually."
echo "🎯  For issues, check the GitHub repository README for troubleshooting."
echo ""
echo "Enjoy your new Mac-like development environment! 🚀"