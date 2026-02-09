{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./programs/gnupg-agent.nix
  ];

  nixpkgs.config.allowUnfree = true; # required for yazi 7zz

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages =
    (with pkgs; [
      git # needed for flakes
      home-manager

      # apps
      kitty
      tmux
      inkscape # pdf / svg
      gimp3
      davinci-resolve
      obs-studio
      bluetui # Bluetooth TUI control
      impala # Network TUI control
      libreoffice
      vlc

      # utilities
      stow
      gnumake # make
      cmake
      curl
      unzip
      gzip
      gnutar # tar
      gcc
      wl-clipboard
      fzf
      ripgrep
      wget
      pass-wayland # password manager
      # git-crypt # manage secrets                                               TODO: later
      # lynx # see html in terminal; dependency of neomutt maybe not needed
      grim # screenshoot tool
      slurp # select region in wayland
      imagemagick # image manipulation tool
      pdfgrep # grep inside pdfs
      fd # find rewrite, directory searching
      skim # command line fuzy finder
      wlr-randr # manage outputs in wayland
      ntfs3g # read/fix ntfs file systems
      brightnessctl # read and control brightness
      ncpamixer # audio TUI control
      ffmpeg

      bat
      tree
      fastfetch
      cbonsai
      htop-vim # interactive process viewer
      pscircle # proccess viewer image generator
      waybar
      swww # bg daemon: TODO: change later to awww when pkg will be available
      rofi # app launcher
      inotify-tools
      swaynotificationcenter # notification deamon

      # games
      prismlauncher # minecraft

      # languages
      cargo
      typst
      lua
      scala
      fpc # free pascal
    ])
    ++ (with pkgs-unstable; [
      deezer-enhanced
      sunsetr
      mangowc
    ]);

  fonts.packages = with pkgs; [
    nerd-fonts.blex-mono
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
