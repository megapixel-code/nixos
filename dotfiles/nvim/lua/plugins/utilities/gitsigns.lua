return {
   "lewis6991/gitsigns.nvim",

   init = function()
      vim.keymap.set( "n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>",      { desc = "toggle Git Diff" } );
      vim.keymap.set( "n", "<leader>gh", "<cmd>Gitsigns toggle_linehl<CR>", { desc = "toggle Git Highlights" } );
      vim.keymap.set( "n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>",
                      {
                         desc =
                         "toggle Git line Blame",
                      } );
      -- TODO: git Preview hunk, go to next hunk in the git *project*, etc...
   end,
   opts = {
      signs = {
         add = { text = "+" },
         change = { text = "~" },
         delete = { text = "_" },
         topdelete = { text = "‾" },
         changedelete = { text = "~" },
         untracked = { text = "┆" },
      },
      signs_staged = {
         add = { text = "┃" },
         change = { text = "┃" },
         delete = { text = "_" },
         topdelete = { text = "‾" },
         changedelete = { text = "~" },
         untracked = { text = "┆" },
      },
      signs_staged_enable = true,

      signcolumn = true,          -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,              -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,             -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false,          -- Toggle with `:Gitsigns toggle_word_diff`
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`

      watch_gitdir = {
         enable = true,
         follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame_opts = {
         virt_text = true,
         virt_text_pos = "right_align",
         delay = 10,
         ignore_whitespace = false,
         virt_text_priority = 100,
         use_focus = true,
      },
      sign_priority = 6,
      update_debounce = 100,

      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      status_formatter = function( status )
         local added, changed, removed = status.added, status.changed, status.removed;
         local status_txt = {};
         if added and added > 0 then
            table.insert( status_txt, "+" .. added );
         end;
         if changed and changed > 0 then
            table.insert( status_txt, "~" .. changed );
         end;
         if removed and removed > 0 then
            table.insert( status_txt, "-" .. removed );
         end;
         return table.concat( status_txt, " " );
      end,

      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
         relative = "cursor",
         border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
         row = 0,
         col = 1,
      },
   },
};
