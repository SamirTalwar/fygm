#!/bin/bash

set -e
set -x

export PATH="${HOME}/.cabal/bin:${HOME}/.cargo/bin:${HOME}/.ghcup/bin:/usr/local/opt/ruby/bin:/usr/local/bin:${PATH}"

command -v brew >& /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/fonts

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
  ispell \
  jq \
  lastpass-cli \
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

# Development
brew install make --with-default-names
brew install \
  carthage \
  cmake \
  dep \
  elm \
  gcc \
  git \
  go \
  llvm \
  mercurial \
  node \
  pipenv \
  python \
  python3 \
  ruby \
  shellcheck \
  sqlite \
  swiftformat \
  tidy-html5 \
  yarn

# Cloud Development
brew cask install \
  docker \
  google-cloud-sdk
brew install \
  awscli \
  docker-completion \
  docker-compose-completion
pip3 install --user --upgrade \
  aws-sam-cli
gcloud components install -q alpha beta kubectl

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

# Haskell Development
command -v ghcup >& /dev/null || (
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=true
  curl https://get-ghcup.haskell.org -sSf | sh
)
cabal new-install cabal-install
brew install haskell-stack

# OCaml Development
brew install opam
opam init --no-setup
opam upgrade
opam install \
  ocaml \
  ocamlbuild

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

# Rust Development
command -v rustup >& /dev/null || (
  curl https://sh.rustup.rs -fsS | sh -s -- -y
)

# Editors
brew install
  aspell \
  emacs \
  neovim \
  pandoc
brew cask install \
  emacs
pip2 install --user pynvim sexpdata websocket-client
pip3 install --user pynvim sexpdata websocket-client
gem install neovim

if ! grep -F /usr/local/bin/zsh /etc/shells; then
  sudo bash -c "echo /usr/local/bin/zsh >> /etc/shells"
fi
if [[ "$(dscl . -read "/Users/$USER" UserShell | cut -d ' ' -f 2)" != '/usr/local/bin/zsh' ]]; then
  sudo chsh -s /usr/local/bin/zsh "$USER"
fi

brew cleanup
