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
            decoration = {
              rounding = 8;
              shadow = {
                enabled = true;
              };
              blur = {
                enabled = true;
              };
            };
          };
        };
      };
    };
  };
}
