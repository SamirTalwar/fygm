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

# Packages that can't be handled with Nix
brew install \
  swi-prolog \
  swiftformat \
  zplug

# macOS applications
brew cask install \
  beaker-browser \
  dash \
  docker \
  dropbox \
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
  sync \
  transmission \
  visual-studio \
  visual-studio-code \
  vlc \
  xquartz

brew cleanup
