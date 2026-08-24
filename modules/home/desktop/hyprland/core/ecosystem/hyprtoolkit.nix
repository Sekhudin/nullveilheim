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

  fTokens = builtins.mapAttrs (
    name: val: "0xFF" + (if builtins.substring 0 1 val == "#" then builtins.substring 1 6 val else val)
  ) tokens;

  toStringInt = value: toString (builtins.floor value);
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
        background          = ${fTokens.bg}
        base                = ${fTokens.bg}
        text                = ${fTokens.fg}
        alternate_base      = ${fTokens.bg}
        bright_text         = ${fTokens.fg}
        accent              = ${fTokens.accent}
        accent_secondary    = ${fTokens.accent}

        h1_size             = 19
        h2_size             = 15
        h3_size             = 13
        font_size           = ${toString font.sizes.desktop}
        small_font_size     = ${toStringInt (font.sizes.desktop * 0.8)}

        icon_theme          = ${config.homeCoreModules.iconTheme.name}
        font_family         = ${font.family.sans_serif}
        font_family_monospace = ${font.family.monospace}

        rounding_large      = ${toString styles.rounding}
        rounding_small      = ${toString (styles.rounding - styles.gaps_in)}
      '';
    };
  };
}
