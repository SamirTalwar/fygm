#!/usr/bin/env zsh

set -e
set -u
set -o pipefail
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
