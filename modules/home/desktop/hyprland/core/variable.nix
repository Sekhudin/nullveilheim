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

  theme = (color.mkTheme cfg.theme);
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
          monitors = mkVar {
            edp_1 = "eDP-1";
            hdmia_1 = "HDMI-A-1";
          };

          submaps = mkVar {
            monitor = "monitor";
            resize = "resize";
          };

          cursor_theme = (mkVar "Bibata-Modern-Ice");
          cursor_size = (mkVar 24);

          active_border = (mkVar theme.scheme.base08);
          inactive_border = (mkVar theme.scheme.base00);

          terminal = (mkVar config.homeTerminalModules.use);
          browser = (mkVar "firefox");
          editor = (mkVar "nvim");
        }
        variables
      ];
    };
  };
}
