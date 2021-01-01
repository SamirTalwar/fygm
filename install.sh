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

source ${HOME}/.nix-profile/etc/profile.d/nix.sh
nix upgrade-nix
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update

now 'Installing software with Nix'
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
if [[ $(uname -s) == 'Linux' ]]; then
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
mkdir -p $nvim_autoload
curl -fsSL -o $nvim_autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +PlugUpdate +PlugClean! +qall

now 'Installing tmux plugins'
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

now 'Done!'
