{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    settings = {
      yazi = {
        mgr = {
          ratio = [
            10
            25
            16
          ];

          sort_by = "natural";
          sort_sensitive = true;
          sort_dir_first = true;

          show_hidden = true;
          show_symlink = true;

          scrolloff = 5;
        };

        preview = {
          wrap = "no";
          tab_size = 3;
          image_filter = "lanczos3";
        };
        # https://yazi-rs.github.io/docs/configuration/yazi#opener
      };
    };
  };
}
