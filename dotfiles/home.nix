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
  bemoji = pkgs.stdenv.mkDerivation {
    name = "bemoji";
    src = pkgs.fetchFromGitHub {
      owner = "marty-oehme";
      repo = "bemoji";
      "rev" = "7cec73e2dbdc7702d67116cc729f48f9248ceba0";
      "sha256" = "9gpz38OA2i6yuIxOEaeEcT9PNwA6f9QVqPUDzL9pt4Q=";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp ./bemoji $out/bin/
    '';
  };
  zsh-completions = pkgs.writeTextDir "share/zsh-completions/zsh-completions.zsh" ''
    fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
  '';
in
with pkgs;
{
  news.display = "silent";

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
    yq

    # Shell
    autojump
    bash
    direnv
    entr
    fswatch
    fzf
    tmux
    urlview
    watch
    zsh

    nushell
    starship
    zoxide

    # Networking
    curl
    httpie
    httping
    netcat-gnu
    openssh
    socat
    wget

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
      iosevka

      # Sway tools.
      bemoji
      mako
      shotman
      waybar
      wlogout
      wofi

      # Programs.
      alacritty
      firefox
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
      ''source ~/.zshrc.fygm
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

  targets.genericLinux.enable = stdenv.isLinux;

  xdg.enable = stdenv.isLinux;
  xdg.mime.enable = stdenv.isLinux;
}
