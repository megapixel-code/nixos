{
  config,
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages =
    (with pkgs; [
      git # needed for flakes
      home-manager

      # apps
      kitty
      neovim
      (yazi.override {
        _7zz = _7zz-rar; # support for RAR extraction
      })
      gimp3

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

      bat
      tree
      fastfetch
      htop-vim # interactive process viewer
      waybar
      swaybg
      wofi

      # languages
      cargo
      typst
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
