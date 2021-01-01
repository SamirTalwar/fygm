#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

source ${0:A:h}/common.sh

if ! command -v brew >& /dev/null; then
  now 'Installing Homebrew'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

now 'Tapping'
brew tap homebrew/cask-fonts
brew tap railwaycat/emacsmacport

now 'Upgrading Homebrew packages'
brew update
brew upgrade

installed_casks=($(brew list --cask))

fonts=(
  font-fira-code
  font-source-code-pro
)

applications=(
  alacritty
  dash
  discord
  docker
  dropbox
  emacs-mac-spacemacs-icon
  firefox
  google-chrome
  gpg-suite
  nordvpn
  simplenote
  sync
  visual-studio-code
  vlc
)

function cask_install {
  to_install=()
  for app in $@; do
    if [[ ${installed_casks[(ie)$app]} -gt ${#installed_casks} ]]; then
      to_install+=($app)
    fi
  done
  if [[ ${#to_install} -gt 0 ]]; then
    brew install $to_install
  fi
}

now 'Installing new packages'
cask_install $fonts $applications

now 'Cleaning up'
brew cleanup
