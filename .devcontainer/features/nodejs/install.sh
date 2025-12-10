#!/bin/bash

set -e

VERSION=${VERSION:-"20"}

echo "Installing Node.js version ${VERSION}..."

# Create vscode user if it doesn't exist
if ! id -u vscode > /dev/null 2>&1; then
    useradd -m -s /bin/zsh vscode
fi

# Install NVM for vscode user
sudo -u vscode sh -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'

# Install Node.js using NVM
sudo -u vscode bash -c 'export NVM_DIR="/home/vscode/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install '"${VERSION}"' && \
    nvm use '"${VERSION}"' && \
    nvm alias default '"${VERSION}"' && \
    npm install -g typescript ts-node nodemon'

# Add NVM to zshrc for persistent shell sessions
if [ -f /home/vscode/.zshrc ]; then
    echo '' >> /home/vscode/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> /home/vscode/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/vscode/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/vscode/.zshrc
fi

echo "Node.js ${VERSION} installed successfully!"
