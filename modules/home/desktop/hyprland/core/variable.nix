{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;

  terminal = {
    _var = config.homeTerminalModules.use;
  };
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        inherit terminal;

        mod = {
          _var = "SUPER";
        };

        browser = {
          _var = "firefox";
        };
      };
    };
  };
}
