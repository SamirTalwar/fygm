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
brew upgrade

# Shell
brew install \
  autojump \
  bash \
  mobile-shell \
  the_silver_searcher \
  tmux \
  tree \
  urlview \
  watch \
  zsh
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

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
brew cask install xquartz

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
  ocaml \
  opam \
  python \
  python3 \
  ruby \
  sqlite \
  tidy-html5
brew cask install font-fira-code

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
gem install neovim

brew install pandoc

# Chat
brew install weechat --with-curl --with-lua --with-perl --with-python --with-ruby
pip2 install websocket-client
mkdir -p ~/.weechat/python/autoload
curl -fsSL https://raw.githubusercontent.com/rawdigits/wee-slack/master/wee_slack.py \
  > ~/.weechat/python/autoload/wee_slack.py

# Containerisation
brew cask install \
  virtualbox \
  virtualbox-extension-pack \
  docker
brew install \
  docker-completion \
  docker-compose-completion

if ! fgrep /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi
if [[ $(dscl . -read /Users/$USER UserShell | field 2) != '/usr/local/bin/zsh' ]]; then
  sudo chsh -s /usr/local/bin/zsh $USER
fi

brew linkapps
brew cleanup
