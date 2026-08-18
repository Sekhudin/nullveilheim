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
  ecosystemEnabled = cfg.ecosystem.use == "default";

  inherit (color) mkRgb;
  inherit (extraLib.hyprland)
    mkEvent
    getVarRef
    events
    hl
    ;

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
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
              password_field_width = 250
              window_width         = 300
              window_height        = 200
              show_details         = false
          }
        '';
      };

      "hypr/hyprtoolkit.conf" = {
        text = ''
          background = ${mkRgb tokens.bg}
          base = 0xFF202020
          text = ${mkRgb tokens.fg}

          h1_size = 19
          h2_size = 15
          h3_size = 13
          font_size = 11
          small_font_size = 10

          icon_theme = ${config.homeCoreModules.iconTheme.name}
          font_family = ${font.family.sans_serif}
          font_family_monospace = ${font.family.monospace}

          rounding_large = ${toString styles.rounding}
          rounding_small = ${toString (styles.rounding - 4)}
        '';
      };
    };
  };
}
