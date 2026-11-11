{
  config,
  user,
  pkgs,
  ...
}:
{
  services.dunst = {
    enable = config.home-manager.users.${user}.my.module_mango.enable;
    package = pkgs.dunst;
    enableX11 = false;

    settings = {
      global =
        let
          red = "#FF0000";
          primary = "#C2C2C2";
          primary-light = "#F9F9F9";
          primary-dark = "#222222";
          primary-darker = "#000000";
        in
        {
          enable_posix_regex = true;

          width = 300;
          height = "(0, 300)";
          offset = "30x30";
          origin = "top-right";
          padding = 8;
          frame_width = 2;
          gap_size = 4;

          font = "Tiny5";

          # https://docs.gtk.org/Pango/pango_markup.html
          # %a  appname
          # %s  summary
          # %b  body
          # %c  category
          # %S  stack_tag
          # %i  iconname (including its path)
          # %I  iconname (without its path)
          # %p  progress value ([  0%] to [100%])
          # %n  progress value without any extra characters
          # %%  literal %
          format = "<b>%s</b>\n%b";

          corner_radius = 0;
          mouse_left_click = "open_url";
          mouse_middle_click = "do_action, remove_current";
          mouse_right_click = "close_current";

          background = primary;
          foreground = primary-dark;
          highlight = red;
          frame_color = primary-light;
        };

      # urgency_normal = {
      #   background = "#37474f";
      #   foreground = "#eceff1";
      #   timeout = 10;
      # };
    };

  };
}
