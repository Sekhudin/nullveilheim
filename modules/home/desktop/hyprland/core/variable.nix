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
            "$mod" = "SUPER";
            "$terminal" = "ghostty";
            "$browser" = "firefox";
          };
        };
      };
    };
  };
}
