{
  inputs,
  ...
}:
{
  # repo:
  # https://github.com/xremap/xremap

  # keybinds:
  # https://github.com/emberian/evdev/blob/1d020f11b283b0648427a2844b6b980f1a268221/src/scancodes.rs#L26-L572
  # https://github.com/xremap/xremap/blob/master/src/config/key.rs

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];

  services.xremap = {
    enable = true;

    config = {
      # Modmap for single key rebinds
      modmap = [
        {
          name = "Caps to Ctrl remap";
          remap = {
            "CAPSLOCK" = "CTRL_L";
          };
        }
        {
          name = "Hold tab to mod4";
          remap = {
            "KEY_TAB" = {
              held = "SUPER_L";
              alone = "KEY_TAB";
              free_hold = true;
            };
          };
        }
      ];

      # Keymap for key combo rebinds
      keymap = [
        {
          name = "Escape remap";
          remap = {
            "C-KEY_LEFTBRACE" = "ESC";
          };
        }
      ];
    };
  };
}
