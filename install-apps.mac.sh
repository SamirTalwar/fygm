#!/usr/bin/env zsh

set -e
set -u
set -x

if ! command -v brew >& /dev/null; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew tap homebrew/cask-fonts

brew update
brew upgrade
brew cask upgrade

# macOS applications
brew cask install \
  beaker-browser \
  docker \
  emacs \
  etcher \
  firefox \
  font-fira-code \
  font-source-code-pro \
  jetbrains-toolbox \
  google-chrome \
  gpg-suite \
  keybase \
  ngrok \
  nordvpn \
  scroll-reverser \
  sketch \
  transmission \
  visual-studio \
  visual-studio-code \
  vlc \
  xquartz

# Packages that can't be handled with Nix
brew install \
  neovim \
  swi-prolog \
  swiftformat \
  zplug

brew cleanup

# tmux plugins
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# SWI Prolog packs
mkdir -p ~/.config/swipl/packs
swipl <<EOF
expand_file_name('~/.config/swipl/packs', [PacksDirectory]),
  asserta( (file_search_path(pack, PacksDirectory)) ).
attach_packs.
pack_install(regex, [upgrade(true), interactive(false)]).
halt.
EOF

# configure the user shell
CURRENT_SHELL=$(
  dscl . -read /Users/${USER} UserShell \
    | cut -d ' ' -f 2
)
if [[ $CURRENT_SHELL != ${HOME}/.nix-profile/bin/zsh ]]; then
  sudo chsh -s ${HOME}/.nix-profile/bin/zsh $USER
fi
