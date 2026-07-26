{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  imports = [
  ];

  config = lib.mkIf cfg.enable {
    wayland = {
      windowManager = {
        hyprland = {
          enable = true;
          configType = "lua";
        };
      };
    };
  };
}
