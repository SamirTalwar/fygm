{ config, pkgs, ... }:

with pkgs;
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  news.display = "silent";

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
    nixpkgs-fmt
    nodejs
    nodePackages.prettier
    openjdk11
    python3
    ruby
    shellcheck
    yarn
  ] ++ (
    if stdenv.isDarwin
    then [
      terminal-notifier
    ]
    else [
      xclip
    ]
  );

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
          rev = "v0.6.4";
          sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
  };
}
