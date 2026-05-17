return {
   "jake-stewart/multicursor.nvim",

   init = function()
      local mc = require( "multicursor-nvim" );

      vim.keymap.set( { "n", "x" }, "<c-k>",
                      function() mc.lineAddCursor( -1 ); end, { desc = "Multicursor lineAddCursor" } );
      vim.keymap.set( { "n", "x" }, "<c-j>",
                      function() mc.lineAddCursor( 1 ); end, { desc = "Multicursor lineAddCursor" } );
      vim.keymap.set( { "n", "x" }, "<leader><c-k>",
                      function() mc.lineSkipCursor( -1 ); end, { desc = "Multicursor lineSkipCursor" } );
      vim.keymap.set( { "n", "x" }, "<leader><c-j>",
                      function() mc.lineSkipCursor( 1 ); end, { desc = "Multicursor lineSkipCursor" } );

      vim.keymap.set( { "n", "x" }, "<leader>n",
                      function() mc.matchAddCursor( 1 ); end, { desc = "Multicursor matchAddCursor" } );
      vim.keymap.set( { "n", "x" }, "<leader>s",
                      function() mc.matchSkipCursor( 1 ); end, { desc = "Multicursor matchSkipCursor" } );
      vim.keymap.set( { "n", "x" }, "<leader>N",
                      function() mc.matchAddCursor( -1 ); end, { desc = "Multicursor matchAddCursor" } );
      vim.keymap.set( { "n", "x" }, "<leader>S",
                      function() mc.matchSkipCursor( -1 ); end, { desc = "Multicursor matchSkipCursor" } );

      vim.keymap.set( { "n", "x" }, "<c-q>",
                      mc.toggleCursor, { desc = "Multicursor toggleCursor" } );
      vim.keymap.set( { "n", "x" }, "gq",
                      mc.restoreCursors, { desc = "Multicursor restoreCursors" } );
      vim.keymap.set( "x", "<c-s>",
                      mc.splitCursors, { desc = "Multicursor splitCursors" } );

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer( function( layerSet )
         -- Select a different cursor as the main one.
         layerSet( { "n", "x" }, "<c-p>",
                   mc.prevCursor, { desc = "Multicursor prevCursor" } );
         layerSet( { "n", "x" }, "<c-n>",
                   mc.nextCursor, { desc = "Multicursor nextCursor" } );

         -- Delete the main cursor.
         layerSet( { "n", "x" }, "<c-x>",
                   mc.deleteCursor, { desc = "Multicursor deleteCursor" } );

         -- Enable and clear cursors using escape.
         layerSet( "n", "<esc>", function()
            if not mc.cursorsEnabled() then
               mc.enableCursors();
            else
               mc.clearCursors();
            end;
         end );
      end );

      -- Customize how cursors look.
      vim.api.nvim_set_hl( 0, "MultiCursorCursor",         { reverse = true } );
      vim.api.nvim_set_hl( 0, "MultiCursorVisual",         { link = "Visual" } );
      vim.api.nvim_set_hl( 0, "MultiCursorSign",           { link = "SignColumn" } );
      vim.api.nvim_set_hl( 0, "MultiCursorMatchPreview",   { link = "Search" } );
      vim.api.nvim_set_hl( 0, "MultiCursorDisabledCursor", { reverse = true } );
      vim.api.nvim_set_hl( 0, "MultiCursorDisabledVisual", { link = "Visual" } );
      vim.api.nvim_set_hl( 0, "MultiCursorDisabledSign",   { link = "SignColumn" } );
   end,

   opts = {},
};
