{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
        ];
      };
    };
  };
}
