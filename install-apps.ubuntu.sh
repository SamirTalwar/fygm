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
  slurp
  sway
  swaybg
  swayidle
  swaylock
  xdg-desktop-portal-wlr

  # docker
  containerd.io
  docker-ce
  docker-ce-cli
  docker-compose-plugin
)

snap_applications=(
  vlc
)

snap_classic_applications=(
  code
)

now 'Setting up the Docker repository...'
mkdir -p /etc/apt/keyrings /etc/apt/sources.list.d
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list \
  > /dev/null
groupadd docker || :

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

now 'Setting up Sway + fixes...'
cp -fv ubuntu/sway/sway-plus-fixes /usr/local/bin/
chmod +x /usr/local/bin/sway-plus-fixes
cp -fv ubuntu/sway/sway-plus-fixes.desktop /usr/share/wayland-sessions/
