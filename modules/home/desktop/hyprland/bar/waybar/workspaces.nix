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
          "hyprland/workspaces" = {
            format = "{name}";
            orientation = "horizontal";
            all-outputs = false;
            move-to-monitor = false;
            persistent-only = false;
            active-only = false;
            disable-scroll = true;
            tooltip = true;
          };
        };
        secondary = primary;
      };
    };
  };
}
