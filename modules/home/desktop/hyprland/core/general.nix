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
            general = {
              gaps_in = 5;
              gaps_out = 10;
              border_size = 2;
              layout = "dwindle";
              resize_on_border = true;
              allow_tearing = false;
            };
          };
        };
      };
    };
  };
}
