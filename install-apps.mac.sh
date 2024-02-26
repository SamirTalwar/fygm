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

now 'Setting up a JetBrains Toolbox scripts directory'
echo 'You will need to update JetBrains Toolbox to create shell scripts at:'
echo '    /opt/jetbrains/bin'
sudo mkdir -p /opt/jetbrains/bin
sudo chown -R "${USER}:" /opt/jetbrains/bin
