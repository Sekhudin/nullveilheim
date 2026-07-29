{
  pkgs,
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
    home = {
      packages = with pkgs; [
        bibata-cursors
      ];
    };

    wayland.windowManager.hyprland = {
      settings = lib.mkMerge [
        {
          layouts = mkVar [
            "dwindle"
            "master"
            "scrolling"
            "monocle"
          ];

          submap = mkVar {
            resize = "resize";
          };

          cursor_theme = (mkVar "Bibata-Modern-Ice");
          cursor_size = (mkVar 24);

          active_border = (mkVar themeColor.scheme.base08);
          inactive_border = (mkVar themeColor.scheme.base00);

          terminal = (mkVar config.homeTerminalModules.use);
          browser = (mkVar "firefox");
          editor = (mkVar "nvim");
        }
        variables
      ];
    };
  };
}
