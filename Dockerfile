FROM callmeradical/devenv:latest

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install NVM, Node.js (via NVM), and Global Packages
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install 20 \
    && nvm use 20 \
    && nvm alias default 20 \
    && npm install -g typescript ts-node nodemon \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Load NVM automatically in every shell
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.zshrc

WORKDIR /workspace

CMD ["zsh"]
