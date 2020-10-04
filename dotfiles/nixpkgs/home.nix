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
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    initExtra = "source ~/.zshrc.fygm";
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
  };
}
