#!/bin/bash

export PATH="/usr/local/bin:$PATH"

java_present=false
if /usr/libexec/java_home -F >/dev/null 2>&1; then
    java_present=true
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && \
    source "$HOME/.rvm/scripts/rvm"
[[ -s "$HOME/.nvm/nvm.sh" ]] && \
    source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
    export SDKMAN_DIR="$HOME/.sdkman" && \
    source "$HOME/.sdkman/bin/sdkman-init.sh"

command -v brew >/dev/null 2>&1 || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
if $java_present; then
    command -v sdk >/dev/null 2>&1 || curl -fs http://get.sdkman.io | bash
fi
command -v rvm >/dev/null 2>&1 || curl -fsSL https://get.rvm.io | bash -s head --ruby

set -e
set -x

function quietly {
    set +x
    "$@"
    set -x
}

# Shell
brew install \
    autojump \
    bash \
    mobile-shell \
    the_silver_searcher \
    thefuck \
    tmux \
    tree \
    watch \
    zsh

# Core Tools
brew install \
    coreutils \
    curl \
    dos2unix \
    findutils \
    gawk \
    gnu-sed \
    gnupg \
    htop-osx \
    httpie \
    jq \
    moreutils \
    unrar \
    wget

# Terminal Fu
brew install \
    entr \
    fswatch \
    terminal-notifier

# Text Editing
brew install vim
brew install --HEAD neovim/neovim/neovim

# Image Manipulation
brew install \
    imagemagick \
    pngcrush

# Development
brew install \
    carthage \
    cmake \
    git \
    heroku-toolbelt \
    kubernetes-cli \
    mercurial \
    python \
    python3 \
    racket \
    sqlite
brew cask install \
    elm-platform \
    haskell-platform
brew install haskell-stack
raco pkg install --auto --skip-installed xrepl

if ! command -v nvm >/dev/null; then
    nvm_version="$(http https://api.github.com/repos/creationix/nvm/tags | jq -r '.[0].name')"
    curl -fsSL "https://raw.githubusercontent.com/creationix/nvm/$nvm_version/install.sh" | bash
fi

# Java Development
if $java_present; then
    brew install \
        leiningen \
        maven
    quietly sdk install scala
    quietly sdk install sbt
    quietly sdk install groovy
fi

# Containerisation
brew cask install \
    virtualbox
brew install \
    docker \
    docker-compose \
    docker-machine

if ! docker-machine ls -q | egrep '^default$' >/dev/null; then
    docker-machine create --driver=virtualbox --virtualbox-memory=4096 default
fi

if ! fgrep /usr/local/bin/zsh /etc/shells; then
    sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi
sudo chsh -s /usr/local/bin/zsh $USER
