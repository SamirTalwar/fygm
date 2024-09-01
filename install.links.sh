#!/usr/bin/env zsh

set -e
set -u
set -o pipefail

force=false
symlink=(ln -s)
if [[ ${1:-} == '--force' ]]; then
  force=true
  symlink+=(-f)
  shift
fi

dir=${0:A:h}
dotfiles=${dir}/dotfiles
macos_application_support="${HOME}/Library/Application Support"

source ${dir}/common.sh

set -A links
links=(
  ~/fygm $dir
  ~/bin $dir/bin
  ~/.config/home-manager/home.nix $dotfiles/home.nix
  ~/.config/mako $dotfiles/mako
  ~/.config/helix $dotfiles/helix
  ~/.config/nvim/init.lua $dotfiles/nvim/init.lua
  ~/.config/starship.toml $dotfiles/starship.toml
  ~/.config/sway/config $dotfiles/sway/config
  ~/.config/swaylock/config $dotfiles/swaylock/config
  ~/.config/wezterm $dotfiles/wezterm
  ~/.config/wofi $dotfiles/wofi
  ~/.ghc/ghci.conf $dotfiles/ghc/ghci.conf
  ~/.gitconfig $dotfiles/gitconfig
  ~/.gitignore $dotfiles/gitignore
  ~/.ideavimrc $dotfiles/ideavimrc
  ~/.racketrc $dotfiles/racketrc
  ~/.stack/config.yaml $dotfiles/stack/config.yaml
)

case $(uname -s) in
  'Linux')
    links+=(
      ~/.config/Code/User/settings.json $dotfiles/code/settings.json
      ~/.config/fontconfig/fonts.conf $dotfiles/fonts.conf
    )
    ;;
  'Darwin')
    links+=(
      $macos_application_support/Code/User/settings.json $dotfiles/code/settings.json
    )
    ;;
esac

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
