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

          apps = mkVar {
            terminal = config.homeTerminalModules.use;
            browser = "firefox";
            editor = "nvim";
          };

          cursor = mkVar {
            theme = "Bibata-Modern-Ice";
            size = 24;
          };

          styles = mkVar {
            active_border = theme.scheme.base08;
            inactive_border = theme.scheme.base00;
            gaps_in = 4;
            gaps_out = 4;
            rounding = 8;
          };
        }
        variables
      ];
    };
  };
}
