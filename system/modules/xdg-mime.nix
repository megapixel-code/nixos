{
  ...
}:
{
  xdg = {
    mime = {
      enable = true;
      # ll /etc/profiles/per-user/ivan/share/applications /run/current-system/sw/share/applications
      defaultApplications = {
        "application/pdf" = [
          "org.pwmt.zathura.desktop"
        ];
        "application/*" = [
          "base.desktop"
        ];
        "image/*" = [
          "vimiv.desktop"
        ];
        "video/*" = [
          "vlc.desktop"
        ];
        "audio/*" = [
          "vlc.desktop"
        ];
      };
    };
  };
}
