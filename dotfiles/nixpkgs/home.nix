{ config, pkgs, ... }:
let
  nixGL = (import
    (pkgs.fetchFromGitHub {
      owner = "guibou";
      repo = "nixGL";
      rev = "3ab1aae698dc45d11cc2699dd4e36de9cdc5aa4c";
      sha256 = "192k02fd2s3mfpkdwjghiggcn0ighwvmw0fqrzf0vax52v6l9nch";
      fetchSubmodules = true;
    })
    { }).nixGLDefault;
  alacritty = pkgs.writeScriptBin "alacritty" ''
    #!${pkgs.stdenv.shell}
    exec ${nixGL}/bin/nixGL ${pkgs.alacritty}/bin/alacritty
  '';
in
with pkgs;
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  news.display = "silent";

  home.packages = [
    # Nix
    niv
    nix-direnv
    nix-prefetch-github
    nix-prefetch-scripts

    # Core
    stdenv
    coreutils
    findutils
    moreutils
    bat
    dos2unix
    fd
    gawk
    gnugrep
    gnupg
    gnused
    hello
    htop
    jq
    ncdu
    ripgrep
    sd
    tree

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

    # Networking
    curl
    httpie
    httping
    netcat-gnu
    openssh
    socat
    wget

    # Security
    lastpass-cli

    # Image Manipulation
    imagemagick
    pngcrush

    # Editors
    aspell
    aspellDicts.en
    neovim

    # Development
    agda
    gcc
    git
    gnumake
    nixpkgs-fmt
    nodejs
    nodePackages.prettier
    python3
    ruby
    shellcheck
    subversion
  ] ++ (
    if stdenv.isDarwin
    then [
      terminal-notifier
    ]
    else [
      glibcLocales

      # On macOS, we use `pbcopy` and `pbpaste`.
      xclip

      # Network tools. On macOS, we use the built-in tools.
      nettools
      traceroute

      # Installed by Homebrew on macOS.
      alacritty
      emacs

      # Fonts.
      iosevka
    ]
  );

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    initExtra =
      ''source ~/.p10k.zsh
        source ~/.zshrc.fygm
      '';
    plugins = [
      {
        name = "autojump";
        src = autojump;
        file = "share/autojump/autojump.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
  };
}
