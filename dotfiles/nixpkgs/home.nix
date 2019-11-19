{ config, pkgs, ... }:

with pkgs;
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    # Core
    stdenv
    coreutils
    findutils
    moreutils
    curl
    dos2unix
    gawk
    gnupg
    gnused
    hello
    httpie
    httping
    jq
    lastpass-cli
    ncdu
    socat
    tree
    wget

    # Shell
    autojump
    bash
    direnv
    entr
    fswatch
    fzf
    mosh
    silver-searcher
    terminal-notifier
    tmux
    urlview
    watch
    zsh

    # Image Manipulation
    imagemagick
    pngcrush

    # Editors
    aspell
    aspellDicts.en
    neovim
    pandoc

    # Development
    cmake
    gcc
    git
    gnumake
    go
    hugo
    llvm
    mercurial
    nixpkgs-fmt
    nodejs
    ocaml
    ocamlPackages.ocamlbuild
    opam
    pipenv
    python
    python3
    python3Packages.pip
    ruby
    rustup
    shellcheck
    sqlite
    yarn

    # Java Development
    openjdk12
    scala
    sbt

    # Cloud Development
    awscli
  ];

  programs.zsh = {
    enable = true;
    initExtra = "source ~/.zshrc.fygm";
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "e7d3fbc50b0209cb9f9b0812fd40298be03c7808";
          sha256 = "14sfbnl8iw1l1ixzg8al190hcxyakgb1sf8qqd64n7adrq8vfiv6";
        };
      }
    ];
  };
}
