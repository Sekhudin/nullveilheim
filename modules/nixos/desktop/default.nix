{ lib, ... }:

{

  imports = [
    ./gnome
    ./hyprland
  ];

  options.nixosDesktopModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable desktop modules";
      default = false;
    };

    use = lib.mkOption {
      type = lib.types.enum [
        "gnome"
        "hyprland"
      ];
      description = "choose wayland compositor";
      default = "gnome";
    };
  };
}
