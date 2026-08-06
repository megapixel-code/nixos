--- Automatically change terminal theme on quit
local function autoscheme()
   if not vim.g.terminal_color_0 then
      print( "autoscheme: unable to change terminal theme, no terminal_color" );
      return;
   end;

   -- addapted from :
   -- https://stackoverflow.com/questions/27870682/how-to-get-the-background-color-in-vim
   local bg = vim.api.nvim_exec2( 'echo synIDattr(hlID("Normal"), "bg")', { output = true } ).output;
   local fg = vim.api.nvim_exec2( 'echo synIDattr(hlID("Normal"), "fg")', { output = true } ).output;

   local content =
      "background " .. bg .. "\n" ..
      "foreground " .. fg .. "\n" ..
      "selection_background " .. fg .. "\n" ..
      "selection_foreground " .. bg .. "\n" ..
      "cursor " .. fg .. "\n" ..
      "color0 " .. vim.g.terminal_color_0 .. "\n" ..
      "color1 " .. vim.g.terminal_color_1 .. "\n" ..
      "color2 " .. vim.g.terminal_color_2 .. "\n" ..
      "color3 " .. vim.g.terminal_color_3 .. "\n" ..
      "color4 " .. vim.g.terminal_color_4 .. "\n" ..
      "color5 " .. vim.g.terminal_color_5 .. "\n" ..
      "color6 " .. vim.g.terminal_color_6 .. "\n" ..
      "color7 " .. vim.g.terminal_color_7 .. "\n" ..
      "color8 " .. vim.g.terminal_color_8 .. "\n" ..
      "color9 " .. vim.g.terminal_color_9 .. "\n" ..
      "color10 " .. vim.g.terminal_color_10 .. "\n" ..
      "color11 " .. vim.g.terminal_color_11 .. "\n" ..
      "color12 " .. vim.g.terminal_color_12 .. "\n" ..
      "color13 " .. vim.g.terminal_color_13 .. "\n" ..
      "color14 " .. vim.g.terminal_color_14 .. "\n" ..
      "color15 " .. vim.g.terminal_color_15 .. "\n";

   local xdg_config_home = os.getenv( "XDG_CONFIG_HOME" );
   local file, err = io.open( xdg_config_home .. "/kitty/current-theme.conf", "w" );

   if file then
      file:write( content );
      file:close();
   else
      print( "error opening a file : err ", err );
      return;
   end;

   vim.cmd( "silent !kill -SIGUSR1 $(pidof kitty)" ); -- reload terminal
end;

return {
   -- "Megapixel-code/color-skimer.nvim",
   -- OR localy:
   dir = "~/projects/personal/color-skimer.nvim",

   init = function()
      local color_skimer = require( "color-skimer" );
      vim.keymap.set( "n", "<leader>sc", "<cmd>ColorSkimerToggle<CR>", {
         desc =
         "Search Colorschemes",
      } );
      vim.keymap.set( "n", "<leader>cs", color_skimer.set_random_colorscheme, { desc = "Set random colorscheme" } );
   end,

   --- @module "color-skimer"
   --- @type color_skimer_config
   opts = {
      colorscheme = {
         "vscode",
         "gruber-darker",
         "github_dark_default",
         "lackluster",
         "no-clown-fiesta-dark",
         "vague",
         "kanso-ink",
         "kanagawa-paper-ink",
         "zenwritten",
         "rosebones",
         "tokyobones",
         "neobones",
         "base16-ashes",
         "base16-kanagawa-dragon",
         "base16-vulcan",
         "base16-tarot",
         "boo",
         "sunset_cloud",
         "radioactive_waste",
         "forest_stream",
         "crimson_moonlight",
         "mfd-dark",
         "ef-winter",
         "ef-deuteranopia-dark",

         "ef-summer",
         "ef-elea-light",
         "modus_operandi",

         -- [PROBATION]
      },

      name_override = {
         ["github_dark_default"] = "github",
      },

      pre_preview = {
         ["*"] = function()
            vim.o.background = "dark";
         end,
      },
      post_preview = {
         ["*"] = function()
            -- gutter always looks the same
            vim.api.nvim_set_hl( 0, "CursorLineNr",   { link = "LineNr" } );
            vim.api.nvim_set_hl( 0, "CursorLineNr",   { bold = true } );

            vim.api.nvim_set_hl( 0, "FoldColumn",     { link = "LineNr" } );
            vim.api.nvim_set_hl( 0, "SignColumn",     { link = "LineNr" } );

            vim.api.nvim_set_hl( 0, "CursorLineFold", { link = "CursorLineNr" } );
            vim.api.nvim_set_hl( 0, "CursorLineSign", { link = "CursorLineNr" } );

            -- lsp should never be underlined
            local lsp_hover_hl = { link = "Visual" };
            vim.api.nvim_set_hl( 0, "LspReferenceText",  lsp_hover_hl );
            vim.api.nvim_set_hl( 0, "LspReferenceRead",  lsp_hover_hl );
            vim.api.nvim_set_hl( 0, "LspReferenceWrite", lsp_hover_hl );

            -- line number on tscontext
            local tscontext_hl = { link = "NormalFloat" };
            vim.api.nvim_set_hl( 0, "TreesitterContext",                 tscontext_hl );
            vim.api.nvim_set_hl( 0, "TreesitterContextLineNumber",       tscontext_hl );
            vim.api.nvim_set_hl( 0, "TreesitterContextSeparator",        tscontext_hl );
            vim.api.nvim_set_hl( 0, "TreesitterContextBottom",           tscontext_hl );
            vim.api.nvim_set_hl( 0, "TreesitterContextLineNumberBottom", tscontext_hl );
         end,
      },

      pre_save = {},
      post_save = {
         ["*"] = function()
            autoscheme();
         end,
      },
   },
};
