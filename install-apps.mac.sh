#!/bin/bash

set -e
set -x

export PATH="$HOME/.cargo/bin:/usr/local/bin:$PATH"

command -v brew >& /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/fonts

command -v rustup >& /dev/null || (curl https://sh.rustup.rs -fsS | sh -s -- -y)

brew update
brew upgrade
brew cask upgrade


# Shell
brew cask install font-fira-code

brew install \
  autojump \
  bash \
  direnv \
  fzf \
  mosh \
  the_silver_searcher \
  tmux \
  tree \
  urlview \
  watch \
  zplug \
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
  htop-osx \
  httpie \
  httping \
  jq \
  moreutils \
  ncdu \
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

# macOS
brew cask install scroll-reverser

# Image Manipulation
brew install \
  imagemagick \
  pngcrush
brew cask install gimp

# Development
brew install \
  carthage \
  cmake \
  dep \
  emacs \
  elm \
  git \
  go \
  haskell-stack \
  heroku-toolbelt \
  llvm \
  mercurial \
  node \
  ocaml \
  opam \
  pipenv \
  python \
  python3 \
  ruby \
  shellcheck \
  sqlite \
  tidy-html5 \
  yarn
brew install make --with-default-names
brew cask install anaconda

# Prolog Development
brew install swi-prolog --with-libarchive
mkdir -p ~/.config/swipl/packs
swipl <<EOF
expand_file_name('~/.config/swipl/packs', [PacksDirectory]),
  asserta( (file_search_path(pack, PacksDirectory)) ).
attach_packs.
pack_install(regex, [upgrade(true), interactive(false)]).
halt.
EOF

# Java Development
brew cask install java
brew install \
  groovy \
  gradle \
  leiningen \
  maven \
  scala \
  sbt
brew cask install intellij-idea

# Text Editing
brew install neovim/neovim/neovim
pip2 install sexpdata websocket-client neovim
pip3 install sexpdata websocket-client neovim
gem install neovim

brew install pandoc

# Containerisation
brew cask install \
  docker \
  google-cloud-sdk
brew install \
  docker-completion \
  docker-compose-completion
gcloud components install -q alpha beta kubectl

if ! grep -F /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi
if [[ "$(dscl . -read "/Users/$USER" UserShell | cut -d ' ' -f 2)" != '/usr/local/bin/zsh' ]]; then
  sudo chsh -s /usr/local/bin/zsh "$USER"
fi

brew linkapps
brew cleanup
brew cask cleanup
