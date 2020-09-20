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
    bash
    curl
    dos2unix
    fd
    gawk
    gnugrep
    gnupg
    gnused
    hello
    htop
    httpie
    httping
    jq
    lastpass-cli
    ncdu
    netcat-gnu
    openssh
    ripgrep
    sd
    socat
    tree
    wget

    # Nix
    cachix
    niv
    nix-direnv

    # Shell
    autojump
    bash
    direnv
    entr
    fswatch
    fzf
    mosh
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

    # Development
    cmake
    gcc
    git
    gnumake
    go
    hugo
    lorri
    mercurial
    nixpkgs-fmt
    nodejs
    nodePackages.prettier
    openjdk11
    python3
    ruby
    shellcheck
    yarn
  ];

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = "source ~/.zshrc.fygm";
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.3";
          sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
        };
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
