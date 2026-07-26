{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland = {
      windowManager = {
        hyprland = {
          settings = {
            input = {
              kb_layout = "us";
              follow_mouse = 1;
              sensitivity = 0;
              touchpad = {
                natural_scroll = false;
                tap-to-click = true;
              };
            };
          };
        };
      };
    };
  };
}
