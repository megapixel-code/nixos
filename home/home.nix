{
  lib,
  config,
  user,
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

    activation = {
      create-folders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # $HOME/pictures/screenshoots/
        mkdir -p $GRIM_DEFAULT_DIR
        # $HOME/documents/projects/
        mkdir -p ${config.home.homeDirectory}/documents/projects/
      '';

      symlink-desktop-files = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        desktop_dir="${config.xdg.dataHome}/applications"

        mkdir -p "$desktop_dir"
        find "$desktop_dir" -name "*.desktop" -delete

        readarray -t desktopfiles <<< "$(find "${config.home.homeDirectory}/desktop" -name "*.desktop")"
        if [[ ''${desktopfiles[*]} == "" ]]; then
        	exit
        fi
        for e in "''${desktopfiles[@]}"; do
        	ln -sfn "$e" "$desktop_dir"
        done
      '';

      symlink-dotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run /etc/nixos/dotfiles/scripts/dotfiles_symlink
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
