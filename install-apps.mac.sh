#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

fonts=(
  font-iosevka
)

brew_cli_programs=(
  mas
  reattach-to-user-namespace
)

brew_mac_applications=(
  alacritty
  dash
  discord
  docker
  dropbox
  emacs-mac-spacemacs-icon
  firefox
  google-chrome
  nordvpn
  notion
  signal
  sync
  visual-studio-code
  vlc
)

mac_app_store_applications=(
  485812721 # TweetDeck
  585829637 # Todoist
  692867256 # Simplenote
  926036361 # LastPass
)

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

function brew_cask_install {
  to_install=()
  for app in $@; do
    if [[ ${installed_casks[(ie)$app]} -gt ${#installed_casks} ]]; then
      to_install+=(homebrew/cask/$app)
    fi
  done
  if [[ ${#to_install} -gt 0 ]]; then
    brew install $to_install
  fi
}

now 'Installing new Homebrew packages'
brew install $brew_cli_programs
brew_cask_install $fonts $brew_mac_applications

now 'Installing Mac App Store applications'
reattach-to-user-namespace mas install $mac_app_store_applications

now 'Cleaning up'
brew cleanup
