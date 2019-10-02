#!/usr/bin/env zsh

set -e
set -u
set -o pipefail
set -x

if [[ ! -d /nix ]]; then
  curl https://nixos.org/nix/install | sh
fi

nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
home-manager switch
