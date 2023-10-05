#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

brew_fonts=(
  font-iosevka
  font-symbols-only-nerd-font
)

source ${0:A:h}/common.sh

if ! [[ -e ~/.homebrew/bin/brew ]] || ! command -v brew >& /dev/null; then
  now 'Installing Homebrew'
  git clone https://github.com/Homebrew/brew ~/.homebrew
fi

eval "$(~/.homebrew/bin/brew shellenv)"

now 'Tapping'
brew tap homebrew/cask-fonts

now 'Upgrading Homebrew packages'
brew update
brew upgrade

now 'Installing new Homebrew packages'
brew install --cask $brew_fonts

now 'Cleaning up'
brew cleanup
