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
  enableHyprpolkit = cfg.polkit.use == "hyprpolkitagent";
  inherit (extraLib.hyprland) mkEvent events hl;

  _ = (color.mkTheme cfg.theme);
in
{
  config = lib.mkIf (cfg.enable && enableHyprpolkit) {
    home = {
      packages = with pkgs; [
        hyprpolkitagent
      ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        on = [
          (mkEvent {
            event = events.hyprland.start;
            action = [
              (hl.exec_cmd {
                cmd = "systemctl --user start hyprpolkitagent.service";
              })
            ];
          })

          (mkEvent {
            event = events.config.reloaded;
            action = [
              (hl.exec_cmd {
                cmd = "systemctl --user restart hyprpolkitagent.service";
              })
            ];
          })
        ];
      };
    };

    xdg.configFile = {
      "hyprpolkitagent/hyprpolkitagent.conf" = {
        text = ''
          general {
              password_field_width = 10
              window_width         = 10
              window_height        = 10
              show_details         = false
          }
        '';
      };

      "hypr/hyprtoolkit.conf" = {
        text = ''
          background = 0xFF181818
          base = 0xFF202020
          text = 0xFFDADADA
          alternate_base = 0xFF272727
          bright_text = 0xFFFFDEDE
          accent = 0xFF00FFCC
          accent_secondary = 0xFF0099F0

          h1_size = 19
          h2_size = 15
          h3_size = 13
          font_size = 11
          small_font_size = 10

          icon_theme =
          font_family = Sans Serif
          font_family_monospace = monospace

          rounding_large = 0
          rounding_small = 0
        '';
      };
    };
  };
}
