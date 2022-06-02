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
  zeal

  # window management
  sway
  swaybg
  swayidle
  swaylock
  waybar
  wofi

  # docker
  containerd.io
  docker-ce
  docker-ce-cli
)

snap_applications=(
  vlc
)

snap_classic_applications=(
  code
)

now 'Setting up third-party Apt repositories...'
# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository --no-update "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

now 'Upgrading packages...'
apt-get update
apt-get dist-upgrade --yes
apt-get autoremove --purge --yes

now 'Installing fonts and programs with Apt...'
apt-get install --yes $apt_fonts $apt_programs

now 'Installing applications with Snap...'
for app in $snap_applications; do
  snap install $app
done
for app in $snap_classic_applications; do
  snap install --classic $app
done
