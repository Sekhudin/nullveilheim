{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  imports = [
    ./animation.nix
    ./decoration.nix
    ./general.nix
    ./input.nix
    ./monitor.nix
    ./variable.nix
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
