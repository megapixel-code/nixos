{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;

    extraPackages = with pkgs; [
      udisks # dependency of mount plugin
      util-linux # dependency of mount plugin
      trash-cli # dependency of restore plugin
      git
      dragon-drop # drag and drop
    ];

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

      plugin.prepend_fetchers = [
        {
          id = "git";
          url = "*";
          run = "git";
        }
        {
          id = "git";
          url = "*/";
          run = "git";
        }
      ];
    };

    theme = {
      indicator = {
        padding = {
          open = "█";
          close = "█";
        };
      };
      icon = {
        prepend_conds = [
          {
            "if" = "dir";
            "text" = "";
            "fg" = "blue";
          }
        ];
        dirs = [
          {
            name = ".config";
            text = "";
          }
          {
            name = ".git";
            text = "";
          }
          {
            name = ".github";
            text = "";
          }
          {
            name = "desktop";
            text = "";
          }
          {
            name = "documents";
            text = "";
          }
          {
            name = "downloads";
            text = "";
          }
          {
            name = "music";
            text = "";
          }
          {
            name = "pictures";
            text = "";
          }
          {
            name = "projects";
            text = "󰊢";
          }
          {
            name = "public";
            text = "";
          }
          {
            name = "templates";
            text = "";
          }
          {
            name = "videos";
            text = "";
          }
        ];
      };
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

        # drag and drop
        {
          on = "<C-n>";
          run = "shell 'dragon-drop -x -i -T \"$1\"' --confirm";
        }
      ];
    };

    initLua = ''
      require("full-border"):setup {
         -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
         type = ui.Border.PLAIN,
      }

      require("yatline"):setup({
         show_background = false,

         header_line = {
            left = {
               section_a = {
                  { type = "line", custom = false, name = "tabs", params = { "left" } },
               },
               section_b = {
               },
               section_c = {
               }
            },
            right = {
               section_a = {
                  {type = "coloreds", custom = true, name = {{" 󰇥 ", "black" }}},
               },
               section_b = {
               },
               section_c = {
                  { type = "coloreds", custom = false, name = "count" },
               }
            }
         },

         status_line = {
            left = {
               section_a = {
                  { type = "string", custom = false, name = "tab_mode" },
               },
               section_b = {
                  { type = "string", custom = false, name = "hovered_size" },
               },
               section_c = {
                  { type = "string",   custom = false, name = "hovered_path" },
               }
            },
            right = {
               section_a = {
                  { type = "string", custom = false, name = "cursor_position" },
               },
               section_b = {
                  { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
               },
               section_c = {
                  { type = "string", custom = false, name = "hovered_ownership" },
                  { type = "coloreds", custom = false, name = "permissions" },
               }
            }
         },
      })

      require("git"):setup()
    '';

    plugins = with pkgs.yaziPlugins; {
      inherit wl-clipboard;
      inherit chmod;
      inherit restore;
      inherit compress;
      inherit full-border;
      inherit yatline;
      inherit git;
      inherit mount; # FIXME: not working
    };
  };
}
