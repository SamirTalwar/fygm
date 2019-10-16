{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    # Core
    pkgs.stdenv
    pkgs.coreutils
    pkgs.findutils
    pkgs.moreutils
    pkgs.curl
    pkgs.dos2unix
    pkgs.gawk
    pkgs.gnupg
    pkgs.gnused
    pkgs.hello
    pkgs.httpie
    pkgs.httping
    pkgs.jq
    pkgs.lastpass-cli
    pkgs.ncdu
    pkgs.socat
    pkgs.tree
    pkgs.wget

    # Shell
    pkgs.autojump
    pkgs.bash
    pkgs.direnv
    pkgs.entr
    pkgs.fswatch
    pkgs.fzf
    pkgs.mosh
    pkgs.silver-searcher
    pkgs.terminal-notifier
    pkgs.tmux
    pkgs.urlview
    pkgs.watch
    pkgs.zsh

    # Image Manipulation
    pkgs.imagemagick
    pkgs.pngcrush

    # Editors
    pkgs.aspell
    pkgs.neovim
    pkgs.pandoc

    # Development
    pkgs.cmake
    pkgs.gcc
    pkgs.git
    pkgs.gnumake
    pkgs.go
    pkgs.hugo
    pkgs.llvm
    pkgs.mercurial
    pkgs.nixpkgs-fmt
    pkgs.nodejs
    pkgs.ocaml
    pkgs.ocamlPackages.ocamlbuild
    pkgs.opam
    pkgs.pipenv
    pkgs.python
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.ruby
    pkgs.rustup
    pkgs.shellcheck
    pkgs.sqlite
    pkgs.yarn

    # Java Development
    pkgs.openjdk12
    pkgs.scala
    pkgs.sbt

    # Cloud Development
    pkgs.awscli
    pkgs.google-cloud-sdk
    pkgs.kubectl
  ];
}
