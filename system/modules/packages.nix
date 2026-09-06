{
  config,
  user,
  lib,
  pkgs,
  pkgs-unstable,
  my_lib,
  ...
}:
let
  stablePackages =
    with pkgs;
    [
      # always on
      (my_lib.makeWrapper {
        package = pkgs.bash;
        package_exec = "bash";
        extra_flags = "--init-file $XDG_CONFIG_HOME/bash/bashrc";
      })
      blesh
      gitstatus
      git
      tmux
      skim # command line fuzy finder
      home-manager
    ]
    ++ [
      # languages
      cargo
      typst
      lua
      fpc # free pascal
      python3
      scala
    ]
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-mango.enable [
      mango
      eww
      sunsetr
      brightnessctl
      slurp # select region in wayland
      grim # screenshoot tool
      imagemagick # image manipulation tool (used for color picker)
      pscircle # proccess viewer image generator
      awww # bg daemon
      wofi # app launcher
      swaynotificationcenter # notification deamon
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.networking.personal.enable [
      impala # Network TUI control
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.module-bluetooth.enable [
      bluetui # Bluetooth TUI control
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.apps.enable [
      kitty
      deezer-desktop
      obs-studio
      libreoffice
      vlc # audio video reader
      vimiv-qt # image viewer
      zathura # pdf reader
      comaps # maps
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.editors.enable [
      inkscape # pdf/svg editor
      gimp3
      kdePackages.kdenlive # video editor
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.games.enable [
      (my_lib.makeWrapper {
        package = pkgs.steam;
        package_exec = "steam";
        script = ''
          HOME="$XDG_DATA_HOME/Steam"
          mkdir -p $HOME
        '';
      })
      prismlauncher # minecraft
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.utilities.system.enable [
      man-pages
      man-pages-posix
      glibcInfo
      busybox # bunch of unix utilities
      gnutls # TODO: check if keep
      gnumake
      cmake
      gcc
      tinycc
      curl
      nh
      sops
      age # simple encryption
      bear # used to create compilation db for clang

      ntfs3g # read/fix ntfs file systems

      fzf
      pdfgrep

      wl-clipboard
      inotify-tools
      ffmpeg
    ])
    ++ (lib.lists.optionals config.home-manager.users.${user}.my.pkgs.utilities.user.enable [
      ncpamixer # audio TUI control
      tree
      fastfetch
      cbonsai
      lavat
      htop-vim # interactive process viewer
      pass-wayland # password manager
    ]);

  unstablePackages = with pkgs-unstable; [
    # always on
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = stablePackages ++ unstablePackages;

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
  ];
}
