{
  lib,
  ...
}:

{
  imports = [
    ./formatters.nix
    ./xdg-desktop.nix
    ./cursor.nix

    ./programs/firefox.nix
    ./programs/git.nix
    ./programs/nvim.nix
    ./programs/yazi.nix
    ./programs/bat.nix
    ./programs/sunsetr.nix
    ./programs/gnupg.nix
    ./programs/zsh.nix
    ./programs/mail.nix
  ];

  home = {
    username = "ivan";
    homeDirectory = "/home/ivan";

    # packages = with pkgs; [
    #   # inputs.quickshell.packages."${pkgs.system}".default # bar
    # ];

    activation = {
      create-screenshoot-folder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $GRIM_DEFAULT_DIR
      ''; # $HOME/images/screenshoots/
      create-documents-folder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/documents/projects/
      ''; # $HOME/documents/
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
