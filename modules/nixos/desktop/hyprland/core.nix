{ config, lib, ... }:

let
  isHyprland = config.nixosDesktopModules.use == "hyprland";
  masterEnable = config.nixosDesktopModules.enable;
in
{
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
