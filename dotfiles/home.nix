{ config
, pkgs
, ...
}:
with pkgs;
let
  # Bemoji isn't in nixpkgs yet.
  bemoji = pkgs.stdenv.mkDerivation {
    name = "bemoji";
    src = pkgs.fetchFromGitHub {
      owner = "marty-oehme";
      repo = "bemoji";
      rev = "6c037a5771373d35549c3b80d19792bf72627f6a";
      hash = "sha256-AzxbtjtZ84D4zVzxHWZt6YWvBVg97CQUnOD6ZjAgonw=";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp ./bemoji $out/bin/
    '';
  };

  # fall back to a supported TERM on macOS.
  tmux =
    if stdenv.isDarwin
    then
      pkgs.tmux.overrideAttrs
        (oldAttrs: {
          configureFlags = oldAttrs.configureFlags ++ [ "--with-TERM=screen-256color" ];
        })
    else
      pkgs.tmux;

  # A pretty color theme.
  tokyo-night = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "7da3176ad7119be9e1abeea80296abd0db3216fc";
    hash = "sha256-N0horUKT3HxoAlFMp05VLDYRcuvy7AEu9lGOHSQV7II=";
  };

  # Install completions from zsh-completions.
  zsh-completions = pkgs.writeTextDir "share/zsh-completions/zsh-completions.zsh" ''
    fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
  '';

  # empty package, for shenanigans
  empty = builtins.derivation {
    name = "empty";
    system = builtins.currentSystem;
    builder = pkgs.writeShellScript "null.sh" "${pkgs.coreutils}/bin/mkdir $out";
  };
in
{
  news.display = "silent";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "obsidian"
    "slack"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # Sadly, this is required for Obsidian.
    "electron-25.9.0"
  ];

  home.stateVersion = "22.11";

  # I don't want to hard-code these; this should work across machines.
  home.homeDirectory = builtins.getEnv "HOME";
  home.username = builtins.getEnv "USER";

  home.packages = [
    # Nix
    cachix
    nix
    nix-direnv
    nix-prefetch-github
    nix-prefetch-scripts
    nix-tree

    # Core
    stdenv
    coreutils
    findutils
    moreutils
    bat
    bottom
    fd
    gawk
    gnugrep
    gnupg
    gnused
    jq
    killall
    ncdu
    ripgrep
    sd
    tree
    yq

    # Shell
    autojump
    bash
    direnv
    fzf
    tmux
    watch
    watchexec
    zsh

    nushell
    starship
    zoxide

    # Networking
    curl
    httpie
    netcat-gnu
    openssh
    socat
    wget

    # Containers
    docker-compose
    docker-credential-gcr

    # Editors
    aspell
    aspellDicts.en

    # Development
    difftastic # git diffs
    git
    git-lfs
    gnumake
    nixpkgs-fmt
    nodePackages.prettier
    python3
    shellcheck
  ] ++ (
    if stdenv.isDarwin
    then [
      terminal-notifier
    ]
    else [
      # Basics.
      gcc
      glibcLocales

      # On macOS, we use `pbcopy` and `pbpaste`.
      wl-clipboard
      wtype

      # Network tools. On macOS, we use the built-in tools.
      nettools
      traceroute

      # Fonts.
      font-awesome
      iosevka-bin
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

      # Sway tools.
      bemoji
      mako
      shotman
      waybar
      wlogout
      wofi

      # Programs.
      alacritty
      discord
      firefox
      gnome.nautilus
      obsidian
      slack
    ]
  );

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    package =
      if stdenv.isDarwin
      then
        builtins.derivation
          {
            name = "alacritty";
            version = "0.13"; # required to use a TOML configuration file
            system = builtins.currentSystem;
            builder = pkgs.writeShellScript "null.sh" "${pkgs.coreutils}/bin/mkdir $out";
          }
      else alacritty;
    settings = {
      import = [
        "${tokyo-night}/extras/alacritty/tokyonight_night.toml"
        "~/.config/alacritty/custom.toml"
      ];
    };
  };

  programs.bash = {
    enable = true;
  };

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    envExtra = ''
      source ~/.zshenv.fygm
    '';
    initExtra = ''
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
        name = "zsh-completions";
        src = zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
  };

  services.syncthing = {
    enable = stdenv.isLinux;
    tray.enable = stdenv.isLinux;
  };

  fonts.fontconfig.enable = stdenv.isLinux;

  targets.genericLinux.enable = stdenv.isLinux;

  xdg.enable = stdenv.isLinux;
  xdg.mime.enable = stdenv.isLinux;
}
