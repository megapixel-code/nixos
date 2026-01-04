{
  inputs,
  ...
}:
{
  # repo:
  # https://github.com/xremap/xremap

  # keybinds:
  # https://github.com/emberian/evdev/blob/1d020f11b283b0648427a2844b6b980f1a268221/src/scancodes.rs#L26-L572

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
            "CapsLock" = "Ctrl_L";
          };
        }
      ];

      # Keymap for key combo rebinds
      keymap = [
        {
          name = "Escape remap";
          remap = {
            "C-KEY_LEFTBRACE" = "Esc";
          };
        }
      ];
    };
  };
}
