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
        dotfiles_dir="/etc/nixos/dotfiles/"

        configfiles_dir="${config.xdg.configHome}/"
        font_dir="${config.xdg.dataHome}/fonts/"
        formaters_dir="${config.home.homeDirectory}/"

        readarray -t configfiles <<< "$(ls -d "$dotfiles_dir"*/)"
        fonts_files=(
        	W95FA.otf
        )
        formaters_files=(
        	.clang-format
        	.prettierrc.json
        )

        mkdir -p "$configfiles_dir"
        mkdir -p "$font_dir"
        mkdir -p "$formaters_dir"

        for e in "''${configfiles[@]}"; do
        	bn="$(basename "$e")"
        	mkdir -p "$configfiles_dir$bn"
        	ln -sfn "$e"* "$configfiles_dir$bn"
        done
        for e in "''${fonts_files[@]}"; do
        	ln -sfn "$dotfiles_dir$e" "$font_dir"
        done
        for e in "''${formaters_files[@]}"; do
        	ln -sfn "$dotfiles_dir$e" "$formaters_dir"
        done
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
