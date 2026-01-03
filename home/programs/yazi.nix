{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    # enableZshIntegration = true;
    # shellWrapperName = "y";

    settings = {
      mgr = {
        ratio = [
          10
          25
          16
        ];

        sort_by = "natural";
        sort_sensitive = true;
        sort_dir_first = true;

        show_hidden = true;
        show_symlink = true;

        scrolloff = 5;
      };

      preview = {
        wrap = "no";
        tab_size = 3;
        image_filter = "lanczos3";
      };
      # https://yazi-rs.github.io/docs/configuration/yazi#opener
    };

    keymap = {
      mgr.prepend_keymap = [
        # wl-clipboard plugin
        {
          on = [ "<C-y>" ];
          run = "plugin wl-clipboard";
          desc = "yank files in clipboard";
        }

        # chmod plugin
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }

        # restore plugin
        {
          on = [ "u" ];
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }

        #mount plugin
        {
          on = [ "M" ];
          run = "plugin mount";
          desc = "Open the mount plugin";
        }

        # compress plugin
        {
          on = [
            "c"
            "o"
          ];
          run = "plugin compress";
          desc = "Archive selected files";
        }
      ];
    };

    initLua = ''
      -- require("aslkfj").setup()
    '';

    plugins = with pkgs.yaziPlugins; {
      inherit wl-clipboard;
      inherit mount;
      inherit chmod;
      inherit restore; # FIXME: not working
      inherit compress;
    };

    extraPackages = with pkgs; [
      udisks # dependency of mount plugin
      trash-cli # dependency of restore plugin
    ];
  };
}
