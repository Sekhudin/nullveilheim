{ config, lib, ... }:

let
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

  config = lib.mkIf (masterEnable && isHyprland) {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
        systemd.setPath.enable = true;
      };
    };
  };
}
