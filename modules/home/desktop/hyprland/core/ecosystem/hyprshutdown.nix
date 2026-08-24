{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    home = {
      packages = with pkgs; [
        hyprshutdown
      ];
    };
  };
}
