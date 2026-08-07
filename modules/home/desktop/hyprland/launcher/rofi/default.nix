{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableRofi = (cfg.launcher.use == "rofi");
in
{

  config = lib.mkIf (cfg.enable && enableRofi) {
    programs = {
      rofi = {
        enable = true;
      };
    };
  };
}
