{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment = {
    shellAliases = {
      # removes base aliases added by nix
      l = null;
      ls = null;
      ll = null;
    };

    sessionVariables = {
      ### follow XDG base dir specification https://wiki.archlinux.org/title/XDG_Base_Directory
      # main
      HOME = "/home/ivan";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      # partialy suported
      CARGO_HOME = "$XDG_CACHE_HOME/cargo";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";

      WLR_NO_HARDWARE_CURSORS = "1"; # weird cursor behavior
      NIXOS_OZONE_WL = "1"; # hint electrons apps to use wayland
      NIXOS_NVIM = "1"; # environement variable to tell nvim we are on nixos
      MOZ_ENABLE_WAYLAND = "1"; # tell mozilla you are on wayland
    };

    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };

  };
}
