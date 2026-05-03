return {
   "jake-stewart/multicursor.nvim",

   init = function()
      local multicursors = require( "multicursor-nvim" );

      vim.keymap.set( { "n", "x" }, "<c-k>",         function() multicursors.lineAddCursor( -1 ); end );
      vim.keymap.set( { "n", "x" }, "<c-j>",         function() multicursors.lineAddCursor( 1 ); end );
      vim.keymap.set( { "n", "x" }, "<leader><c-k>", function() multicursors.lineSkipCursor( -1 ); end );
      vim.keymap.set( { "n", "x" }, "<leader><c-j>", function() multicursors.lineSkipCursor( 1 ); end );

      vim.keymap.set( { "n", "x" }, "<leader>n",     function() multicursors.matchAddCursor( 1 ); end );
      vim.keymap.set( { "n", "x" }, "<leader>s",     function() multicursors.matchSkipCursor( 1 ); end );
      vim.keymap.set( { "n", "x" }, "<leader>N",     function() multicursors.matchAddCursor( -1 ); end );
      vim.keymap.set( { "n", "x" }, "<leader>S",     function() multicursors.matchSkipCursor( -1 ); end );

      vim.keymap.set( { "n", "x" }, "<c-q>",         multicursors.toggleCursor );
      vim.keymap.set( { "n", "x" }, "gq",            multicursors.restoreCursors );
      vim.keymap.set( "x",          "S",             multicursors.splitCursors );

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      multicursors.addKeymapLayer( function( layerSet )
         -- Select a different cursor as the main one.
         layerSet( { "n", "x" }, "<c-p>", multicursors.prevCursor );
         layerSet( { "n", "x" }, "<c-n>", multicursors.nextCursor );

         -- Delete the main cursor.
         layerSet( { "n", "x" }, "<c-x>", multicursors.deleteCursor );

         -- Enable and clear cursors using escape.
         layerSet( "n", "<esc>", function()
            if not multicursors.cursorsEnabled() then
               multicursors.enableCursors();
            else
               multicursors.clearCursors();
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
