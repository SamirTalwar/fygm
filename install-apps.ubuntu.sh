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
  # applications
  firefox
  google-chrome-stable
  zeal

  # window management
  arandr
  i3

  # docker
  containerd.io
  docker-ce
  docker-ce-cli
)

snap_applications=(
  vlc
)

snap_classic_applications=(
)

now 'Setting up third-party Apt repositories...'
# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository --no-update "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Google Chrome
curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
add-apt-repository --no-update "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"

now 'Upgrading packages...'
apt-get update
apt-get dist-upgrade --yes
apt-get autoremove --purge --yes

now 'Installing fonts and programs with Apt...'
apt-get install --yes $apt_fonts $apt_programs

now 'Installing applications with Snap...'
snap install $snap_applications
# snap install --classic $snap_classic_applications
