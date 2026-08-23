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
          "memory" = {
            format = ''<span size="150%"> </span>{percentage}%'';
            interval = 5;
            max-length = 15;
            align = 0.5;
            justify = "center";
            tooltip = false;
            expand = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
