{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.hyprland;
  isHyprland = config.nixosDesktopModules.use == "hyprland";
  masterEnable = config.nixosDesktopModules.enable;
in
{
  options.nixosDesktopModules.hyprland = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "hyprland settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isHyprland) { };
}
