#!/bin/bash

set -e

# Update packages
apt-get update

# Install base development tools
apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    fd-find \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    locales \
    lsof \
    python3 \
    python3-pip \
    python3-venv \
    python3-setuptools \
    python3-wheel \
    pipx \
    ripgrep \
    screen \
    tmux \
    zsh \
    sudo \
    stow

# Create vscode user if it doesn't exist
if ! id -u vscode > /dev/null 2>&1; then
    useradd -m -s /bin/zsh vscode
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode
fi

# Install pynvim
pip install pynvim --break-system-packages

# Install Oh My Zsh for vscode user
if [ ! -d "/home/vscode/.oh-my-zsh" ]; then
    sudo -u vscode sh -c 'curl -Lo /tmp/install-oh-my-zsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && CHSH=no RUNZSH=no ZSH=/home/vscode/.oh-my-zsh sh /tmp/install-oh-my-zsh.sh && rm /tmp/install-oh-my-zsh.sh'
fi

# Install Neovim from source or package
apt-get install -y ninja-build gettext cmake unzip || true

# Try to install from package first
if apt-get install -y neovim; then
    echo "Neovim installed from package"
else
    # Build from source as fallback
    echo "Building Neovim from source..."
    cd /tmp
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    tar -xzf nvim-linux64.tar.gz
    mv nvim-linux64 /opt/nvim
    ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    ln -sf /usr/local/bin/nvim /usr/local/bin/vim
    cd -
    rm -f /tmp/nvim-linux64.tar.gz
fi

# Configure zsh
if [ -f /home/vscode/.zshrc ]; then
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /home/vscode/.zshrc
fi

# Install zsh plugins
sudo -u vscode sh -c 'git clone https://github.com/zsh-users/zsh-autosuggestions /home/vscode/.oh-my-zsh/custom/plugins/zsh-autosuggestions'
sudo -u vscode sh -c 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/vscode/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting'

# Configure plugins in .zshrc
if [ -f /home/vscode/.zshrc ]; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /home/vscode/.zshrc
fi

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

# Clone and install dotfiles
INSTALL_DOTFILES="${INSTALLDOTFILES:-true}"
DOTFILES_REPO="${DOTFILESREPO:-https://github.com/callmeradical/dotfiles.git}"

if [ "$INSTALL_DOTFILES" = "true" ]; then
    echo "Installing dotfiles from $DOTFILES_REPO..."
    sudo -u vscode sh -c "cd /home/vscode && git clone $DOTFILES_REPO dotfiles"
    
    # Install dotfiles using stow
    sudo -u vscode sh -c 'cd /home/vscode/dotfiles && stow -v -t /home/vscode nvim tmux zsh git'
    
    # Install tmux plugin manager
    sudo -u vscode sh -c 'git clone https://github.com/tmux-plugins/tpm /home/vscode/.tmux/plugins/tpm'
else
    echo "Skipping dotfiles installation (INSTALL_DOTFILES=false)"
fi

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Base tools feature installed successfully!"
