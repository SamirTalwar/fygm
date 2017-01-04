#!/bin/bash

export PATH="/usr/local/bin:$PATH"

command -v brew >/dev/null 2>&1 || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

set -e
set -x

function quietly {
  set +x
  "$@"
  set -x
}

brew update

# Shell
brew install \
  autojump \
  bash \
  mobile-shell \
  the_silver_searcher \
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
  gnupg2 \
  gpg-agent \
  htop-osx \
  httpie \
  httping \
  jq \
  moreutils \
  pinentry \
  pinentry-mac \
  socat \
  unrar \
  wget

# Terminal Fu
brew install \
  entr \
  fswatch \
  terminal-notifier

# Image Manipulation
brew install \
  imagemagick \
  pngcrush
brew cask install gimp

# Development
brew install \
  carthage \
  cmake \
  elm \
  git \
  haskell-stack \
  heroku-toolbelt \
  mercurial \
  node \
  python \
  python3 \
  ruby \
  sqlite \
  tidy-html5

# Java Development
brew cask install java
brew install \
  groovy \
  gradle \
  leiningen \
  maven \
  scala \
  sbt

# Text Editing
brew install vim
brew install neovim/neovim/neovim
pip2 install neovim
pip3 install neovim

brew install pandoc
brew cask install mactex

# Containerisation
brew cask install \
  virtualbox \
  virtualbox-extension-pack \
  docker

if ! fgrep /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi
if [[ $(dscl . -read /Users/$USER UserShell | field 2) != '/usr/local/bin/zsh' ]]; then
  sudo chsh -s /usr/local/bin/zsh $USER
fi

brew linkapps
brew cleanup
