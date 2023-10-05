#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

source ${0:A:h}/common.sh

if ! [[ -e /opt/homebrew/bin/brew ]]; then
  now 'Installing Homebrew'
  git clone https://github.com/Homebrew/brew /opt/homebrew
fi

eval "$(/opt/homebrew/bin/brew shellenv)"

now 'Installing global Homebrew packages'
brew bundle install --no-lock --cleanup --file=./macos/global.Brewfile
