--- @return string | nil
local function get_content()
   vim.treesitter.get_parser( 0 ):parse();
   local node = vim.treesitter.get_node();
   if (node == nil) then
      return nil;
   end;

   return vim.treesitter.get_node_text( node, 0 );
end;

--- function that returns the link
--- @param content string
--- @return string | nil
local function parse( content )
   if (content == "") then
      return nil;
   end;
   local link = nil;

   local origin = "https://github.com/"; -- default
   local matches = {
      ["github:"] = "https://github.com/",
      ["gitlab:"] = "https://gitlab.com/",
      ["codeberg:"] = "https://codeberg.org/",
   };
   local pathname;
   for match, m_origin in pairs( matches ) do
      pathname = content:gsub( match, "" );
      if (content ~= pathname) then
         origin = m_origin;
         break;
      end;
   end;

   local exclusions = {
      " ",
      ":",
   };
   for _, exclusion in ipairs( exclusions ) do
      if (pathname:find( exclusion )) then
         return nil;
      end;
   end;

   if pathname:match( "%a+/%a+" ) == nil then
      return nil;
   end;

   link = origin .. pathname;
   return link;
end;

local function open_link( link )
   local cmd, err = vim.ui.open( link );
   if (cmd) then
      cmd:wait();
   end;

   if (err ~= nil) then
      vim.print( "error: goto-link: " .. err );
   end;
   return err;
end;

local function goto_link()
   local content = get_content();
   if (content == nil) then
      return;
   end;
   local parts = vim.split( content, " " );
   if (#parts ~= 1) then
      parts = { vim.fn.expand( "<cWORD>" ) };
   end;

   for _, p in ipairs( parts ) do
      local link = parse( p );
      if (link ~= nil) then
         vim.print( "INFO: trying to open \"" .. link .. "\"" );
         local err = open_link( link );
         if (err == nil) then
            return;
         end;
      end;
   end;

   local link = vim.fn.expand( "<cWORD>" );
   vim.print( "INFO: trying to open \"" .. link .. "\"" );
   vim.ui.open( link );
end;

vim.keymap.set( "n", "gx", goto_link, { desc = "go to link" } );
