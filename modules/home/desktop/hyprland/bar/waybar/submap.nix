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
        "hyprland/submap" = {
          format = "{submap}";
          justify = "center";
          default-submap = "normal";
          on-click = "";
          on-update = "";
          max-length = 10;
          tooltip = false;
          always-on = true;
        };
      };
    };
  };
}
