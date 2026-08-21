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
          "bluetooth" = {
            format-on = ''<span size="150%">󰂯</span>'';
            format-off = ''<span size="150%">󰂲</span>'';
            format-connected = ''<span size="150%">󰂱</span>'';
            format-disabled = ''<span size="150%">󰂲</span>'';
            align = 0.5;
            justify = "center";
            tooltip = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
