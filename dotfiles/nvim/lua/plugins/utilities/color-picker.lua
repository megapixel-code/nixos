return {
   "uga-rosa/ccc.nvim",

   init = function()
      vim.keymap.set(
         "n",
         "<leader>rc",
         "<cmd>CccHighlighterDisable<CR><cmd>CccHighlighterEnable<CR>",
         { desc = "Refresh CCC plugin" }
      );
      vim.keymap.set( "n", "<leader>cc", ":CccPick<CR>", { desc = "Pick color" } );
   end,

   config = function()
      local ccc = require( "ccc" );
      ccc.setup( {
         highlighter = {
            auto_enable = true, -- start the highlighter on file open
            excludes = {},      -- ft to deactivate highlight
         },
         outputs = {
            ccc.output.hex,
            ccc.output.hex_short,
            ccc.output.css_rgb,
            ccc.output.css_rgba,
            ccc.output.css_hsl,
         },
         convert = {
            { ccc.picker.hex,     ccc.output.css_rgb },
            { ccc.picker.css_rgb, ccc.output.css_hsl },
            { ccc.picker.css_hsl, ccc.output.hex },
         },
         pickers = {
            ccc.picker.hex,
            ccc.picker.css_rgb,
            ccc.picker.css_hsl,
            ccc.picker.css_hwb,
            ccc.picker.css_lab,
            ccc.picker.css_lch,
            ccc.picker.css_oklab,
            ccc.picker.css_oklch,
         },
      } );

      ccc.output.hex.setup( { uppercase = true } );
      ccc.output.hex_short.setup( { uppercase = true } );
   end,
};
