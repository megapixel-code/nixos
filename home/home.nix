{
  lib,
  user,
  pkgs,
  import-tree,
  ...
}:

{
  imports = [
    ./options.nix
    ./secrets.nix

    (import-tree [
      ./modules
      ./programs
    ])
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      stow # NOTE: needed for symlink script
    ];
    activation = {
      symlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        "$NIXOS_CONFIG_DIR"/dotfiles/scripts/symlink
      '';
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
