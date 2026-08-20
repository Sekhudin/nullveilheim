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
            format = "{icon}";
            format-on = "󰂯";
            format-off = "󰂲";
            format-connected = "󰂯";
            format-disabled = "󰂲";
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
