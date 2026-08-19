{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableSwayOsd = (cfg.osd.use == "swayosd");
in
{
  config = lib.mkIf (cfg.enable && enableSwayOsd) {
    services = {
      swayosd = {
        enable = true;
        stylePath = null;
        topMargin = 0.5;
      };
    };
  };
}
