#!/bin/bash

set -e
set -x

export PATH="/usr/local/bin:$PATH"

command -v nix-env >& /dev/null || curl -fsS https://nixos.org/nix/install | sh

command -v brew >& /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/fonts

command -v rustup >& /dev/null || (curl https://sh.rustup.rs -fsS | sh -s -- -y)

nix-channel --update
nix-env --upgrade

brew update
brew upgrade

nix-env --install --attr \
  nixpkgs.ag \
  nixpkgs.autojump \
  nixpkgs.bash \
  nixpkgs.mosh \
  nixpkgs.tmux \
  nixpkgs.tree \
  nixpkgs.urlview \
  nixpkgs.watch \
  nixpkgs.zsh \
  nixpkgs.zsh-completions
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Core Tools
nix-env --install --attr \
  nixpkgs.coreutils-prefixed \
  nixpkgs.curl \
  nixpkgs.dos2unix \
  nixpkgs.findutils \
  nixpkgs.htop \
  nixpkgs.httpie \
  nixpkgs.jq \
  nixpkgs.moreutils \
  nixpkgs.socat \
  nixpkgs.wget
brew install \
  gnupg \
  pinentry-mac
brew cask install xquartz

# Terminal Fu
nix-env --install --attr \
  nixpkgs.entr \
  nixpkgs.fswatch
brew install terminal-notifier

# Image Manipulation
nix-env --install --attr \
  nixpkgs.imagemagick \
  nixpkgs.pngcrush
brew cask install gimp

# Development
nix-env --install --attr \
  nixpkgs.cmake \
  nixpkgs.elmPackages.elm \
  nixpkgs.git \
  nixpkgs.go \
  nixpkgs.mercurial \
  nixpkgs.nodejs-8_x \
  nixpkgs.ocaml \
  nixpkgs.opam \
  nixpkgs.shellcheck \
  nixpkgs.sqlite \
  nixpkgs.stack
brew install \
  heroku-toolbelt \
  python \
  python3 \
  ruby \
  tidy-html5 \
  yarn
brew cask install font-fira-code
yarn global add flow-language-server tern

# Java Development
brew cask install java
nix-env --install --attr \
  nixpkgs.groovy \
  nixpkgs.gradle \
  nixpkgs.maven \
  nixpkgs.scala \
  nixpkgs.sbt
brew install leiningen

# Text Editing
nix-env --install --attr \
  nixpkgs.emacs \
  nixpkgs.pandoc \
  nixpkgs.vim

brew install neovim/neovim/neovim
pip2 install neovim
pip3 install neovim
gem install neovim

brew cask install emacs

# Containerisation
brew cask install \
  virtualbox \
  virtualbox-extension-pack \
  docker
brew install \
  docker-completion \
  docker-compose-completion

if ! grep -F /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi
if [[ "$(dscl . -read "/Users/$USER" UserShell | field 2)" != '/usr/local/bin/zsh' ]]; then
  sudo chsh -s /usr/local/bin/zsh "$USER"
fi

nix-collect-garbage --delete-old

brew linkapps
brew cleanup
