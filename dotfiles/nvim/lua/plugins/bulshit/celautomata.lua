return {
   dir = "~/projects/personal/celautomata.nvim/",
   lazy = true,

   init = function()
      vim.keymap.set( "n", "<leader><BS>", function()
                         require( "celautomata" ).start_random_animation(
                            nil, { "conways_game_of_life" } );
                      end, { desc = "lol" } );
   end,

   --- @module "celautomata"
   --- @type user_config_field
   opts = {
   },
};
