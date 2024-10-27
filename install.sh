#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

dir=${0:A:h}

source ${dir}/common.sh
source ${dir}/self-update.sh

${dir}/install.links.sh

now 'Installing Lix'
if [[ ! -e /nix/store ]]; then
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install
fi

# Only install "extra" configuration on non-NixOS machines.
if ! [[ $(uname -s) == 'Linux' && $(uname -v) =~ NixOS ]]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  if [[ ! -f /etc/nix/extra.conf ]] || ! diff /etc/nix/extra.conf ./nix/extra.conf; then
    sudo cp ./nix/extra.conf /etc/nix/extra.conf
    if ! grep '^include extra\.conf$' /etc/nix/nix.conf >/dev/null; then
      echo 'include extra.conf' | sudo tee -a /etc/nix/nix.conf
    fi
  fi
fi

now 'Updating Nix'
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

if [[ $(uname -s) == 'Darwin' ]]; then
  now 'Installing macOS-only software'
  ${dir}/install.mac.sh
  echo 'You may also want to run ./install-apps.mac.sh.'
fi

NEW_SHELL="${HOME}/.nix-profile/bin/nu"
if [[ $(uname -s) == 'Linux' && ! ( $(uname -v) =~ NixOS ) ]]; then
  now 'Configuring the user shell'
  CURRENT_SHELL=$(awk -F: -v user=$USER '$1 == user { print $NF }' /etc/passwd)
  if [[ $CURRENT_SHELL != $NEW_SHELL ]]; then
    sudo chsh -s $NEW_SHELL $USER
  fi
elif [[ $(uname -s) == 'Darwin' ]]; then
  now 'Configuring the user shell'
  CURRENT_SHELL=$(dscl . -read /Users/${USER} UserShell | cut -d ' ' -f 2)
  if [[ $CURRENT_SHELL != $NEW_SHELL ]]; then
    sudo chsh -s $NEW_SHELL $USER
  fi
fi

now 'Done!'
