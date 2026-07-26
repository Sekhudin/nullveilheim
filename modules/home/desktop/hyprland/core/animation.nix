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
            animations = {
              enabled = true;
            };
            animation = [
              {
                leaf = "windows";
                enabled = true;
                speed = 5;
                curve = "default";
              }

              {
                leaf = "border";
                enabled = true;
                speed = 5;
                curve = "default";
              }

              {
                leaf = "fade";
                enabled = true;
                speed = 5;
                curve = "default";
              }

              {
                leaf = "workspaces";
                enabled = true;
                speed = 6;
                curve = "default";
              }
            ];
          };
        };
      };
    };
  };
}
