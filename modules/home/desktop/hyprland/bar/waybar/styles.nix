{
  config,
  lib,
  extraLib,
  color,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (color) toGtkTokenCss;
  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";

  composeStyle =
    {
      dir,
      style ? "",
      args ? { },
    }:
    let
      styleFiles = builtins.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix "-style.nix" name) (
          builtins.readDir dir
        )
      );
    in
    lib.concatStringsSep "\n" (
      lib.filter (s: s != "") ([ style ] ++ map (name: import "${dir}/${name}" args) styleFiles)
    );
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs.waybar.style = composeStyle {
      dir = ./styles;
      args = {
        inherit
          lib
          font
          styles
          ;
      };
      style = ''
        ${toGtkTokenCss tokens}

        * {
          font-family: ${font.family.monospace};
          font-size: ${toString font.sizes.bar}px;
          border: none;
          outline: none;
          box-shadow: none;
          text-shadow: none;
        }

        tooltip {
          opacity: 0;
          background: @bg;
          margin: 0px;
          padding: ${toString styles.gaps_in}px ${toString styles.padding_x}px;
          border-radius: ${toString styles.rounding}px;
        }

        window#waybar {
          color: @fg;
          background: transparent;
        }

        window#waybar button {
          padding: 0;
          margin: 0;
          min-width: 0;
          min-height: 0;
        }
      '';
    };
  };
}
