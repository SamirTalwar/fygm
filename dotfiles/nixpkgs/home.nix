{ config
, pkgs
, ...
}:
let
  nixgl = import <nixgl> { };
  alacritty = pkgs.stdenv.mkDerivation {
    name = pkgs.alacritty.name;
    version = pkgs.alacritty.version;
    src = pkgs.alacritty.src;
    buildInputs = [ pkgs.alacritty ];
    buildPhase = "true";
    installPhase = ''
      cp -R --no-preserve=mode ${pkgs.alacritty} $out
      rm $out/bin/alacritty
      (
        echo '#!${pkgs.stdenv.shell}'
        echo 'exec ${nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.alacritty}/bin/alacritty "$@"'
      ) > $out/bin/alacritty
      chmod +x $out/bin/alacritty
    '';
  };
in
with pkgs;
{
  news.display = "silent";

  home.stateVersion = "18.09";

  home.packages = [
    # Nix
    niv
    nix
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
    difftastic # git diffs
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
      swaynotificationcenter
      waybar
      wofi

      # Programs.
      alacritty
      emacsPgtk
      firefox-devedition-bin
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

  targets.genericLinux.enable = stdenv.isLinux;

  xdg.enable = stdenv.isLinux;
  xdg.mime.enable = stdenv.isLinux;
}
