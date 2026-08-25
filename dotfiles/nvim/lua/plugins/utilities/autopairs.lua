return {
   "windwp/nvim-autopairs",
   event = "InsertEnter",
   opts = {
      enabled = function( bufnr ) return true; end, -- control if auto-pairs should be enabled when attaching to a buffer
      disable_filetype = { "TelescopePrompt" },
      disable_in_macro = true,                      -- disable when recording or executing a macro
      disable_in_visualblock = false,               -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = false,        -- add bracket pairs after quote
      enable_check_bracket_line = true, -- check bracket in same line
      enable_bracket_in_quote = true,   --
      enable_abbr = false,              -- trigger abbreviation
      break_undo = true,                -- switch for basic rule break undo sequence
      check_ts = false,
      map_cr = true,
      map_bs = true,   -- map the <BS> key
      map_c_h = false, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
   },
   init = function()
      local plugin = require( "nvim-autopairs" );
      local rule = require( "nvim-autopairs.rule" );
      local utils = require( "nvim-autopairs.utils" );
      local conds = require( "nvim-autopairs.conds" );
      local ts_conds = require( "nvim-autopairs.ts-conds" );
      local log = require( "nvim-autopairs._log" );

      local not_ts_node = function( nodes )
         return function()
            log.debug( "not_ts_node" );

            local p = vim.api.nvim_win_get_cursor( 0 );
            local pos_adjusted = { p[1] - 1, p[2] - 1 };

            vim.treesitter.get_parser():parse();
            local target = vim.treesitter.get_node( { pos = pos_adjusted, ignore_injections = false } );

            if target ~= nil and utils.is_in_table( nodes, target:type() ) then
               log.debug( target:type() );
               return false;
            end;
         end;
      end;

      local function autospace( a1, inside, a2, lang )
         plugin.add_rule(
            rule( inside, inside, lang )
            :with_pair( function( opts )
               return a1 .. a2 == opts.line:sub( opts.col - #a1, opts.col + #a2 - 1 );
            end )
            :with_move( conds.none() )
            :with_cr( conds.none() )
            :with_del( function( opts )
               local col = vim.api.nvim_win_get_cursor( 0 )[2];
               return a1 .. inside .. inside .. a2 ==
                  opts.line:sub( col - #a1 - #inside + 1, col + #inside + #a2 ); -- insert only works for #ins == 1 anyway
            end )
         );
      end;
      autospace( "(", " ", ")" );
      autospace( "[", " ", "]" );
      autospace( "{", " ", "}" );
      autospace( "<", " ", ">" );

      plugin.add_rules( {
         rule( "= ", ";", "nix" )
            :with_pair( not_ts_node( { "comment" } ) )
            :set_end_pair_length( 1 ),

         rule( "<", ">", { "-html" } )
            :with_pair(
            -- regex will make it so that it will auto-pair on
            -- `a<` but not `a <`
            -- The `:?:?` part makes it also
            -- work on Rust generics like `some_func::<T>()`
               conds.before_regex( "%a+:?:?$", 3 )
            ):with_move( function( opts )
            return opts.char == ">";
         end ),
      } );
   end,


};
