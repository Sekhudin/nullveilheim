{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = true;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        libnotify
      ];
    };

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
