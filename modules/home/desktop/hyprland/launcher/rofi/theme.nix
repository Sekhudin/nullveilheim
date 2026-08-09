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
            font = "${font.family.sans_serif} ${toString font.sizes.desktop}";
          };
          literal = tokens // {
            bg = color.mkOpacity tokens.bg 0.9;
            muted = color.mkOpacity tokens.muted 0.8;
            muted-selected = color.mkOpacity tokens.muted 0.4;

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
            width = "1368px";
            height = "768px";
            margin = "${
              toString ((7 * styles.gaps_out) + styles.min_height)
            }px ${toString styles.gaps_out}px ${toString styles.gaps_out}px ${toString styles.gaps_out}px";
            padding = "${toString styles.padding_y}px ${toString styles.padding_x}px";
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
            spacing = "100px";
            margin = "0px";
            padding = "100px 224px";
            children = ''[ "inputbar", "listview" ]'';
          };
        };

        inputbar = mkStyle {
          style = {
            enabled = true;
          };
          literal = {
            spacing = "8px";
            margin = "0% 25%";
            padding = "${toString (styles.padding_y * 2)}px ${toString (styles.padding_x * 1.5)}px";
            border_radius = "${toString styles.rounding}px";
            background_color = "@muted";
            text_color = "@fg";
            children = ''[ "entry" ]'';
          };
        };

        entry = mkStyle {
          style = {
            enabled = true;
            placeholder = "Search";
          };
          literal = {
            text-color = "inherit";
            cursor = "text";
            placeholder-color = "inherit";
          };
        };

        listview = mkStyle {
          style = {
            enabled = true;
            columns = 8;
            lines = 4;
            cycle = false;
            dynamic = true;
            scrollbar = false;
            layout = "vertical";
            reverse = false;
            fixed-height = true;
            fixed-columns = true;
          };
          literal = {
            spacing = "0px";
            margin = "0px";
            padding = "0px";
            cursor = "default";
          };
        };

        element = mkStyle {
          style = {
            enabled = true;
          };
          literal = {
            spacing = "16px";
            margin = "0px";
            padding = "36px 8px";
            border-radius = "${toString styles.rounding}px";
            orientation = "vertical";
            cursor = "pointer";
          };
        };

        "element normal.normal" = mkStyle {
          literal = {
          };
        };

        "element selected.normal" = mkStyle {
          literal = {
            background-color = "@muted-selected";
          };
        };

        element-icon = mkStyle {
          literal = {
            size = "72px";
            cursor = "inherit";
          };
        };

        element-text = mkStyle {
          literal = {
            highlight = "inherit";
            cursor = "inherit";
            vertical-align = "0.5";
            horizontal-align = "0.5";
          };
        };
      };
    };
  };
}
