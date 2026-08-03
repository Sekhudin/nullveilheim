{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) dsp;
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
          on-click = ''hyprctl dispatch "${
            dsp.window.fullscreen {
              mode = "maximized";
              action = "toggle";
              layout_aware = true;
            }
          }"'';
        };
      };
    };
  };
}
