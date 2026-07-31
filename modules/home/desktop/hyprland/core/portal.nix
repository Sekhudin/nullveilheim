{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
        ];
        config = { };
      };
    };
  };
}
