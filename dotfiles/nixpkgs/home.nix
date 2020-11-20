{ config, pkgs, ... }:
let
  nixGL = (import
    (pkgs.fetchFromGitHub {
      owner = "guibou";
      repo = "nixGL";
      rev = "fad15ba09de65fc58052df84b9f68fbc088e5e7c";
      sha256 = "1wc5gfj5ymgm4gxx5pz4lkqp5vxqdk2njlbnrc1kmailgzj6f75h";
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
    cachix
    niv
    nix-direnv
    nix-prefetch-github
    nix-prefetch-scripts

    # Core
    stdenv
    coreutils
    findutils
    moreutils
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
    go
    metals
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
      alacritty
      emacs
      glibcLocales
      nettools
      traceroute
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
    initExtra =
      ''source ~/.p10k.zsh
        source ~/.zshrc.fygm
        if [[ -e ~/.zshenv.local ]]; then
          source ~/.zshenv.local
        fi
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
