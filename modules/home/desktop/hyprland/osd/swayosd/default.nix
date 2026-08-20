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
        topMargin = 0.5;
      };
    };

    xdg.configFile."swayosd/style.css".text = ''
      ${toGtkTokenCss (
        tokens
        // {
          bg = mkOpacity tokens.bg 0.8;
        }
      )}

      window#osd {
        background: @bg;
        padding: ${toString styles.gaps_out}px;
        border: 1px solid @border;
        border-radius: 0px;
      }

      window#osd #container {
        margin: 2px;
        background: @primary;
      }

      window#osd image {
      }

      window#osd label {
      }

      window#osd progressbar:disabled {
      }

      window#osd image:disabled {
      }

      window#osd progressbar {
      }

      window#osd segmentedprogress {
      }

      window#osd trough {
      }

      window#osd segment {
      }

      window#osd progress {
      }

      window#osd segment.active {
      }

      window#osd segment:first-child {
      }
    '';
  };
}
