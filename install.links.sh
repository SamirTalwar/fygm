#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

dir=${0:A:h}
dotfiles=${dir}/dotfiles
macos_application_support="${HOME}/Library/Application Support"

source ${dir}/common.sh

set -A links
links=(
  ~/bin $dir/bin
  ~/.config/alacritty/alacritty.yml $dotfiles/alacritty.yml
  ~/.config/i3 $dotfiles/i3
  ~/.config/i3status $dotfiles/i3status
  ~/.config/nix/nix.conf $dotfiles/nix.conf
  ~/.config/nixpkgs/home.nix $dotfiles/nixpkgs/home.nix
  ~/.config/nvim/coc-settings.json $dotfiles/coc-settings.json
  ~/.config/nvim/init.vim $dotfiles/vimrc
  ~/.emacs.d $dotfiles/emacs.d
  ~/.ghc/ghci.conf $dotfiles/ghc/ghci.conf
  ~/.gitconfig $dotfiles/gitconfig
  ~/.gitignore $dotfiles/gitignore
  ~/.ideavimrc $dotfiles/ideavimrc
  ~/.p10k.zsh $dotfiles/p10k.zsh
  ~/.racketrc $dotfiles/racketrc
  ~/.spacemacs $dotfiles/spacemacs
  ~/.stack/config.yaml $dotfiles/stack/config.yaml
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
