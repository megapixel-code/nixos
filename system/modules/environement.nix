{
  lib,
  ...
}:
{
  environment = {
    pathsToLink = [
      # important, needed to use xdg.portal.enable
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    shellAliases = {
      # removes base aliases added by nix
      l = null;
      ls = null;
      ll = null;
    };

    sessionVariables = lib.mkMerge [
      # (lib.mkIf false {
      # })
      {
        ### follow XDG base dir specification https://wiki.archlinux.org/title/XDG_Base_Directory

        # main
        NIXOS_CONFIG_DIR = "/etc/nixos";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_PICTURES_DIR = "$HOME/pictures";
        XDG_DOWNLOAD_DIR = "$HOME/downloads";
        XDG_CONFIG_DIR = "/etc/xdg";
        HISTFILE = "$XDG_STATE_HOME/bash/history";

        # partialy suported
        CARGO_HOME = "$XDG_CACHE_HOME/cargo";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"; # FIXME: not working
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc"; # NOTE: look in xdg-desktop.nix
        XCOMPOSEFILE = "$XDG_CONFIG_HOME/X11/xcompose";
        XCOMPOSECACHE = "$XDG_CONFIG_HOME/X11/xcompose";
        GNUPGHOME = "$XDG_DATA_HOME/gnupg"; # NOTE: look in gnupg.nix
        PASSWORD_STORE_DIR = "$XDG_DATA_HOME/pass";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc"; # NOTE: look in xdg-desktop.nix
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        W3M_DIR = "$XDG_STATE_HOME/w3m";

        GRIM_DEFAULT_DIR = "$HOME/pictures/screenshoots"; # NOTE: look in home.nix > activation

        WLR_NO_HARDWARE_CURSORS = "1"; # weird cursor behavior
        NIXOS_OZONE_WL = "1"; # hint electrons apps to use wayland
        MOZ_ENABLE_WAYLAND = "1"; # tell mozilla you are on wayland
        GTK_USE_PORTAL = "1"; # for outdated gtk programs termfilechooser
        GDK_DEBUG = "portals"; # for termfilechooser
      }
    ];

    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERM = "screen-256color";
    };
  };
}
