FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    ripgrep \
    screen \
    sudo \
    zsh \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
    && CHSH=no RUNZSH=no bash install.sh \
    && rm install.sh \
    && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.appimage \
    && chmod u+x nvim-linux-arm64.appimage \
    && ./nvim-linux-arm64.appimage --appimage-extract \
    && mkdir -p /opt/nvim \
    && mv squashfs-root/* /opt/nvim/ \
    && rm nvim-linux-arm64.appimage \
    && ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
    && ln -s /usr/local/bin/nvim /usr/local/bin/vim

RUN chsh -s $(which zsh) root \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /root/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

WORKDIR /workspace

CMD ["zsh"]
