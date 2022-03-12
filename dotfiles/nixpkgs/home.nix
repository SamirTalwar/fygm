{ config
, pkgs
, ...
}:
let
  nixgl = import <nixgl> { };
  alacritty = pkgs.writeScriptBin "alacritty" ''
    #!${pkgs.stdenv.shell}
    exec ${nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.alacritty}/bin/alacritty "$@"
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
    delta
    gcc
    git
    git-lfs
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
      # On Linux, we alias those commands to one of the below.
      wl-clipboard
      xclip

      # Network tools. On macOS, we use the built-in tools.
      nettools
      traceroute

      # Fonts.
      font-awesome
      iosevka

      # Sway tools.
      swaybg
      swayidle
      swaylock
      waybar
      wofi

      # Programs.
      alacritty
      emacsPgtk
      firefox
      gnome.nautilus
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
    enableCompletion = false;
    envExtra =
      ''source ~/.zshenv.fygm
      '';
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
