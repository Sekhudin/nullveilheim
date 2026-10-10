{
  config,
  lib,
  color,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  toPalette =
    tokens:
    let
      mkTerminal =
        {
          background,
          foreground,
          cursor,
          cursorText,
          selectionBg,
          selectionFg,
          colors,
        }:
        {
          inherit
            background
            foreground
            cursor
            cursorText
            selectionBg
            selectionFg
            ;

          normal = {
            black = background;
            red = colors.destructive;
            green = colors.success;
            yellow = colors.warning;
            blue = colors.info;
            magenta = colors.accent;
            cyan = colors.secondary;
            white = foreground;
          };

          bright = {
            black = colors.muted;
            red = colors.destructive;
            green = colors.success;
            yellow = colors.warning;
            blue = colors.info;
            magenta = colors.accent;
            cyan = colors.secondary;
            white = foreground;
          };
        };

      mkSemantic =
        {
          background,
          foreground,
          surfaceVariant,
          onSurfaceVariant,
          hoverForeground,
          colors,
        }:
        {
          mPrimary = colors.primary;
          mOnPrimary = colors.primary_fg;

          mSecondary = colors.secondary;
          mOnSecondary = colors.secondary_fg;

          mTertiary = colors.accent;
          mOnTertiary = colors.accent_fg;

          mError = colors.destructive;
          mOnError = colors.destructive_fg;

          mSurface = background;
          mOnSurface = foreground;

          mSurfaceVariant = surfaceVariant;
          mOnSurfaceVariant = onSurfaceVariant;

          mOutline = colors.border;
          mShadow = background;

          mHover = colors.input;
          mOnHover = hoverForeground;
        };
    in
    {
      dark =
        (mkSemantic {
          background = tokens.bg;
          foreground = tokens.fg;
          surfaceVariant = tokens.muted;
          onSurfaceVariant = tokens.muted_fg;
          hoverForeground = tokens.fg;
          colors = tokens;
        })
        // {
          terminal = mkTerminal {
            background = tokens.bg;
            foreground = tokens.fg;
            cursor = tokens.secondary;
            cursorText = tokens.secondary_fg;
            selectionBg = tokens.selection;
            selectionFg = tokens.selection_fg;
            colors = tokens;
          };
        };

      light =
        (mkSemantic {
          background = tokens.fg;
          foreground = tokens.bg;
          surfaceVariant = tokens.fg;
          onSurfaceVariant = tokens.bg;
          hoverForeground = tokens.bg;
          colors = tokens;
        })
        // {
          terminal = mkTerminal {
            background = tokens.fg;
            foreground = tokens.bg;
            cursor = tokens.secondary;
            cursorText = tokens.bg;
            selectionBg = tokens.selection;
            selectionFg = tokens.bg;
            colors = tokens;
          };
        };
    };
in
{
  xdg = lib.mkIf cfg.enable {
    configFile = lib.mapAttrs' (
      name: _:
      lib.nameValuePair "noctalia/palettes/${name}.json" {
        text = builtins.toJSON (toPalette (color.mkTheme name).tokens);
      }
    ) color.themes;
  };
}
