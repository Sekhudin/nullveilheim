{ config, lib, ... }:

let
  # cfg = config.nixosDesktopModules.desktop;
  isHyprland = config.nixosDesktopModules.use == "hyprland";
  masterEnable = config.nixosDesktopModules.enable;
in
{
  options.nixosDesktopModules.desktop = {
    hyprland = lib.mkOption {
      type = lib.types.attrs;
      description = "hyprland settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isHyprland) { };
}
