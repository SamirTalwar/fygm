#!/bin/bash

export PATH="/usr/local/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && \
  source "$HOME/.rvm/scripts/rvm"
[[ -s "$HOME/.nvm/nvm.sh" ]] && \
  source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
  export SDKMAN_DIR="$HOME/.sdkman" && \
  source "$HOME/.sdkman/bin/sdkman-init.sh"

command -v brew >/dev/null 2>&1 || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
command -v rvm >/dev/null 2>&1 || curl -fsSL https://get.rvm.io | bash -s head --ruby

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
  gnupg2 \
  gpg-agent \
  htop-osx \
  httpie \
  jq \
  moreutils \
  pinentry \
  pinentry-mac \
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
  git \
  heroku-toolbelt \
  mercurial \
  python \
  python3 \
  sqlite
brew cask install \
  elm-platform \
  haskell-platform
brew install haskell-stack

nvm_version="$(http https://api.github.com/repos/creationix/nvm/tags | jq -r '.[0].name')"
curl -fsSL "https://raw.githubusercontent.com/creationix/nvm/$nvm_version/install.sh" | bash

# Text Editing
brew install vim
brew install --HEAD neovim/neovim/neovim
pip2 install neovim
pip3 install neovim

brew install pandoc
brew cask install mactex

# Java Development
brew cask install java
brew install \
  leiningen \
  maven
command -v sdk >/dev/null 2>&1 || curl -fs http://get.sdkman.io | bash
quietly sdk install scala
quietly sdk install sbt
quietly sdk install groovy

# Containerisation
brew cask install \
  virtualbox \
  virtualbox-extension-pack
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

brew linkapps
brew cleanup
