#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

force=false
symlink=(ln -s)
if [[ ${1:-} == '--force' ]]; then
  force=true
  symlink+=(-f)
fi

dir=${0:A:h}
dotfiles=${dir}/dotfiles
macos_application_support="${HOME}/Library/Application Support"

source ${dir}/common.sh

set -A links
links=(
  ~/bin $dir/bin
  ~/.config/alacritty/alacritty.yml $dotfiles/alacritty.yml
  ~/.config/nix/nix.conf $dotfiles/nix.conf
  ~/.config/nixpkgs $dotfiles/nixpkgs
  ~/.config/nvim/coc-settings.json $dotfiles/nvim/coc-settings.json
  ~/.config/nvim/init.vim $dotfiles/nvim/init.vim
  ~/.config/starship.toml $dotfiles/starship.toml
  ~/.config/swaync $dotfiles/swaync
  ~/.config/sway/config $dotfiles/sway/config
  ~/.config/wofi $dotfiles/wofi
  ~/.ghc/ghci.conf $dotfiles/ghc/ghci.conf
  ~/.gitconfig $dotfiles/gitconfig
  ~/.gitignore $dotfiles/gitignore
  ~/.ideavimrc $dotfiles/ideavimrc
  ~/.racketrc $dotfiles/racketrc
  ~/.stack/config.yaml $dotfiles/stack/config.yaml
  ~/.tmux.conf $dotfiles/tmux.conf
  ~/.zshenv.fygm $dotfiles/zshenv
  ~/.zshrc.fygm $dotfiles/zshrc
)

if [[ $(uname -s) == 'Linux' ]]; then
  links+=(
    ~/.config/Code/User/settings.json $dotfiles/code/settings.json
    ~/.config/fontconfig/fonts.conf $dotfiles/fonts.conf
    ~/.config/i3 $dotfiles/i3
    ~/.config/i3status $dotfiles/i3status
  )
fi

if [[ $(uname -s) == 'Darwin' ]]; then
  links+=(
    $macos_application_support/Code/User/settings.json $dotfiles/code/settings.json
  )
fi

now 'Symlinking files'
for dest src in $links; do
  if [[ -e $dest ]]; then
    if $force; then
      echo >&2 "\"$dest\" already exists. Overwriting it."
      echo >&2 $dest '->' $src
      mkdir -p ${dest:h}
      $symlink $src $dest
    elif [[ $(readlink $dest) != $src ]]; then
      echo >&2 "\"$dest\" already exists."
      exit 1
    fi
  else
    echo >&2 $dest '->' $src
    mkdir -p ${dest:h}
    $symlink $src $dest
  fi
done
