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
      waybar.settings = {
        "hyprland/window" = {
          format = "{title}";
          max-length = 20;
          separate-outputs = true;
          icon = false;
          icon-size = 12;
          expand = false;
          tooltip = false;
        };
      };
    };
  };
}
