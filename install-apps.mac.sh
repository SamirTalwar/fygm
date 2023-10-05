#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

brew_cli_programs=(
  mas
  reattach-to-user-namespace
)

brew_mac_applications=(
  alacritty
  dash
  discord
  docker
  firefox
  google-chrome
  notion
  signal
  scroll-reverser
  syncthing
  visual-studio-code
  vlc
)

mac_app_store_applications=(
  585829637 # Todoist
  803453959 # Slack
)

source ${0:A:h}/common.sh

if ! [[ -e /opt/homebrew/bin/brew ]]; then
  now 'Installing Homebrew'
  git clone https://github.com/Homebrew/brew /opt/homebrew
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

now 'Upgrading Homebrew packages'
brew update
brew upgrade

now 'Installing new Homebrew packages'
brew install $brew_cli_programs
brew install --cask $brew_mac_applications

now 'Installing Mac App Store applications'
reattach-to-user-namespace mas install $mac_app_store_applications

now 'Cleaning up'
brew cleanup
