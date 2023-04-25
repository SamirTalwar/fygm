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
  ~/.config/home-manager/home.nix $dotfiles/home.nix
  ~/.config/mako $dotfiles/mako
  ~/.config/nix/nix.conf $dotfiles/nix.conf
  ~/.config/nvim/init.lua $dotfiles/nvim/init.lua
  ~/.config/starship.toml $dotfiles/starship.toml
  ~/.config/sway/config $dotfiles/sway/config
  ~/.config/swaylock/config $dotfiles/swaylock/config
  ~/.config/wofi $dotfiles/wofi
  ~/.ghc/ghci.conf $dotfiles/ghc/ghci.conf
  ~/.gitconfig $dotfiles/gitconfig
  ~/.gitignore $dotfiles/gitignore
  ~/.racketrc $dotfiles/racketrc
  ~/.stack/config.yaml $dotfiles/stack/config.yaml
  ~/.tmux.conf $dotfiles/tmux.conf
  ~/.zshenv.fygm $dotfiles/zshenv
  ~/.zshrc.fygm $dotfiles/zshrc
)

case $(uname -s) in
  'Linux')
    links+=(
      ~/.config/Code/User/settings.json $dotfiles/code/settings.json
      ~/.config/fontconfig/fonts.conf $dotfiles/fonts.conf
      ~/.config/i3 $dotfiles/i3
      ~/.config/i3status $dotfiles/i3status
      ~/.config/nushell/config.nu $dotfiles/nushell/config.nu
      ~/.config/nushell/env.nu $dotfiles/nushell/env.nu
    )
    ;;
  'Darwin')
    links+=(
      $macos_application_support/Code/User/settings.json $dotfiles/code/settings.json
      $macos_application_support/nushell/config.nu $dotfiles/nushell/config.nu
      $macos_application_support/nushell/env.nu $dotfiles/nushell/env.nu
      ~/.gnupg/gpg-agent.conf $dotfiles/macos/gpg-agent.conf
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
