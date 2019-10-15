#!/usr/bin/env zsh

set -e
set -u

source ./self-update.sh

dir=${0:h:A}
dotfiles=$dir/dotfiles

set -A links
links=(
  ~/bin $dir/bin
  ~/.emacs.d $dotfiles/emacs.d
  ~/.ghc/ghci.conf $dotfiles/ghc/ghci.conf
  ~/.gitconfig $dotfiles/gitconfig
  ~/.gitignore $dotfiles/gitignore
  ~/.i3 $dotfiles/i3
  ~/.ideavimrc $dotfiles/ideavimrc
  ~/.config/nixpkgs/home.nix $dotfiles/nixpkgs/home.nix
  ~/.config/nvim/init.vim $dotfiles/vimrc
  ~/.racketrc $dotfiles/racketrc
  ~/.stack/config.yaml $dotfiles/stack/config.yaml
  ~/.spacemacs $dotfiles/spacemacs
  ~/.swiplrc $dotfiles/swiplrc
  ~/.tmux.conf $dotfiles/tmux.conf
  ~/.vimrc $dotfiles/vimrc
  ~/.zlogin $dotfiles/zlogin
  ~/.zlogout $dotfiles/zlogout
  ~/.zplug $dotfiles/zplug
  ~/.zprofile $dotfiles/zprofile
  ~/.zshenv $dotfiles/zshenv
  ~/.zshrc $dotfiles/zshrc
)

echo >&2 'Symlinking files...'
for dest src in $links; do
  if [[ -e $dest ]]; then
    if [[ $(readlink $dest) != $src ]]; then
      echo >&2 "\"$dest\" already exists."
      exit 1
    fi
  else
    echo ln -s $src $dest
  fi
done

echo >&2
echo >&2 'Installing useful software...'
./set-up-nix.sh
if [[ $(uname -s) == 'Darwin' ]]; then
  ./install-apps.mac.sh
fi

echo >&2
echo >&2 'Installing vim plugins...'
nvim_autoload=~/.config/nvim/autoload
mkdir -p $nvim_autoload
curl -fsSL -o $nvim_autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +PlugUpdate +PlugClean! +qall

echo >&2
echo >&2 'Done!'
