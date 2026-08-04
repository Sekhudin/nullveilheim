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
        "hyprland/workspaces" = {
          format = "{name}";
          orientation = "horizontal";
          persistent-only = false;
          active-only = false;
          disable-scroll = true;
          tooltip = false;
        };
      };
    };
  };
}
