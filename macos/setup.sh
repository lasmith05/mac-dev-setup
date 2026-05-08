#!/bin/bash
# Mac Development Environment Setup Script
# Creates a consistent development environment with quality of life improvements

set -e  # Exit on any error

echo "🍎 Setting up Mac Development Environment..."

# Get script directory to find dotfiles
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")/dotfiles"

echo "🔍 Looking for dotfiles in: $DOTFILES_DIR"

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

# Install a brew formula only if not already installed
# Handles tap-prefixed names (e.g. hashicorp/tap/terraform-ls)
brew_install() {
    local package="$1"
    local formula_name="${package##*/}"   # strip tap prefix
    if brew list --formula "$formula_name" &>/dev/null; then
        echo "✅ $formula_name already installed, skipping"
    else
        brew install "$package"
    fi
}

# Install a brew cask only if not already installed
brew_install_cask() {
    local package="$1"
    local cask_name="${package##*/}"
    if brew list --cask "$cask_name" &>/dev/null; then
        echo "✅ $cask_name already installed, skipping"
    else
        brew install --cask "$package" || echo "⚠️ $cask_name installation had issues, continuing..."
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
for pkg in tmux zsh git curl wget unzip; do
    brew_install "$pkg"
done

# Install quality of life CLI tools
echo "✨ Installing quality of life CLI tools..."
for pkg in eza ripgrep fd fzf bat tree htop btop glances jq tldr; do
    brew_install "$pkg"
done

# Install development languages and tools
echo "🛠️ Installing development languages and tools..."

# Check for tfenv conflict before installing terraform
if command_exists tfenv; then
    echo "⚠️  tfenv detected. Skipping terraform installation (use 'tfenv install latest' instead)"
    brew_install node
    brew_install awscli
    brew list --formula docker &>/dev/null || brew install --formula docker
    brew_install git-lfs
    brew_install neovim
    brew_install python3
else
    brew_install node
    brew_install terraform
    brew_install awscli
    brew list --formula docker &>/dev/null || brew install --formula docker
    brew_install git-lfs
    brew_install neovim
    brew_install python3
fi

# Install terraform-ls (Terraform Language Server for Neovim/COC)
echo "🏗️ Installing terraform-ls..."
if brew list --formula terraform-ls &>/dev/null; then
    echo "✅ terraform-ls already installed, skipping"
else
    brew install hashicorp/tap/terraform-ls || echo "⚠️ terraform-ls installation had issues, continuing..."
fi

# Install GUI applications via Homebrew Cask
echo "🖥️ Installing GUI applications..."
brew_install_cask visual-studio-code

# Install FiraCode Nerd Font
echo "🔤 Installing FiraCode Nerd Font..."
brew_install_cask font-fira-code-nerd-font

echo "💡 Note: Docker CLI is installed via brew. For Docker Desktop GUI, install manually from:"
echo "   https://www.docker.com/products/docker-desktop"

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
echo "🔍 Checking if Oh My Zsh already exists..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Oh My Zsh not found, installing..."
    echo "🔍 About to run: curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    if sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        echo "✅ Oh My Zsh installation completed"
        echo "🔍 Verifying installation..."
        if [ -d "$HOME/.oh-my-zsh" ]; then
            echo "✅ Oh My Zsh directory exists"
        else
            echo "❌ Oh My Zsh directory not found after installation"
        fi
        if [ -f "$HOME/.zshrc" ]; then
            echo "✅ .zshrc file created"
        else
            echo "❌ .zshrc file not created"
        fi
    else
        echo "❌ Oh My Zsh installation failed with exit code: $?"
    fi
else
    echo "✅ Oh My Zsh already installed"
fi

# Install TPM (Tmux Plugin Manager)
echo "🔌 Installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Create tmux directories to prevent resurrection errors
echo "📁 Creating tmux directories..."
mkdir -p ~/.tmux/resurrect
echo "✅ tmux directories created"

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
    
    if [ -f "$source_file" ]; then
        echo "📄 Processing $file..."
        if cp "$source_file" "$file"; then
            echo "✅ $file created successfully"
        else
            echo "❌ Failed to copy $source_file to $file"
        fi
    else
        echo "⚠️  $source_file not found, skipping $file"
    fi
}

# Create dotfiles from dotfiles directory
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
        echo "🔗 Linking custom zsh config to .zshrc..."
        echo "" >> ~/.zshrc
        echo "# Custom configuration" >> ~/.zshrc
        echo "source ~/.zshrc.custom" >> ~/.zshrc
        echo "✅ Custom config linked to .zshrc"
    else
        echo "✅ Custom config already linked in .zshrc"
    fi
fi

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
bash "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

# Install Python development packages
echo "🐍 Installing Python development packages..."
# Check if Python environment is externally managed
if pip3 install --user --dry-run black 2>&1 | grep -q "externally-managed-environment"; then
    echo "⚠️ Python environment is externally managed. Installing via pipx instead..."
    if ! command_exists pipx; then
        brew install pipx
    fi
    pipx install black
    pipx install flake8
    pipx install pylint
    pipx install isort
    # Install pynvim for Neovim Python support
    pip3 install --user --break-system-packages --no-warn-script-location pynvim || echo "⚠️ pynvim installation failed"
    echo "✅ Python packages installed via pipx"
else
    pip3 install --user black flake8 pylint isort python-lsp-server[all] pynvim || echo "⚠️ Some Python packages failed to install"
fi

# Install VS Code extensions
echo "🧩 Installing VS Code extensions..."
if command_exists code; then
    echo "Installing recommended VS Code extensions..."
    code --install-extension ms-vscode-remote.remote-ssh || true
    code --install-extension eamodio.gitlens || true
    code --install-extension hashicorp.terraform || true
    code --install-extension ms-python.python || true
    code --install-extension ms-vscode.js-debug || true
    code --install-extension bradlc.vscode-tailwindcss || true
    code --install-extension ms-vscode.vscode-typescript-next || true
    code --install-extension ms-azuretools.vscode-docker || true
    code --install-extension github.copilot || true
    code --install-extension ms-vscode.powershell || true
    code --install-extension rust-lang.rust-analyzer || true
    code --install-extension ms-toolsai.jupyter || true
    code --install-extension ms-vscode-remote.remote-containers || true
    code --install-extension shd101wyy.markdown-preview-enhanced || true
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
if command_exists tfenv; then
    echo "✅ terraform managed by tfenv (use 'tfenv install latest' to install terraform)"
else
    command_exists terraform && echo "✅ terraform installed" || echo "❌ terraform missing"
fi
command_exists terraform-ls && echo "✅ terraform-ls installed" || echo "❌ terraform-ls missing"
command_exists node && echo "✅ node.js installed" || echo "❌ node.js missing"
command_exists nvim && echo "✅ neovim installed" || echo "❌ neovim missing"
command_exists python3 && echo "✅ python3 installed" || echo "❌ python3 missing"
command_exists code && echo "✅ visual studio code installed" || echo "❌ visual studio code missing"

# Check if FiraCode Nerd Font is installed
if ls ~/Library/Fonts/FiraCode* >/dev/null 2>&1 || ls /Library/Fonts/FiraCode* >/dev/null 2>&1 || ls /System/Library/Fonts/FiraCode* >/dev/null 2>&1; then
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
echo "   code  # Should open Visual Studio Code"
echo "5. 📱 Install full Xcode from the App Store if needed"
echo ""
echo "🛠️  If any items show ❌, you may need to run parts of the setup manually."
echo "🎯  For issues, check the GitHub repository README for troubleshooting."
echo ""
echo "Enjoy your Mac development environment! 🚀"