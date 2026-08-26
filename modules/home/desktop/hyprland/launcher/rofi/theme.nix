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
  enableRofi = (cfg.launcher.use == "rofi");
  inherit (extraLib.hyprland) getVarRef;
  inherit (config.lib.formats.rasi) mkLiteral;

  mkStyle =
    p:
    (p.style or { })
    // lib.mapAttrs' (
      name: value: lib.nameValuePair (lib.replaceStrings [ "_" ] [ "-" ] name) (mkLiteral value)
    ) (p.literal or { });

  var = getVarRef config;

  cursor = var "cursor";
  tokens = var "tokens";
  styles = var "styles";
in
{
  config = lib.mkIf (cfg.enable && enableRofi) {
    programs = {
      rofi.theme = {
        "*" = mkStyle {
          style = {
          };
          literal = tokens // {
            bg = color.mkOpacity tokens.bg styles.opacity;
            input = color.mkOpacity tokens.input styles.opacity_mid;
            selected = color.mkOpacity tokens.muted styles.opacity_low;
            primary-selected = color.mkOpacity tokens.primary styles.opacity_low;

            text-color = "@fg";
            background-color = "transparent";
          };
        };

        window = mkStyle {
          style = {
            enabled = true;
            fullscreen = true;
            cursor = cursor.theme;
          };
          literal = {
            background-color = "@bg";
            margin = "${toString styles.margin_top}px ${toString styles.gaps_out}px ${toString styles.gaps_out}px ${toString styles.gaps_out}px";
            padding = "0px";
            spacing = "0px";
            border = "${toString styles.border_size}px solid";
            border-color = "@primary";
            border-radius = "${toString styles.rounding}px";
            children = ''[ "mainbox" ]'';
          };
        };

        mainbox = mkStyle {
          style = {
            enabled = true;
          };
          literal = {
            margin = "0px";
            padding = "92px 216px";
            spacing = "92px";
            children = ''[ "inputbar", "listview" ]'';
          };
        };

        inputbar = mkStyle {
          style = {
            enabled = true;
            font = "${font.family.sans_serif} ${toString font.sizes.desktop}";
          };
          literal = {
            text-color = "@fg";
            background-color = "@input";
            margin = "0% 25%";
            padding = "${toString (styles.padding_y * 1.5)}px ${toString (styles.padding_x * 1.5)}px";
            spacing = "0px";
            border = "${toString styles.border_size}px solid";
            border-color = "@border";
            border-radius = "${toString styles.rounding}px";
            children = ''[ "entry" ]'';
          };
        };

        entry = mkStyle {
          style = {
            enabled = true;
            font = "${font.family.sans_serif} ${toString font.sizes.desktop}";
            placeholder = "Search";
          };
          literal = {
            margin = "0px";
            padding = "0px";
            spacing = "0px";
            text-color = "inherit";
            cursor = "text";
            placeholder-color = "inherit";
          };
        };

        listview = mkStyle {
          style = {
            enabled = true;
            cycle = false;
            fixed-height = true;
            fixed-columns = true;
            columns = 8;
            lines = 4;
          };
          literal = {
            margin = "0px";
            padding = "0px";
            spacing = "${toString styles.gaps_in}px";
            layout = "vertical";
            flow = "horizontal";
            cursor = "default";
            children = ''[ "element" ]'';
          };
        };

        element = mkStyle {
          style = {
            enabled = true;
          };
          literal = {
            orientation = "vertical";
            margin = "0px";
            padding = "32px 8px";
            spacing = "${toString (styles.gaps_in * 2.0)}px";
            cursor = "pointer";
            border-radius = "${toString styles.rounding}px";
            children = ''[ "element-icon", "element-text" ]'';
          };
        };

        "element normal.normal" = mkStyle {
          literal = {
          };
        };

        "element selected.normal" = mkStyle {
          literal = {
            background-color = "@selected";
            border = "${toString styles.border_size}px solid";
            border-color = "@border";
          };
        };

        element-icon = mkStyle {
          literal = {
            size = "60px";
          };
        };

        element-text = mkStyle {
          style = {
            font = "${font.family.sans_serif} ${toString font.sizes.desktop}";
          };
          literal = {
            cursor = "inherit";
            vertical-align = "0.5";
            horizontal-align = "0.5";
          };
        };
      };
    };
  };
}
