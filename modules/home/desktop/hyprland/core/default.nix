{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  imports = [
    ./bind.nix
    ./config.nix
    ./variable.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
    };
  };
}
