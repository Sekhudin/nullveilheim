{ config, extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;

  tokens = hypr.getVarValues config "tokens";
  community_palette = "Custom";
in
{
  programs.noctalia.settings.theme = {
    mode = "dark";
    shell_mode = "follow";
    source = "custom";
    builtin = "Nord";
    community_palette = "ADW";
    wallpaper_scheme = "m3-monochrome";
    custom_palette = community_palette;
  };

  xdg.configFile."noctalia/palettes/${community_palette}.json" = {
    text = builtins.toJSON rec {
      light = dark;
      dark = {
        mPrimary = tokens.primary;
        mOnPrimary = tokens.primary_fg;
        mSecondary = tokens.secondary;
        mOnSecondary = tokens.secondary_fg;
        mTertiary = tokens.accent;
        mOnTertiary = tokens.accent_fg;
        mError = tokens.destructive;
        mOnError = tokens.destructive_fg;
        mSurface = tokens.bg;
        mOnSurface = tokens.fg;
        mSurfaceVariant = tokens.muted;
        mOnSurfaceVariant = tokens.muted_fg;
        mOutline = tokens.border;
        mShadow = tokens.bg;
        mHover = tokens.input;
        mOnHover = tokens.fg;
        terminal = {
          background = tokens.bg;
          foreground = tokens.fg;
          cursor = tokens.secondary;
          cursorText = tokens.secondary_fg;
          selectionBg = tokens.muted;
          selectionFg = tokens.muted_fg;
          normal = {
            black = tokens.bg;
            red = tokens.destructive;
            green = tokens.success;
            yellow = tokens.warning;
            blue = tokens.info;
            magenta = tokens.accent;
            cyan = tokens.secondary;
            white = tokens.fg;
          };
          bright = {
            black = tokens.muted;
            red = tokens.destructive;
            green = tokens.success;
            yellow = tokens.warning;
            blue = tokens.info;
            magenta = tokens.accent;
            cyan = tokens.secondary;
            white = tokens.fg;
          };
        };
      };
    };
  };
}
