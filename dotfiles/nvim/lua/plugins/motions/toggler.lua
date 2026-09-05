return {
   "nguyenvukhang/nvim-toggler",

   init = function()
      vim.keymap.set( "n", "<leader>tt", require( "nvim-toggler" ).toggle, { desc = "toggle word under cursor" } );
   end,
   opts = {
      inverses = {
         ["open"] = "close",
         ["true"] = "false",
         ["always"] = "never",
         ["yes"] = "no",
      },
      remove_default_inverses = true,
      remove_default_keybinds = true,
   },
};
