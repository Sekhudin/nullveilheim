{
  pkgs,
  config,
  lib,
  extraLib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";

  inherit (extraLib.hyprland)
    getVarRef
    ;

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    home = {
      packages = with pkgs; [
        hyprtoolkit
      ];
    };

    xdg.configFile."hypr/hyprtoolkit.conf" = {
      text = ''
        general {
          background          = ${tokens.bg}
          base                = ${tokens.bg}
          text                = ${tokens.fg}
          alternate_base      = ${tokens.bg}
          bright_text         = ${tokens.fg}
          accent              = ${tokens.accent}
          accent_secondary    = ${tokens.accent}

          h1_size             = 19
          h2_size             = 15
          h3_size             = 13
          font_size           = ${toString font.sizes.desktop}
          small_font_size     = ${toString (font.sizes.desktop * 0.8)}

          icon_theme          = ${config.homeCoreModules.iconTheme.name}
          font_family         = ${font.family.sans_serif}
          font_family_monospace = ${font.family.monospace}

          rounding_large      = ${toString styles.rounding}
          rounding_small      = ${toString (styles.rounding - styles.gaps_in)}
        }
      '';
    };
  };
}
