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

  # A pretty color theme.
  tokyo-night = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "7da3176ad7119be9e1abeea80296abd0db3216fc";
    hash = "sha256-N0horUKT3HxoAlFMp05VLDYRcuvy7AEu9lGOHSQV7II=";
  };

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
    nix-direnv
    nix-prefetch-github
    nix-prefetch-scripts
    nix-tree
    npins

    # Core
    stdenv
    coreutils
    findutils
    moreutils
    fd
    gawk
    gnugrep
    gnupg
    gnused
    jq
    killall
    ripgrep
    sd
    tree
    yq
    zsh

    # System management
    bottom
    dua

    # Shell
    autojump
    direnv
    fzf
    watch
    watchexec
    zsh

    starship
    zoxide

    # Networking
    curl
    netcat-gnu
    openssh
    socat
    wget
    xh

    # Containers
    docker-compose
    docker-credential-gcr
    lazydocker

    # Editors
    aspell
    aspellDicts.en
    helix

    # Development
    bat
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
      discord
      firefox
      nautilus
      obsidian
      slack
      wezterm
    ]
  );

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      source ${nushell.src}/crates/nu-utils/src/sample_config/default_config.nu
      source ~/fygm/dotfiles/nushell/config.nu
    '';
    extraEnv = ''
      source ${nushell.src}/crates/nu-utils/src/sample_config/default_env.nu
      source ~/fygm/dotfiles/nushell/env.nu
    '';
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
