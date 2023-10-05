#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

source ${0:A:h}/common.sh

if ! [[ -e ~/.homebrew/bin/brew ]] || ! command -v brew >& /dev/null; then
  now 'Installing Homebrew'
  git clone https://github.com/Homebrew/brew ~/.homebrew
fi

eval "$(~/.homebrew/bin/brew shellenv)"

now 'Installing local Homebrew packages'
brew bundle install --no-lock --cleanup --file=./macos/local.Brewfile
