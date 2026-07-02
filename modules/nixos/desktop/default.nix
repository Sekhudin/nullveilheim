{ lib, ... }:

{

  imports = [
    ./gnome
    ./hyprland
  ];

  options.nixosDesktopModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate desktop modules";
      default = true;
    };

    use = lib.mkOption {
      types = lib.types.enum [
        "gnome"
        "hyprland"
      ];
      description = "choose wayland compositor";
      default = "gnome";
    };
  };
}
