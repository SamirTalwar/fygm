#!/bin/bash

set -e
set -x

which brew 2>/dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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
    fswatch \
    gnu-sed \
    gnupg \
    htop-osx \
    httpie \
    jq \
    moreutils \
    unrar \
    wget

# Text Editing
brew install \
    macvim
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
    leiningen \
    maven \
    mercurial \
    python \
    python3 \
    sbt \
    sqlite
brew cask install \
    haskell-platform
\curl -sSL https://get.rvm.io | bash -s head --ruby

# Containerisation
brew cask install \
    virtualbox
brew install \
    docker \
    docker-compose \
    docker-machine
