{
  pkgs,
  config,
  lib,
  extraLib,
  color,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (color) mkTokens;
  inherit (extraLib.hyprland) variables mkVar;

  tokens = mkTokens cfg.theme;
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
            monitor = "M";
            resize = "R";
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

          tokens = mkVar tokens;

          styles = mkVar {
            gaps_in = 4;
            gaps_out = 4;
            rounding = 12;
            font_family = font.family.sans_serif;
            border_size = 2;
            min_width = 16;
            min_height = 16;
            padding_x = 12;
            padding_y = 8;
            animation_ms = 300;
          };
        }
        variables
      ];
    };
  };
}
