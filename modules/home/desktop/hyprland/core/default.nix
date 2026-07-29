{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  imports = [
    ./bind.nix
    ./config.nix
    ./env.nix
    ./monitor.nix
    ./variable.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
    };
  };
}
