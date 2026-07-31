{
  config,
  lib,
  color,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  isHyprpolkit = cfg.polkit.use == "hyprpolkitagent";

  _ = (color.mkTheme cfg.theme);
in
{
  config = lib.mkIf (cfg.enable && isHyprpolkit) {
    services = {
      hyprpolkitagent = {
        enable = true;
      };
    };

    xdg.configFile = {
      "hyprpolkitagent/hyprpolkitagent.conf" = {
        text = ''
          general {
              password_field_width = 340
              window_width         = 520
              window_height        = 440
              show_details         = true
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

          rounding_large = 10
          rounding_small = 5
        '';
      };
    };
  };
}
