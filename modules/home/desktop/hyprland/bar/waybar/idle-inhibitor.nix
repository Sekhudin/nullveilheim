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
          "idle_inhibitor" = {
            format = "{icon} ";
            align = 0.5;
            justify = "center";
            signal = 8;
            tooltip = false;
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
        };
        secondary = primary;
      };
    };
  };
}
