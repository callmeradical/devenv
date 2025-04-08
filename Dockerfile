FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y \
screen git curl ca-certificates sudo build-essential \
    lsof libssl-dev libcurl4-openssl-dev nodejs \
    npm python3 python3-pip ripgrep fd-find zsh \
    && npm install -g typescript ts-node nodemon

RUN apt-get update && apt-get install -y locales \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

COPY ./nvim /root/.config/nvim

RUN curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
    && CHSH=no RUNZSH=no bash install.sh \
    && rm install.sh

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.appimage \
    && chmod u+x nvim-linux-arm64.appimage \
    && ./nvim-linux-arm64.appimage --appimage-extract \
    && mkdir -p /opt/nvim \
    && mv squashfs-root/* /opt/nvim/ \
    && rm nvim-linux-arm64.appimage \
    && ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim \
    && ln -s /usr/local/bin/nvim /usr/local/bin/vim

RUN chsh -s $(which zsh) root

RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /root/.zshrc

# Install Oh My Zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
 && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


WORKDIR /workspace

CMD ["zsh"]
