#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

dir=${0:A:h}
dotfiles=${dir}/dotfiles
macos_application_support="${HOME}/Library/Application Support"

set -A links
links=(
  ~/bin $dir/bin
  ~/.emacs.d $dotfiles/emacs.d
  ~/.ghc/ghci.conf $dotfiles/ghc/ghci.conf
  ~/.gitconfig $dotfiles/gitconfig
  ~/.gitignore $dotfiles/gitignore
  ~/.i3 $dotfiles/i3
  ~/.ideavimrc $dotfiles/ideavimrc
  ~/.config/alacritty/alacritty.yml $dotfiles/alacritty.yml
  ~/.config/nixpkgs/home.nix $dotfiles/nixpkgs/home.nix
  ~/.config/nvim/coc-settings.json $dotfiles/coc-settings.json
  ~/.config/nvim/init.vim $dotfiles/vimrc
  ~/.p10k.zsh $dotfiles/p10k.zsh
  ~/.powerlevel10k $dotfiles/powerlevel10k
  ~/.racketrc $dotfiles/racketrc
  ~/.stack/config.yaml $dotfiles/stack/config.yaml
  ~/.spacemacs $dotfiles/spacemacs
  ~/.tmux.conf $dotfiles/tmux.conf
  ~/.vimrc $dotfiles/vimrc
  ~/.zshenv $dotfiles/zshenv
  ~/.zshrc.fygm $dotfiles/zshrc
)

if [[ $(uname -s) == 'Darwin' ]]; then
  links+=(
    $macos_application_support/Code/User/settings.json $dotfiles/code/settings.json
  )
fi

function now {
  echo >&2
  echo >&2 '===' $@ '==='
}

source ${dir}/self-update.sh

now 'Symlinking files'
for dest src in $links; do
  if [[ -e $dest ]]; then
    if [[ $(readlink $dest) != $src ]]; then
      echo >&2 "\"$dest\" already exists."
      exit 1
    fi
  else
    echo $dest '->' $src
    mkdir -p ${dest:h}
    ln -s $src $dest
  fi
done

now 'Installing Nix'
NIX_DIR="$(readlink /nix || echo /nix)"
if [[ ! -e /nix/store ]]; then
  echo "Changing ownership of ${NIX_DIR} to ${USER}..."
  sudo chown -R "${USER}:" $NIX_DIR
  sh <(curl https://nixos.org/nix/install)
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

if [[ $(uname -s) == 'Darwin' ]]; then
  now 'Installing macOS-only software'
  ./install-apps.mac.sh

  now 'Configuring the user shell'
  CURRENT_SHELL=$(
    dscl . -read /Users/${USER} UserShell \
      | cut -d ' ' -f 2
  )
  if [[ $CURRENT_SHELL != ${HOME}/.nix-profile/bin/zsh ]]; then
    sudo chsh -s ${HOME}/.nix-profile/bin/zsh $USER
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
