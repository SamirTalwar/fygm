#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

source ${0:A:h}/common.sh

if ! [[ -e ~/.homebrew/bin/brew ]]; then
  now 'Installing Homebrew'
  git clone https://github.com/Homebrew/brew ~/.homebrew
fi

eval "$(~/.homebrew/bin/brew shellenv)"

now 'Installing local Homebrew packages'
brew bundle install --no-lock --cleanup --file=./macos/local.Brewfile

now 'Setting up pinentry'
echo "pinentry-program ${HOME}/.homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
