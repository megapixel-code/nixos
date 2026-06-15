{
  config,
  pkgs,
  ...
}:
{
  nix.settings = {
    # makes nix follow xdg base dir specification
    use-xdg-base-directories = true;
  };

  xdg = {
    enable = true; # enable setting up xdg environment variables
    # environment variables directories
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      publicShare = "${config.home.homeDirectory}/public";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
      projects = "${config.home.homeDirectory}/projects";
    };

    # -- [[ Files inside cache/config/data/state ]] --
    cacheFile = {
    };
    configFile = {
      "xdg-desktop-portal-termfilechooser/config" = {
        force = true;
        executable = true;
        text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          default_dir=$HOME/downloads
          create_help_file=1
          env=TERMCMD='kitty --title filechooser'
          env=PATH="$PATH:/run/current-system/sw/bin"
          open_mode=suggested
          save_mode=last
        '';
      };

      # [xdg-base-directory specification]
      "npm/npmrc" = {
        force = true;
        text = ''
          prefix=''${XDG_DATA_HOME}/npm
          cache=''${XDG_CACHE_HOME}/npm
          init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
          logs-dir=''${XDG_STATE_HOME}/npm/logs
        '';
      };

      "wgetrc" = {
        force = true;
        text = ''
          hsts-file = ${config.xdg.dataHome}/wget-hsts
        '';
      };
    };
    dataFile = {
    };
    stateFile = {
    };

    # portal config :
    portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];

      config = {
        # to find XDG files : got to the {hash} of the new version and find file named xdg-desktop*
        # .services files are located : /etc/profiles/per-user/...{user}.../share/systemd/user

        # pattern :
        # {name} -> "{name}-" -> {name}-portals.conf file

        # common -> empty -> portals.conf file
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];

          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };

        # wlroots -> "wlroots-" -> wlroots-portals.conf file
        wlroots = {
        };
      };
    };

    mimeApps = {
      enable = true;
      # ll /etc/profiles/per-user/ivan/share/applications /run/current-system/sw/share/applications
      defaultApplications = {
        "application/pdf" = [
          "org.pwmt.zathura.desktop"
        ];
        "application/*" = [
          "base.desktop"
        ];
        "video/*" = [
          "vlc.desktop"
        ];
        "audio/*" = [
          "vlc.desktop"
        ];
      };
    };
  };
}
