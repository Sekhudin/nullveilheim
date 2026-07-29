{
  config,
  lib,
  extraLib,
  color,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) variables mkVar;

  themeColor = (color.mkTheme cfg.theme);
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = lib.mkMerge [
        {
          terminal = (mkVar config.homeTerminalModules.use);
          browser = (mkVar "firefox");
          editor = (mkVar "nvim");

          active_border = (mkVar themeColor.scheme.base08);
          inactive_border = (mkVar themeColor.scheme.base00);

          cursor_theme = (mkVar "Bibata-Modern-Ice");
          cursor_size = (mkVar 24);
        }
        variables
      ];
    };
  };
}
