#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

source ${0:A:h}/common.sh

# Re-run this script using `sudo` if we're not root.
if [[ "$EUID" -ne 0 ]]; then
  exec sudo $0 $@
fi


apt_fonts=(
  fonts-firacode
)

apt_programs=(
  arandr
  i3
)

apt_applications=(
  firefox
  google-chrome-stable
)

snap_applications=(
)

snap_classic_applications=(
)

now 'Setting up third-party Apt repositories...'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
if [[ ! -f /etc/apt/sources.list.d/google.list && ! -f /etc/apt/sources.list.d/google-chrome.list ]]; then
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
fi

now 'Upgrading packages...'
apt-get update
apt-get dist-upgrade --yes
apt-get autoremove --purge --yes
now 'Installing fonts and programs with Apt...'
apt-get install --yes $apt_fonts $apt_programs $apt_applications

# now 'Installing applications with Snap...'
# snap install $snap_applications
# snap install --classic $snap_classic_applications
