{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  imports = [
    ./binds
    ./submaps
    ./config.nix
    ./env.nix
    ./monitor.nix
    ./portal.nix
    ./variable.nix
    ./workspace-rule.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland = {
      systemd = {
        target = "hyprland-session.target";
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd = {
        enable = true;
      };
    };
  };
}
