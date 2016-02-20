#!/bin/bash

export PATH="/usr/local/bin:$PATH"

[[ -d "$HOME/.rvm" ]] && export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

which brew 2>/dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
which sdk 2>/dev/null || curl -fs http://get.sdkman.io | bash
which rvm 2>/dev/null || curl -sSL https://get.rvm.io | bash -s head --ruby

set -e
set -x

function quietly {
    set +x
    "$@"
    set -x
}

# Meta
brew install caskroom/cask/brew-cask

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
brew install \
    macvim \
    vim
brew install --HEAD \
    neovim/neovim/neovim

# Image Manipulation
brew install \
    imagemagick \
    pngcrush

# Development
brew install \
    carthage \
    git \
    heroku-toolbelt \
    kubernetes-cli \
    leiningen \
    maven \
    mercurial \
    python \
    python3 \
    racket \
    sqlite
brew cask install \
    elm-platform \
    haskell-platform
quietly sdk install scala
quietly sdk install sbt
quietly sdk install groovy
raco pkg install --auto --skip-installed xrepl

nvm_version="$(http https://api.github.com/repos/creationix/nvm/tags | jq -r '.[0].name')"
curl -fsSL "https://raw.githubusercontent.com/creationix/nvm/$nvm_version/install.sh" | bash

# Containerisation
brew cask install \
    virtualbox
brew install \
    docker \
    docker-compose \
    docker-machine

docker-machine create --driver=virtualbox --virtualbox-memory=4096 default

if ! fgrep /usr/local/bin/zsh /etc/shells; then
    sudo bash -c "cat /usr/local/bin/zsh > /etc/shells && chsh -s /usr/local/bin/zsh $USER"
fi
