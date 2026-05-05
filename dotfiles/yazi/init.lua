require("full-border"):setup {
   -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
   type = ui.Border.PLAIN,
}

require("yatline"):setup({
   show_background = false,

   header_line = {
      left = {
         section_a = {
            { type = "line", custom = false, name = "tabs", params = { "left" } },
         },
         section_b = {
         },
         section_c = {
         }
      },
      right = {
         section_a = {
            { type = "coloreds", custom = true, name = { { " 󰇥 ", "black" } } },
         },
         section_b = {
         },
         section_c = {
            { type = "coloreds", custom = false, name = "count" },
         }
      }
   },

   status_line = {
      left = {
         section_a = {
            { type = "string", custom = false, name = "tab_mode" },
         },
         section_b = {
            { type = "string", custom = false, name = "hovered_size" },
         },
         section_c = {
            { type = "string", custom = false, name = "hovered_path" },
         }
      },
      right = {
         section_a = {
            { type = "string", custom = false, name = "cursor_position" },
         },
         section_b = {
            { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
         },
         section_c = {
            { type = "string",   custom = false, name = "hovered_ownership" },
            { type = "coloreds", custom = false, name = "permissions" },
         }
      }
   },
})

require("git"):setup()
