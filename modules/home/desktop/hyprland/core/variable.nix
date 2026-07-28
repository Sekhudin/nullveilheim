{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) variables mkVar;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = lib.mkMerge [
        {
          terminal = (mkVar config.homeTerminalModules.use);
          browser = (mkVar "firefox");
          editor = (mkVar "nvim");
        }
        variables
      ];
    };
  };
}
