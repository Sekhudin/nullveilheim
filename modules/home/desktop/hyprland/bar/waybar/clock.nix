{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "clock" = {
            format = "{:%d %b — %H:%M}";
            interval = 60;
            max-length = 15;
            tooltip = false;
            expand = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
