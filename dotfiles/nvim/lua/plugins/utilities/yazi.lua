return {
   "mikavilpas/yazi.nvim",
   version = "*", -- use the latest stable version
   event = "VeryLazy",
   dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
   },

   init = function()
      vim.keymap.set( "n", "<leader>yy", "<cmd>Yazi<cr>",        { desc = "open Yazi at the current file" } );
      vim.keymap.set( "n", "<leader>ys", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" } );
      vim.keymap.set( "n", "<leader>yc", function()
                         require( "yazi" ).yazi( { change_neovim_cwd_on_close = true } );
                      end, { desc = "Yazi Change CWD" } );
   end,
   opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      floating_window_scaling_factor = 1,
      hooks = {
         yazi_opened = function( preselected_path, yazi_buffer_id, config )
            vim.api.nvim_buf_del_keymap( 0, "t", "<Esc><Esc>" );
         end,
      },
      keymaps = {
         show_help = "<f1>",
      },
   },
};
