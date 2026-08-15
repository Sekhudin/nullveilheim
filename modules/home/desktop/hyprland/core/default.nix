{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  imports = [
    ./binds
    ./ecosystem
    ./submaps
    ./config.nix
    ./env.nix
    ./monitor.nix
    ./variable.nix
    ./workspace-rule.nix
  ];

  config = lib.mkIf cfg.enable {
    wayland = {
      systemd = {
        target = "hyprland-session.target";
      };
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];

        config.common.default = [
          "hyprland"
          "gtk"
        ];
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
