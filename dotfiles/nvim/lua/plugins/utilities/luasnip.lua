return {
   "L3MON4D3/LuaSnip",
   -- version = "v2.*", -- enable this back if problems
   build = "make install_jsregexp",

   init = function()
      local luasnip = require( "luasnip" );
      -- disable tab and s-tab keymap that would otherwise expand the snippet
      vim.keymap.set( { "i", "s" }, "<Tab>",   "<Tab>" );
      vim.keymap.set( { "i", "s" }, "<S-Tab>", "<S-Tab>" );
      vim.keymap.set( { "i", "s" }, "<c-j>", function()
                         if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump();
                         end;
                      end, { silent = true, desc = "go to next snippet jump" } );
      vim.keymap.set( { "i", "s" }, "<c-k>", function()
                         if luasnip.jumpable( -1 ) then
                            luasnip.jump( -1 );
                         end;
                      end, { silent = true, desc = "go to previous snippet jump" } );
   end,
   opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
   },
};
