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
  enableSwayOsd = (cfg.osd.use == "swayosd");
  inherit (color) mkOpacity toGtkTokenCss;
  inherit (extraLib) importModules;
  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";
  actions = var "actions";
in
{
  config = lib.mkIf (cfg.enable && enableSwayOsd) {
    home = {
      packages = map (module: module.app) (importModules {
        dir = ./actions;
        recursive = false;
        excludeDefault = true;
        args = {
          inherit
            pkgs
            actions
            ;
        };
      });
    };

    services = {
      swayosd = {
        enable = true;
        stylePath = "${config.xdg.configHome}/swayosd/style.css";
        topMargin = 0.9;
      };
    };

    xdg.configFile."swayosd/style.css".text = ''
      ${toGtkTokenCss (
        tokens
        // {
          bg = mkOpacity tokens.bg styles.opacity;
          fg = mkOpacity tokens.fg styles.opacity;
          progressbar = mkOpacity tokens.fg 0.3;
          segment = mkOpacity tokens.fg 0.2;
          segment-active = mkOpacity tokens.fg styles.opacity_mid;
        }
      )}

      window#osd {
        background: @bg;
        padding: ${toString styles.gaps_out}px;
        border: 1px solid @border;
        border-radius: ${toString styles.rounding}px;
      }

      window#osd #container {
        margin: ${toString styles.gaps_in}px;
      }

      window#osd image {
        -gtk-icon-transform: scale(0.8);
        color: @fg;
      }

      window#osd image:disabled {
        color: @fg;
        opacity: 1;
      }

      window#osd label {
        color: @fg;
        font-family: ${font.family.sans_serif};
        font-size: 16px;
        font-weight: bold;
      }

      window#osd segmentedprogress,
      window#osd progressbar {
        min-height: 6px;
        background: @progressbar;
        border: none;
        border-radius: 999px;
      }

      window#osd trough,
      window#osd segment {
        background: @segment;
        opacity: 1;
      }

      window#osd progress,
      window#osd segment.active {
        background: @segment-active;
      }

      window#osd segment:first-child {
      }
    '';
  };
}
