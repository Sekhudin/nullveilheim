{
  config,
  lib,
  extraLib,
  color,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) getVarRef;
  inherit (color) mkOpacity toGtkTokenCss;

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";
in
{
  config = lib.mkIf cfg.enable {
    gtk = rec {
      enable = true;
      gtk3.extraCss = gtk4.extraCss;
      gtk4 = {
        extraCss = ''
          ${toGtkTokenCss (
            tokens
            // {
              bg = mkOpacity tokens.bg styles.opacity;
            }
          )}
        '';
      };
    };
  };
}
