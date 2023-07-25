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
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

if [[ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]]; then
  source ${HOME}/.nix-profile/etc/profile.d/nix.sh
fi
if [[ $(uname -s) == 'Linux' && $(uname -v) =~ NixOS ]]; then
  sudo nix-channel --add 'https://nixos.org/channels/nixos-unstable' nixos
  nix-channel --add 'https://nixos.org/channels/nixos-unstable' nixpkgs
  nix-channel --add 'https://github.com/rycee/home-manager/archive/master.tar.gz' home-manager
  nix-channel --update
else
  nix-channel --add 'https://nixos.org/channels/nixpkgs-unstable' nixpkgs
  nix-channel --add 'https://github.com/rycee/home-manager/archive/master.tar.gz' home-manager
  nix-channel --update
fi

now 'Installing software with Nix'
if command -v nixos-rebuild >/dev/null; then
  sudo nix-channel --update
  sudo nixos-rebuild switch
fi
export NIX_PATH="${HOME}/.nix-defexpr/channels${NIX_PATH:+:}${NIX_PATH:-}"
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

now 'Installing tmux plugins'
if [[ ! -e "${HOME}/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
fi

now 'Done!'
