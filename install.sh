#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

dir=${0:A:h}

source ${dir}/common.sh
source ${dir}/self-update.sh

${dir}/install.links.sh

now 'Installing Nix'
NIX_DIR="$(readlink /nix || echo /nix)"
if [[ ! -e /nix/store ]]; then
  echo "Changing ownership of ${NIX_DIR} to ${USER}..."
  sudo chown "${USER}:" $NIX_DIR
  sh <(curl -L https://nixos.org/nix/install)
fi

if [[ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]]; then
  source ${HOME}/.nix-profile/etc/profile.d/nix.sh
fi
if [[ $(uname -s) == 'Linux' && $(uname -v) =~ NixOS ]]; then
  NIXOS_VERSION=$(nixos-version | sed -E 's/^([0-9]+\.[0-9]+).*/\1/')
  nix-channel --add "https://nixos.org/channels/nixos-${NIXOS_VERSION}" nixpkgs
  nix-channel --add "https://github.com/rycee/home-manager/archive/release-${NIXOS_VERSION}.tar.gz" home-manager
  nix-channel --update
else
  nix upgrade-nix
  nix-channel --add 'https://nixos.org/channels/nixpkgs-unstable' nixpkgs
  nix-channel --add 'https://github.com/rycee/home-manager/archive/master.tar.gz' home-manager
  nix-channel --update
fi

now 'Installing software with Nix'
export NIX_PATH="${HOME}/.nix-defexpr/channels${NIX_PATH:+:}${NIX_PATH}"
nix-env --upgrade
nix-shell '<home-manager>' -A install
home-manager switch

if [[ $(uname -s) == 'Linux' && $(uname -v) =~ Ubuntu ]]; then
  now 'Installing Ubuntu-only software'
  ${dir}/install-apps.ubuntu.sh
elif [[ $(uname -s) == 'Darwin' ]]; then
  now 'Installing macOS-only software'
  ${dir}/install-apps.mac.sh
fi

NEW_SHELL="${HOME}/.nix-profile/bin/zsh"
if [[ $(uname -s) == 'Linux' && ! ( $(uname -v) =~ NixOS ) ]]; then
  now 'Configuring the user shell'
  CURRENT_SHELL=$( awk -F: -v user=$USER '$1 == user { print $NF }' /etc/passwd)
  if [[ $CURRENT_SHELL != $NEW_SHELL ]]; then
    sudo chsh -s $NEW_SHELL $USER
  fi
elif [[ $(uname -s) == 'Darwin' ]]; then
  now 'Configuring the user shell'
  CURRENT_SHELL=$( dscl . -read /Users/${USER} UserShell | cut -d ' ' -f 2)
  if [[ $CURRENT_SHELL != $NEW_SHELL ]]; then
    sudo chsh -s $NEW_SHELL $USER
  fi
fi

now 'Installing vim plugins'
nvim_autoload=~/.config/nvim/autoload
curl -fLo $nvim_autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +PlugUpdate +PlugClean! +qall

now 'Installing tmux plugins'
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

now 'Done!'
