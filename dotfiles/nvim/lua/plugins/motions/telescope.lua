local is_inside_work_tree = {};
local mod_find_files = function()
   local cwd = vim.fn.getcwd();
   if is_inside_work_tree[cwd] == nil then
      vim.fn.system( "git rev-parse --is-inside-work-tree" );
      is_inside_work_tree[cwd] = vim.v.shell_error == 0;
   end;

   if is_inside_work_tree[cwd] then
      require( "telescope.builtin" ).git_files();
   else
      require( "telescope.builtin" ).find_files();
   end;
end;

return {
   "nvim-telescope/telescope.nvim",
   version = "*",
   dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
   },

   init = function()
      local telescope = require( "telescope" );
      local telescope_builtins = require( "telescope.builtin" );
      local telescope_config = require( "config.telescope" );

      telescope.load_extension( "fzf" );

      vim.keymap.set( "n", "<leader>sf", mod_find_files,                   { desc = "Search Files" } );
      vim.keymap.set( "n", "<leader>sh", telescope_builtins.help_tags,     { desc = "Search Help" } );
      vim.keymap.set( "n", "<leader>sm", telescope_builtins.marks,         { desc = "Search Marks" } );
      vim.keymap.set( "n", "<leader>ss", telescope_builtins.spell_suggest, { desc = "Search Spelling" } );
      vim.keymap.set( "n", "<leader>sn", function()
                         telescope_builtins.git_files( {
                            cwd = "/etc/nixos/dotfiles/nvim/",
                         } );
                      end, { desc = "Search Neovim" } );
      vim.keymap.set( "n", "<leader>sp", function()
                         telescope_builtins.find_files( {
                            cwd = vim.fs.joinpath( vim.fn.stdpath( "data" ), "lazy" ),
                         } );
                      end, { desc = "Search Plugins" } );
      vim.keymap.set( "n", "<leader>sg", telescope_config.multigrep, { desc = "Search Grep" } );
   end,
   opts = {
      defaults = {
         layout_strategy = "flex",
         sorting_strategy = "ascending",
         layout_config = {
            prompt_position = "top",
            height = 100000,
            width = 100000,
            vertical = {
               preview_height = .6,
               mirror = true,
            },
            horizontal = {
               preview_width = .6,
            },
         },
         prompt_prefix = "λ ",
         selection_caret = " ",
         path_display = { "truncate" },
         borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
         preview = { treesitter = true },

         file_ignore_patterns = {
            ".git/",
            "%.pdf",
            "%.mp4",
            "%.mkv",
            "%.png",
         },
      },

      pickers = {
         find_files = {
            find_command = { "find", "-type", "f", "-printf", "%P\n" },
         },
         git_files = {
            use_git_root = false,
            show_untracked = true,
         },
      },

      extensions = {
         fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
         },                                 -- the default case_mode is "smart_case"
      },
   },
};
